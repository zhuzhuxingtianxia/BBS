//
//  HMarketScrollView.m
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "HMarketScrollView.h"
#import <YYKit/YYKit.h>
#import "NetworkService.h"
#import "HMarketClassTableView.h"
#import "HMarketGoodsTableView.h"
#import "HMarketSubClassCollectionView.h"

@interface HMarketScrollView ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIView *headerView;
@property (strong, nonatomic)HMarketClassTableView *leftTable;
@property (strong, nonatomic)HMarketGoodsTableView *rightTalbe;
@property (strong, nonatomic)HMarketSubClassCollectionView *subClassCollectionView;

@property (nonatomic) CGPoint initOffset;

@end
@implementation HMarketScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        self.canScroll = YES;
        [self addSubview:self.headerView];
        [self addSubview:self.leftTable];
        [self addSubview:self.subClassCollectionView];
        [self addSubview:self.rightTalbe];
        
        [self setup];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.headerView.frame = CGRectMake(0, 0, self.width, 110);
    
    self.leftTable.frame = CGRectMake(0, self.headerView.bottom, 100, self.height);
    self.subClassCollectionView.frame = CGRectMake(self.leftTable.right, self.leftTable.top, self.width - 100, 50);
    self.rightTalbe.frame = CGRectMake(self.leftTable.right, self.subClassCollectionView.bottom, self.subClassCollectionView.width, self.leftTable.height - self.subClassCollectionView.height);
    
    self.contentSize = CGSizeMake(self.width, self.leftTable.bottom);
}

-(void)setup {
    __weak typeof(self) weakSelf = self;
    self.leftTable.didSelectClassBlock = ^(NSString *classID) {
       
        weakSelf.rightTalbe.classID = classID;
        
    };
    
    self.rightTalbe.scrollChangeBlockForSPU = ^(NSString *classID) {
       
        weakSelf.leftTable.classID = classID;
        weakSelf.subClassCollectionView.classID = classID;
    };
    
    self.subClassCollectionView.didSelectBlock = ^(NSString *classID) {
        
        weakSelf.rightTalbe.classID = classID;
        
    };
    
}

-(void)reloadUI {
    
    [self.leftTable reloadData];
    [self.rightTalbe reloadData];
}

#pragma mark -- setter
- (void)setMarketID:(NSString *)marketID{
    _marketID = marketID;
    [self loadData];
}

- (void)setGoodsID:(NSString *)goodsID{
    _goodsID = goodsID;
    self.rightTalbe.goodsID = goodsID;
}

- (void)setActivityID:(NSString *)activityID{
    _activityID = activityID;
    self.rightTalbe.activityID = activityID;
}

- (void)setClasses:(NSArray<TCMMarketGoodsClassModel *> *)classes{
    
    classes.firstObject.isSelected = YES;
    classes.firstObject.childs.firstObject.isSelected = YES;
    
    classes.firstObject.childs.firstObject.childs.firstObject.isSelected = YES;
    for (TCMMarketGoodsClassModel *data in classes) {
        data.marketID = self.marketID;
    }
    _classes = classes;
    self.leftTable.classes = _classes;
    self.rightTalbe.classes = _classes;
    self.secondClasses = classes.firstObject.childs;
}

- (void)setSecondClasses:(NSArray<TCMMarketGoodsClassModel *> *)secondClasses{
    _secondClasses = secondClasses;
    [secondClasses enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            obj1.isSelected = (idx == 0 && idx1 == 0) ? YES : NO;
        }];
    }];
    self.subClassCollectionView.classes = secondClasses;

}
- (void)setCanScroll:(BOOL)canScroll{
    if (canScroll != _canScroll) {
        
    }
    _canScroll = canScroll;
    if (canScroll) {
        self.canNotScrollToBottom = NO;
    }
}

#pragma mark -- loadData
- (void)loadData {
    
    NSMutableDictionary *paras = [[NSMutableDictionary alloc]init];
    [paras setValue:@"31.23850353" forKey:@"plotarea_lng"];
    [paras setValue:@"121.39622280" forKey:@"plotarea_lat"];
    [paras setValue:self.marketID forKey:@"marketId"];
    [paras setValue:self.goodsID forKey:@"goodsId"];
    [paras setValue:self.activityID forKey:@"activity_id"];
    
    [NetworkService sendRequestWithUrl:@"buyer/market/goods/classify/classes" parameters:paras completionHandler:^(id  _Nonnull responseObject, NSError * _Nonnull err) {
        if (!err) {
            NSArray *classes = [TCMMarketGoodsClassModel modelArrayWithKeyValuesArray:responseObject[@"objs"]];
            
            self.classes = classes;
            
            NSString *spuID = responseObject[@"refGoodsClassify"];
            if (spuID.length) {
                self.leftTable.classID = spuID;
                self.rightTalbe.classID = spuID;
                self.subClassCollectionView.classID = spuID;
            }
        }
        
    }];
}

#pragma mark -- UIScrollViewDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat bottomCellOffset = CGRectGetHeight(_headerView.frame);
    NSLog(@"sssss %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.rightTalbe.canScroll = YES;
            self.leftTable.canScroll = YES;
        }
    }else{
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }else{
            if (self.canNotScrollToBottom && scrollView.contentOffset.y <= self.initOffset.y) {
                CGPoint offset = scrollView.contentOffset;
                offset.y = self.initOffset.y;
                scrollView.contentOffset = offset;
            }
        }
    }
    self.showsVerticalScrollIndicator = _canScroll;
    self.initOffset = scrollView.contentOffset;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < -110) {
        
    }
}


#pragma mark -- getter
-(UIView*)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor brownColor];
    }
    return _headerView;
}

-(HMarketClassTableView*)leftTable {
    if (!_leftTable) {
        _leftTable = [[HMarketClassTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _leftTable;
}

-(HMarketGoodsTableView*)rightTalbe {
    if (!_rightTalbe) {
        _rightTalbe = [[HMarketGoodsTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _rightTalbe;
}

-(HMarketSubClassCollectionView*)subClassCollectionView {
    if (!_subClassCollectionView) {
        UICollectionViewFlowLayout *flowLatout = [[UICollectionViewFlowLayout alloc] init];
        flowLatout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _subClassCollectionView = [[HMarketSubClassCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLatout];
    }
    return _subClassCollectionView;
}
-(void)dealloc {
    NSLog(@"%s",__func__);
}
@end
