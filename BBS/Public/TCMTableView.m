//
//  TCMTableView.m
//  BBS
//
//  Created by ZZJ on 2019/8/13.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMTableView.h"

@implementation TCMTableView

-(void)setCanScroll:(BOOL)canScroll {
    
    _canScroll = canScroll;
    if (canScroll) {
        self.canNotScrollToBottom = NO;
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
