//
//  MarketGoodsController.h
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketGoodsController : UIViewController

@property(nonatomic,strong)NSArray<TCMMarketGoodsClassModel*> *classArray;
@property(nonatomic,copy)NSString *classId;

@property(nonatomic,copy)NSString *goodsID;

@property (nonatomic) BOOL canScroll;

@end

NS_ASSUME_NONNULL_END
