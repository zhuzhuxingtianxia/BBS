//
//  HMarketViewController.h
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMarketViewController : UIViewController
@property (nonatomic, copy) NSString *marketID;
@property (nonatomic, copy) NSString *marketName;//可不传值
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *activityID;

@end

NS_ASSUME_NONNULL_END
