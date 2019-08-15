//
//  MarketGoodsController.m
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "MarketGoodsController.h"
#import <YYKit/YYKit.h>
#import "TCMMarketGoodsTableCell.h"
#import "TCMTableView.h"
#import "NetworkService.h"

@interface MarketGoodsController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UITableView *classTableView;
@property(nonatomic,strong)UITableView *goodsTabelView;
@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic,assign)NSInteger selectClass;

@property (nonatomic)NSInteger topSection;
@property (nonatomic, strong)NSMutableArray <TCMMarketGoodsSectionModel *>*showDatas;

@property(nonatomic) CGPoint initOffset;//记录初始化偏移量
@property(nonatomic) CGPoint lastOffset;//记录上次的偏移量
@property (nonatomic) BOOL drag;
@property (nonatomic,weak,readonly)TCMTableView *mySupView;
@property (nonatomic) NSIndexPath *taregtIndexPath;

@end

@implementation MarketGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _initOffset = CGPointZero;
    [self buildTableView];
}

-(void)buildTableView {
    [self.view addSubview:self.classTableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.goodsTabelView];
    
    [self buildLayout];
}

-(void)buildLayout {
    self.classTableView.frame = CGRectMake(0, 0, 100, self.view.height);
    self.collectionView.frame = CGRectMake(self.classTableView.right, 0, self.view.width - 100, 50);
    self.goodsTabelView.frame = CGRectMake(self.classTableView.right, self.collectionView.bottom, self.collectionView.width, self.classTableView.height - self.collectionView.height);
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self buildLayout];
}

#pragma mark -- setter
-(void)setClassArray:(NSArray *)classArray {
    if (_classArray != classArray) {
        _classArray = classArray;
    }

    [self.classTableView reloadData];
    if (_classArray.count>0) {
        [self performAnimateForLine:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    [self.collectionView reloadData];
    if (_classArray.firstObject.childs.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
    [self packgeData];
    [self.goodsTabelView reloadData];
    
    [self bindToClass];
}

//滑动到指定的一级分类
-(void)bindToClass {
    if (self.classId) {
        [self scrollToClassAtClassId:self.classId];
        [self scrollToSectionAtClassId:self.classId];
    }
}

- (void)packgeData{
    self.showDatas = [NSMutableArray array];
    for (TCMMarketGoodsClassModel *data in _classArray) {
        for (TCMMarketGoodsClassModel *secondChildData in data.childs) {
            for (TCMMarketGoodsClassModel *thirdChildData in secondChildData.childs) {
                TCMMarketGoodsSectionModel *sectionData = [[TCMMarketGoodsSectionModel alloc]init];
                sectionData.sectionHeaderData = thirdChildData;
                
                if ([thirdChildData.classId isEqualToString:@"discountCouponRule"]) {
                    
                }else if ([thirdChildData.classId isEqualToString:@"storeVoucher"]){
                    
                }else{
                    TCMMarketGoodsModel *rowData = [[TCMMarketGoodsModel alloc]init];
                    rowData.marketId = thirdChildData.marketID;
                    rowData.classsify_id = thirdChildData.classId;
                    rowData.goods_name = thirdChildData.className;
                    [sectionData.rowsData addObject:rowData];
                    
                }
                [self.showDatas addObject:sectionData];
            }
        }
    }
    
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.classTableView){
        return self.classArray.count > 0 ? 1 : 0;
    }else{
        return self.showDatas.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.classTableView) {
        return self.classArray.count;
    }else {
        TCMMarketGoodsSectionModel *sectionModel = self.showDatas[section];
        return sectionModel.rowsData.count;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.goodsTabelView) {
        TCMMarketGoodsSectionCell *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TCMMarketGoodsSectionCell.className];
        TCMMarketGoodsSectionModel *sectionModel = self.showDatas[section];
        headerView.sectionModel = sectionModel;
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.goodsTabelView) {
        return 30;
    }
    return CGFLOAT_MIN;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.classTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:TCMClassTableViewCell.className];
        TCMClassTableViewCell *tCell = (TCMClassTableViewCell*)cell;
        TCMMarketGoodsClassModel *classModel = self.classArray[indexPath.row];
        tCell.classModel = classModel;
        
    }else{
        TCMMarketGoodsSectionModel *showModel = self.showDatas[indexPath.section];
        id data = showModel.rowsData[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:TCMMarketGoodsTableCell.className];
        TCMMarketGoodsTableCell *gCell = (TCMMarketGoodsTableCell*)cell;
        gCell.data = data;
        
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.goodsTabelView) {
        NSInteger section = indexPath.section;
        if (self.showDatas&&self.showDatas.count>0) {
            TCMMarketGoodsSectionModel *showModel = self.showDatas[section];
            TCMMarketGoodsModel *data = showModel.rowsData[0];
            
            [self loadGoodsDataWithMarketID:data.marketId calssId:data.classsify_id];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        
        TCMMarketGoodsClassModel *classModel = self.classArray[indexPath.row];
        [self scrollToSectionAtClassId:classModel.classId];
        
        self.selectClass = indexPath.row;
        [self performAnimateForLine:indexPath];
    }
    
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    TCMMarketGoodsClassModel *sectionModel = self.classArray[self.selectClass];
    return sectionModel.childs.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray<TCMMarketGoodsClassModel*> *sectionModelArray = self.classArray[self.selectClass].childs;
    return sectionModelArray[section].childs.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray<TCMMarketGoodsClassModel*> *sectionModelArray = self.classArray[self.selectClass].childs;
    TCMMarketGoodsClassModel *data = sectionModelArray[indexPath.section].childs[indexPath.item];
    
    CGSize size = [data.className sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    return CGSizeMake(size.width+20, collectionView.height);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMMarketTopCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TCMMarketTopCollectionCell.class) forIndexPath:indexPath];
    NSArray<TCMMarketGoodsClassModel*> *sectionModelArray = self.classArray[self.selectClass].childs;
    TCMMarketGoodsClassModel *data = sectionModelArray[indexPath.section].childs[indexPath.item];
    cell.data = data;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray<TCMMarketGoodsClassModel*> *sectionModelArray = self.classArray[self.selectClass].childs;
    NSString *classID = sectionModelArray[indexPath.section].childs[indexPath.row].classId;
    [self scrollToSectionAtClassId:classID];
}

#pragma mark -- 加载数据
- (void)loadGoodsDataWithMarketID:(NSString *)marketID calssId:(NSString*)calssId{
    if (!calssId) {
        return;
    }
//    NSLog(@"加载品类数据");
    NSMutableDictionary *paras = [[NSMutableDictionary alloc]init];
    
    [paras setValue:@"" forKey:@"plotarea_lng"];
    [paras setValue:@"" forKey:@"plotarea_lat"];
    [paras setValue:marketID forKey:@"marketId"];
    [paras setValue:calssId forKey:@"spuId"];
    [paras setValue:self.goodsID forKey:@"goodsId"];
    
    [NetworkService sendRequestWithUrl:@"buyer/market/goods/listgoods" parameters:paras completionHandler:^(id  _Nonnull response, NSError * _Nonnull connectionError) {
        if (response) {
            NSMutableArray<TCMMarketGoodsModel*> *goodsList = [TCMMarketGoodsModel modelArrayWithJSON:response[@"goodsList"]];
            
            for (TCMMarketGoodsSectionModel *showData in self.showDatas){
                if ([calssId isEqualToString:showData.sectionHeaderData.classId]&&goodsList.count>0) {
                    if ([goodsList.firstObject.goods_id isEqualToString:self.goodsID]) {
                        goodsList.firstObject.highlight = YES;
                    }
                    showData.rowsData = goodsList;
                    [self.goodsTabelView reloadData];
                    if (self.taregtIndexPath) {
                        [self.goodsTabelView scrollToRowAtIndexPath:self.taregtIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                    
                    break;
                }
            }
          
        }
        
        
    }];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.drag = YES;
    self.taregtIndexPath = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.drag = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat y = scrollView.contentOffset.y;
        NSLog(@"xxxxx %f",y);
        NSIndexPath *indexPath = self.goodsTabelView.indexPathsForVisibleRows.firstObject;
        
        if (indexPath.section != 0 && indexPath.row != 0){
            self.mySupView.canNotScrollToBottom = YES;
        }
        
        if (!self.canScroll&& self.drag &&indexPath.section == 0 && indexPath.row==0) {
            self.goodsTabelView.contentOffset = CGPointZero;
            self.classTableView.contentOffset = CGPointZero;
        }
        
        if (y <= 0 && self.drag && indexPath.section == 0) {
            self.canScroll = NO;
            self.goodsTabelView.contentOffset = CGPointZero;
            self.classTableView.contentOffset = CGPointZero;
            if (self.mySupView) {
                self.mySupView.canScroll = YES;
            }
        }
        if (!self.canScroll&& self.drag&&!(indexPath.section == 0 && indexPath.row ==0)) {
            self.goodsTabelView.contentOffset = _initOffset;
        }
        if (self.initOffset.y > 0 && y>self.lastOffset.y && self.mySupView.contentOffset.y < self.mySupView.tableHeaderView.height) {
            self.goodsTabelView.contentOffset = self.lastOffset;
        }
        
        self.goodsTabelView.showsVerticalScrollIndicator = _canScroll;
        self.lastOffset = self.goodsTabelView.contentOffset;
    }
    
    //一下为业务处理
    if (scrollView == self.goodsTabelView) {
        NSIndexPath *indexPath = self.goodsTabelView.indexPathsForVisibleRows.firstObject;
        
        if (indexPath.section != self.topSection){
            self.topSection = indexPath.section;
            
            if (self.drag) {
                TCMMarketGoodsSectionModel *sectionModel = self.showDatas[indexPath.section];
                [self scrollToClassAtClassId:sectionModel.sectionHeaderData.classId];
                
                [self collectionScrollToItemAtClassId:sectionModel.sectionHeaderData.classId];
            }
            
        }
    }
}

#pragma mark -- collectionScroll

-(void)collectionScrollToItemAtClassId:(NSString*)classId{
    __block NSUInteger section = 0;
    __block NSUInteger item = 0;
   TCMMarketGoodsClassModel *firstClassModel = self.classArray[self.selectClass];
    [firstClassModel.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
        [obj2.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
            if ([obj3.classId isEqualToString:classId]) {
                section = idx2;
                item = idx3;
                *stop3 = YES;
                *stop2 = YES;
            }
        }];
    }];
    
    
    if (firstClassModel.childs.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
    }
}

#pragma mark -- 滑动到指定商品区
-(void)scrollToSectionAtClassId:(NSString*)classId {
    
    [self.showDatas enumerateObjectsUsingBlock:^(TCMMarketGoodsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sectionHeaderData.firstClassID isEqualToString:classId] || [obj.sectionHeaderData.classId isEqualToString:classId]) {
            if (obj.rowsData.count > 0){
                self.drag = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
                self.taregtIndexPath = indexPath;
                [self.goodsTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                *stop = YES;
            }
            if (idx != 0){
                self.initOffset = self.goodsTabelView.contentOffset;
                if (self.mySupView && self.mySupView.contentOffset.y < self.mySupView.tableHeaderView.height) {
                    self.canScroll = YES;
                    self.mySupView.canNotScrollToBottom = YES;
                }else{
                    self.canScroll = YES;
                    if (self.mySupView) {
                        self.mySupView.canNotScrollToBottom = NO;
                    }
                }
                
            }else{
                if (self.mySupView) {
                    self.mySupView.canNotScrollToBottom = NO;
                }
                self.canScroll = NO;
            }
        }
    }];
    
}

-(void)scrollToClassAtClassId:(NSString*)classId {
   __block NSInteger classIndex = -1;
    [self.classArray enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel *_Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        if ([obj1.classId isEqualToString:classId]) {
            classIndex = idx1;
            *stop1 = YES;
            return;
        }
        [obj1.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if ([obj2.classId isEqualToString:classId]) {
                classIndex = idx1;
                *stop1 = YES;
                *stop2 = YES;
                return;
            }
            [obj2.childs enumerateObjectsUsingBlock:^(TCMMarketGoodsClassModel * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                if ([obj3.classId isEqualToString:classId]){
                    classIndex = idx1;
                    *stop1 = YES;
                    *stop2 = YES;
                    *stop3 = YES;
                }
            }];
        }];
        
    }];
    
    if (classIndex < 0) {
        classIndex = 0;
    }
    if (_classArray.count>0) {
        self.selectClass = classIndex;
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:classIndex inSection:0];
        [self.classTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self performAnimateForLine:path];
    }
}

-(void)setSelectClass:(NSInteger)selectClass {
    if (_selectClass != selectClass) {
        _selectClass = selectClass;
        //当一级分类发生改变时，刷新collectionView
        [self.collectionView reloadData];
        TCMMarketGoodsClassModel *firstClassModel = self.classArray[_selectClass];
        //应该是三级分类
        if (firstClassModel.childs.count>0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        }
    }
    
}

#pragma mark -- moveLineAnimate
- (void)performAnimateForLine:(NSIndexPath *)idexPath {
    [self.classTableView selectRowAtIndexPath:idexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:.7 options: UIViewAnimationOptionCurveLinear animations: ^{
        UITableViewCell *cell = [self.classTableView cellForRowAtIndexPath:idexPath];
        self.moveLine.frame = CGRectMake(0, cell.top, 3, cell.height);
    } completion:nil];
}

#pragma mark -- getter
-(TCMTableView*)mySupView {
    if ([self.view.superview isKindOfClass:[TCMTableView class]]) {
        TCMTableView *superView = (TCMTableView*)self.view.superview;
        return superView;
    }else{
        return nil;
    }
}

-(UITableView*)classTableView {
    if (!_classTableView) {
        _classTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _classTableView.rowHeight = 50;
        _classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _classTableView.delegate = self;
        _classTableView.dataSource = self;
        [_classTableView registerClass:TCMClassTableViewCell.class forCellReuseIdentifier:NSStringFromClass(TCMClassTableViewCell.class)];
        [_classTableView addSubview:self.moveLine];
    }
    return _classTableView;
}
-(UITableView*)goodsTabelView {
    if (!_goodsTabelView) {
        _goodsTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTabelView.decelerationRate = 1.0;
        //采用预估高度可防止加载抖动问题
        _goodsTabelView.estimatedRowHeight = 60;
        _goodsTabelView.estimatedSectionHeaderHeight = 0;
        _goodsTabelView.estimatedSectionFooterHeight = 0;
        _goodsTabelView.delegate = self;
        _goodsTabelView.dataSource = self;
        _goodsTabelView.rowHeight = UITableViewAutomaticDimension;
        [_goodsTabelView registerNib:[UINib nibWithNibName:TCMMarketGoodsTableCell.className bundle:nil] forCellReuseIdentifier:TCMMarketGoodsTableCell.className];
        [_goodsTabelView registerClass:TCMMarketGoodsSectionCell.class forHeaderFooterViewReuseIdentifier:TCMMarketGoodsSectionCell.className];
    }
    return _goodsTabelView;
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:TCMMarketTopCollectionCell.class forCellWithReuseIdentifier:TCMMarketTopCollectionCell.className];
    }
    return _collectionView;
}

- (UIView *)moveLine{
    if (!_moveLine) {
        _moveLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
        _moveLine.backgroundColor = [UIColor colorWithHexString:@"#ff0033"];
    }
    return _moveLine;
}

@end
