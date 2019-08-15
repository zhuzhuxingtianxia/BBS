//
//  HMarketClassTableView.h
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMMarketGoodsClassModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DidSelectClassBlock)(NSString *classID);

@interface HMarketClassTableView : UITableView

@property (nonatomic) BOOL canScroll;
@property (nonatomic, strong) NSArray <TCMMarketGoodsClassModel*> *classes;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) DidSelectClassBlock didSelectClassBlock;

@end

NS_ASSUME_NONNULL_END
