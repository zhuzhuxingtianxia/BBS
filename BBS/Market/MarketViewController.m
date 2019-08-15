//
//  MarketViewController.m
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketGoodsController.h"
#import <YYKit/YYKit.h>
#import "TCMTableView.h"
#import "TCMMarketGoodsClassModel.h"
#import "NetworkService.h"
#import "TCMMarketHeaderView.h"

@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)TCMTableView *contentTable;
@property (nonatomic,strong)MarketGoodsController *marketGoods;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTable.frame = self.view.bounds;
    [self.view addSubview:self.contentTable];
    TCMMarketHeaderView *headerView = [[TCMMarketHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.contentTable.tableHeaderView = headerView;
    
    _marketGoods = [MarketGoodsController new];
    _marketGoods.view.height = self.view.height - 64;
    [self addChildViewController:_marketGoods];
    _marketGoods.classId = self.classId;
    _marketGoods.goodsID = self.goodsID;
    
    self.marketID = @"867556548865761280";//长风
    
    [self loadData];
}

-(void)loadData {
    //请求前模拟数据填充
    NSMutableArray<TCMMarketGoodsClassModel*> *tempClasses = [NSMutableArray arrayWithCapacity:20];
    for (NSInteger i = 0; i < 20; i++) {
        TCMMarketGoodsClassModel *model = [TCMMarketGoodsClassModel new];
        model.className = @"";
        [tempClasses addObject:model];
    }
   self.marketGoods.classArray = tempClasses;
    
    NSMutableDictionary *paras = [[NSMutableDictionary alloc]init];
    [paras setValue:@"31.23850353" forKey:@"plotarea_lng"];
    [paras setValue:@"121.39622280" forKey:@"plotarea_lat"];
    [paras setValue:self.marketID forKey:@"marketId"];
    [paras setValue:self.goodsID forKey:@"goodsId"];
    [paras setValue:self.activityID forKey:@"activity_id"];
    __weak typeof(self) weakSelf = self;
    [NetworkService sendRequestWithUrl:@"buyer/market/goods/classify/classes" parameters:paras completionHandler:^(id  _Nonnull responseObject, NSError * _Nonnull err) {
        if (!err) {
            
            NSArray<TCMMarketGoodsClassModel*> *classes = [TCMMarketGoodsClassModel modelArrayWithKeyValuesArray:responseObject[@"objs"]];
            [classes enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.marketID = self.marketID;
            }];
            
            weakSelf.marketGoods.classArray = classes;
        }
        
    }];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 400;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  _marketGoods.view.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _marketGoods.view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentTable) {
        CGFloat bottomCellOffset = _contentTable.tableHeaderView.height;
        CGFloat y = scrollView.contentOffset.y;
        NSLog(@"---- %f",y);
        if (y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (_contentTable.canScroll) {
                _contentTable.canScroll = NO;
                _marketGoods.canScroll = YES;
            }
            
        }else{
            if (!_contentTable.canScroll) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }else{
                if (_contentTable.canNotScrollToBottom && scrollView.contentOffset.y <= _contentTable.initOffset.y) {
                    CGPoint offset = scrollView.contentOffset;
                    offset.y = _contentTable.initOffset.y;
                    scrollView.contentOffset = offset;
                }
            }
            
        }
        _contentTable.showsVerticalScrollIndicator = !_marketGoods.canScroll;
        _contentTable.initOffset = scrollView.contentOffset;
    }
    
}

#pragma mark -- getter
-(TCMTableView*)contentTable {
    if (!_contentTable) {
        _contentTable = [[TCMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTable.rowHeight = 50;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.canScroll = YES;
    }
    return _contentTable;
}
@end
