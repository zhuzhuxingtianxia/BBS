//
//  HMarketScrollView.h
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMarketScrollView : UIScrollView

@property (nonatomic) BOOL canScroll;
@property (nonatomic) BOOL canNotScrollToBottom;//不能向下滚动
@property (readonly, nonatomic)UIView *headerView;

@property (strong, nonatomic) NSArray <TCMMarketGoodsClassModel*> *classes;

@property (strong, nonatomic) NSArray <TCMMarketGoodsClassModel*> *secondClasses;

@property (nonatomic,copy) NSString *marketID;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *activityID;

//刷新界面
-(void)reloadUI;

@end

NS_ASSUME_NONNULL_END
