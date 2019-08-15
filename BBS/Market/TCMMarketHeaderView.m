//
//  TCMMarketHeaderView.m
//  BBS
//
//  Created by ZZJ on 2019/8/13.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMMarketHeaderView.h"
#import "TCMPageView.h"

@interface TCMMarketHeaderView ()
@property(nonatomic,strong)TCMPageView *pageView;
@property (nonatomic,strong)UILabel  *label;
@end
@implementation TCMMarketHeaderView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pageView];
        self.pageView.frame = CGRectMake(0, 0, frame.size.width, 80);
        
        [self addSubview:self.label];
        
        self.label.frame = CGRectMake(0, CGRectGetHeight(self.pageView.frame), frame.size.width, frame.size.height - self.pageView.frame.size.height);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- getter
-(TCMPageView*)pageView {
    if (!_pageView) {
        _pageView = [[TCMPageView alloc] init];
        _pageView.autoScroll = YES;
        _pageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _pageView.imageViewContentMode = UIViewContentModeScaleAspectFill;
        _pageView.imageURLStrings = @[@"http://b.hiphotos.baidu.com/zhidao/pic/item/d50735fae6cd7b89172e57f10c2442a7d9330e05.jpg",@"http://pic16.nipic.com/20111006/6239936_092702973000_2.jpg", @"http://pic16.nipic.com/20111002/8445207_103735517143_2.jpg",
                                      @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"];
    }
    return _pageView;
}

-(UILabel*)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"其他内容";
    }
    return _label;
}

@end
