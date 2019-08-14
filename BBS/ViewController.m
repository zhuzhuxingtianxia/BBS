//
//  ViewController.m
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "ViewController.h"
#import "TCMCartNetwork.h"
#import "MarketViewController.h"

@interface ViewController ()
@property(nonatomic,strong)TCMCartNetwork *cart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _cart = [TCMCartNetwork new];
}
- (IBAction)pushAction:(id)sender {
    MarketViewController *market = [MarketViewController new];
    [self.navigationController pushViewController:market animated:YES];
}
- (IBAction)pushClassId:(id)sender {
    MarketViewController *market = [MarketViewController new];
    //选中分类
    market.classId = @"65733";
    [self.navigationController pushViewController:market animated:YES];
    
}
- (IBAction)pushGoodsId:(id)sender {
    MarketViewController *market = [MarketViewController new];
    //选中商品
    market.goodsID = @"65733";
    [self.navigationController pushViewController:market animated:YES];
}

//遍历比较
- (IBAction)clickAction:(id)sender {
    [_cart buildData];
}
- (IBAction)startaction:(id)sender {
    [_cart queryData];
}

@end
