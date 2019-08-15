//
//  HMarketClassTableView.m
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "HMarketClassTableView.h"
#import <YYKit/YYKit.h>
#import "HMarketScrollView.h"
#import "TCMMarketGoodsTableCell.h"

@interface HMarketClassTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) HMarketScrollView *mySuperView;
@property (nonatomic) BOOL drag;
@property (nonatomic, strong) UIView *moveLine;

@end

@implementation HMarketClassTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.bounces = YES;
        self.alwaysBounceVertical = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:TCMClassTableViewCell.class forCellReuseIdentifier:NSStringFromClass(TCMClassTableViewCell.class)];
        [self addSubview:self.moveLine];
    }
    return self;
}

#pragma mark -- setter
- (void)setClasses:(NSArray<TCMMarketGoodsClassModel *> *)classes{
    _classes = classes;
    [self reloadData];
    if (self.contentSize.height <= self.height) {
        self.contentSize = CGSizeMake(self.width, self.height+2);
    }
    if (classes.count) {
        [self performAnimateForLine:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)setClassID:(NSString *)classID{
    _classID = classID;
    [self.classes enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [obj1.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            [obj2.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                if ([obj2.classId isEqualToString:classID] || [obj3.classId isEqualToString:classID]) {
                    [self.classes enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.isSelected = (idx == idx1) ? YES : NO;
                    }];
                    [self reloadData];
                    self.mySuperView.secondClasses = self.classes[idx1].childs;
                    if (self.classes.count > 0) {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:idx1 inSection:0];
                        [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        [self performAnimateForLine:path];
                    }
                    *stop1 = YES;
                    *stop2 = YES;
                    *stop3 = YES;
                }
            }];
            
        }];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCMClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TCMClassTableViewCell.className forIndexPath:indexPath];
    cell.classModel = self.classes[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.mySuperView.secondClasses = self.classes[indexPath.row].childs;
    if (self.didSelectClassBlock) {
        self.didSelectClassBlock(self.classes[indexPath.row].classId);
    }
    __block NSInteger index;
    [self.classes enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row){
            obj.isSelected = YES;
            index = idx;
        }else{
            obj.isSelected = NO;
            
        }
    }];
    [self reloadData];
    NSIndexPath *idexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self performAnimateForLine:idexPath];
    
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.drag = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    self.drag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll && self.drag) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        self.mySuperView.canScroll = YES;
    }
    self.showsVerticalScrollIndicator = _canScroll;
}

#pragma mark -- privte

- (void)performAnimateForLine:(NSIndexPath *)idexPath {
    [self selectRowAtIndexPath:idexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:.7 options: UIViewAnimationOptionCurveLinear animations: ^{
        UITableViewCell *cell = [self cellForRowAtIndexPath:idexPath];
        self.moveLine.frame = CGRectMake(0, cell.top, 3, cell.height);
    } completion:nil];
}



#pragma mark -- getter
- (UIView *)moveLine{
    if (!_moveLine) {
        _moveLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
        _moveLine.backgroundColor = [UIColor colorWithHexString:@"#ff0033"];
    }
    return _moveLine;
}
- (HMarketScrollView *)mySuperView{
    if (!_mySuperView) {
        for (UIView *next = [self superview]; next; next = next.superview) {
            if ([next isKindOfClass:[HMarketScrollView class]]) {
                _mySuperView = (HMarketScrollView *)next;
                break;
            }
        }
    }
    return _mySuperView;
}


@end
