//
//  HMarketSubClassCollectionView.m
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "HMarketSubClassCollectionView.h"
#import <YYKit/YYKit.h>
#import "HMarketScrollView.h"

@interface HMarketSubClassCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation HMarketSubClassCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}
#pragma mark -- getter
-(UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}
@end


@interface HMarketSubClassCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) HMarketScrollView *mySuperView;
@end

@implementation HMarketSubClassCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (!layout) {
        UICollectionViewFlowLayout *flowLatout = [[UICollectionViewFlowLayout alloc] init];
        flowLatout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout = flowLatout;
    }
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:HMarketSubClassCollectionViewCell.class forCellWithReuseIdentifier:HMarketSubClassCollectionViewCell.className];
    }
    return self;
}

#pragma mark -- setter

- (void)setClasses:(NSArray<TCMMarketGoodsClassModel *> *)classes{
    _classes = classes;
    
    [self reloadData];
}

- (void)setClassID:(NSString *)classID{
    _classID = classID;
    __block NSUInteger section = 0;
    __block NSUInteger row = 0;
    [self.classes enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [obj1.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if ([obj2.classId isEqualToString:classID]) {
                obj2.isSelected =  YES;
                section = idx1;
                row = idx2;
            }else{
                obj2.isSelected =  NO;
            }
        }];
    }];
    [self reloadData];
    if (self.classes.count > 0 && self.classes[section].childs.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:(section == 0 && row == 0) || (section == self.classes.count - 1 && row == self.classes.lastObject.childs.count - 1) ? NO : YES];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.classes.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classes[section].childs.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMMarketGoodsClassModel *data = self.classes[indexPath.section].childs[indexPath.row];
    CGSize size = [data.className sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    return CGSizeMake(size.width+20, 27);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMarketSubClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HMarketSubClassCollectionViewCell.className forIndexPath:indexPath];
    TCMMarketGoodsClassModel *data = self.classes[indexPath.section].childs[indexPath.row];
    cell.textLabel.text = data.className;
    cell.textLabel.textColor = data.isSelected  ? [UIColor colorWithHexString:@"#ff0033"] : [UIColor colorWithHexString:@"#333333"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectBlock) {
        NSString *classID = self.classes[indexPath.section].childs[indexPath.row].classId;
        self.classID = classID;
        self.didSelectBlock(classID);
    }
}

#pragma mark -- getter
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
