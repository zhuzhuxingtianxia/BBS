//
//  TCMTableView.h
//  BBS
//
//  Created by ZZJ on 2019/8/13.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMTableView : UITableView
@property (nonatomic) BOOL canScroll;
@property (nonatomic) BOOL canNotScrollToBottom;//不能向下滚动
@property (nonatomic) CGPoint initOffset;

@end

NS_ASSUME_NONNULL_END
