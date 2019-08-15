//
//  HMarketViewController.m
//  BBS
//
//  Created by ZZJ on 2019/8/14.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "HMarketViewController.h"
#import <YYKit/YYKit.h>
#import "HMarketScrollView.h"
#import "NetworkService.h"

@interface HMarketViewController ()
@property (strong, nonatomic)HMarketScrollView *marketScrollView;
@end

@implementation HMarketViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.marketScrollView reloadUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.marketID = @"867556548865761280";//长风
    
    [self buildView];
    
    [self loadData];
}

-(void)buildView {
    
    [self.view addSubview:self.marketScrollView];
    
    self.marketScrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
}

//赋值时注意顺序，marketID须最后调用
- (void)loadData{
    self.marketScrollView.activityID = self.activityID;
    self.marketScrollView.goodsID = self.goodsID;
    self.marketScrollView.marketID = self.marketID;
}

- (void)setGoodsID:(NSString *)goodsID{
    _goodsID = goodsID;
    [self loadData];
}

-(HMarketScrollView*)marketScrollView {
    if (!_marketScrollView) {
        _marketScrollView = [[HMarketScrollView alloc] init];
    }
    return _marketScrollView;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
