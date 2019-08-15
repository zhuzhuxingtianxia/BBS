//
//  HMarketGoodsTableView.h
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TCMGoodsOperateType) {
    TCMGoodsOperateTypePlus,
    TCMGoodsOperateTypeReduce,
    TCMGoodsOperateTypeDetail,
    TCMGoodsOperateTypeStore
};
typedef void(^ScrollChangeBlock)(NSString *classID);
typedef void(^GoodsOperateBlock)(TCMMarketGoodsModel *goods,TCMGoodsOperateType type);

@interface HMarketGoodsTableView : UITableView

@property (nonatomic) BOOL canScroll;
@property (strong, nonatomic) NSArray <TCMMarketGoodsClassModel*> *classes;
@property (nonatomic, copy) ScrollChangeBlock scrollChangeBlockForSPU;
@property (nonatomic, copy) GoodsOperateBlock goodsOperateBlock;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *activityID;

@end

NS_ASSUME_NONNULL_END
