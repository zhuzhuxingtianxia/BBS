//
//  HMarketGoodsTableView.m
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "HMarketGoodsTableView.h"
#import <YYKit/YYKit.h>
#import "HMarketScrollView.h"
#import "TCMMarketGoodsTableCell.h"
#import "NetworkService.h"

@interface HMarketGoodsTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray <TCMMarketGoodsSectionModel *>*showDatas;
@property (nonatomic)NSInteger section;
@property (nonatomic, weak) HMarketScrollView *mySuperView;
@property (nonatomic) BOOL drag;
@property (nonatomic) NSIndexPath *taregtIndexPath;

@end

@implementation HMarketGoodsTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 60;
        self.sectionHeaderHeight = 20;
        self.rowHeight = UITableViewAutomaticDimension;
        [self registerNib:[UINib nibWithNibName:TCMMarketGoodsTableCell.className bundle:nil] forCellReuseIdentifier:TCMMarketGoodsTableCell.className];
        [self registerClass:TCMMarketGoodsSectionCell.class forHeaderFooterViewReuseIdentifier:TCMMarketGoodsSectionCell.className];
    }
    return self;
}

#pragma mark -- setter
- (void)setClasses:(NSArray<TCMMarketGoodsClassModel *> *)classes{
    _classes = classes;
    [self packgeData];
    [self reloadData];
}

- (void)setClassID:(NSString *)classID{
    _classID = classID;
    [self.showDatas enumerateObjectsUsingBlock:^(TCMMarketGoodsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sectionHeaderData.firstClassID isEqualToString:classID] || [obj.sectionHeaderData.classId isEqualToString:classID]) {
            if (self.showDatas[idx].rowsData.count > 0) {
                self.drag = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
                self.taregtIndexPath = indexPath;
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                *stop = YES;
            }
            if (idx != 0) {
                self.canScroll = YES;
                self.mySuperView.canNotScrollToBottom = YES;
            }else{
                self.mySuperView.canNotScrollToBottom = NO;
                self.canScroll = NO;
            }
        }
    }];
}

- (void)packgeData{
    self.showDatas = [NSMutableArray array];
    for (TCMMarketGoodsClassModel *data in _classes) {
        for (TCMMarketGoodsClassModel *secondChildData in data.childs) {
            for (TCMMarketGoodsClassModel *thirdChildData in secondChildData.childs) {
                TCMMarketGoodsSectionModel *showData = [[TCMMarketGoodsSectionModel alloc]init];
                showData.sectionHeaderData = thirdChildData;
                
                if ([thirdChildData.classId isEqualToString:@"discountCouponRule"]) {
                    TCMMarketGoodsModel *rowData = [[TCMMarketGoodsModel alloc]init];
                    rowData.marketId = thirdChildData.marketID;
                    
                    [showData.rowsData addObject:rowData];
                }else if ([thirdChildData.classId isEqualToString:@"storeVoucher"]){
                    TCMMarketGoodsModel *rowData = [[TCMMarketGoodsModel alloc]init];
                    rowData.marketId = thirdChildData.marketID;
                    
                    [showData.rowsData addObject:rowData];
                }else{
                    TCMMarketGoodsModel *rowData = [[TCMMarketGoodsModel alloc]init];
                    rowData.marketId = thirdChildData.marketID;
                    rowData.classsify_id = thirdChildData.classId;
                    [showData.rowsData addObject:rowData];
                    
                }
                [self.showDatas addObject:showData];
            }
        }
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDatas[section].rowsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCMMarketGoodsSectionModel *showModel = self.showDatas[indexPath.section];
    id data = showModel.rowsData[indexPath.row];
    if ([data isKindOfClass:[TCMMarketGoodsModel class]]) {
        TCMMarketGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TCMMarketGoodsTableCell.className];
        
        cell.data = data;
//        cell.goodsOperateBlock = ^(TCMMarketGoodsModel *goods, TCMGoodsOperateType type) {
//            if (self.goodsOperateBlock) {
//                self.goodsOperateBlock(goods, type);
//            }
//        };
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TCMMarketGoodsSectionCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TCMMarketGoodsSectionCell.className];
    cell.sectionModel = self.showDatas[section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    TCMMarketGoodsSectionModel *showModel = self.showDatas[section];
    TCMMarketGoodsModel *data = showModel.rowsData[0];
    if ([data isKindOfClass:[NSArray class]]) {
        return;
    }
    // !!!: ⚠️
    [self loadGoodsDataWithMarketID:data.marketId calssId:data.classsify_id];
}
- (void)loadGoodsDataWithMarketID:(NSString *)marketID calssId:(NSString*)calssId{
    if (!calssId) {
        return;
    }
    NSMutableDictionary *paras = [[NSMutableDictionary alloc]init];
    
    [paras setValue:@"" forKey:@"plotarea_lng"];
    [paras setValue:@"" forKey:@"plotarea_lat"];
    [paras setValue:marketID forKey:@"marketId"];
    [paras setValue:calssId forKey:@"spuId"];
    [paras setValue:self.goodsID forKey:@"goodsId"];
    [paras setValue:self.activityID forKey:@"activity_id"];
    
    [NetworkService sendRequestWithUrl:@"buyer/market/goods/listgoods" parameters:paras completionHandler:^(NSDictionary *dic, NSError *connectionError) {
        if (dic) {
            NSMutableArray<TCMMarketGoodsModel*> *goodsList = [TCMMarketGoodsModel modelArrayWithJSON:dic[@"goodsList"]];
            if ([calssId isEqualToString:@"redemption"]) {
                NSLog(@"%@",dic);
            }
            for (TCMMarketGoodsSectionModel *showData in self.showDatas) {
                if ([calssId isEqualToString:showData.sectionHeaderData.classId] && goodsList.count > 0) {
                    if ([goodsList.firstObject.goods_id isEqualToString:self.goodsID]) {
                        goodsList.firstObject.highlight = YES;
                    }
                    showData.rowsData = goodsList;
                    [self reloadData];
                    if (self.taregtIndexPath) {
                        [self scrollToRowAtIndexPath:self.taregtIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
            }
        }
        
    }];
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.drag = YES;
    self.taregtIndexPath = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.drag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"ggggg %f",scrollView.contentOffset.y);
    
    NSIndexPath *indexPath = self.indexPathsForVisibleRows.firstObject;
    if (indexPath.section != self.section) {
        self.section = indexPath.section;
        if (self.scrollChangeBlockForSPU && self.drag) {
            self.scrollChangeBlockForSPU(self.showDatas[self.section].sectionHeaderData.classId);
        }
    }
    
    if (indexPath.section != 0 && indexPath.row != 0){
        self.mySuperView.canNotScrollToBottom = YES;
    }
    
    if (!self.canScroll && self.drag) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y <= 0 && self.drag && indexPath.section == 0) {
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        self.mySuperView.canScroll = YES;
    }
    self.showsVerticalScrollIndicator = _canScroll;
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
-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
