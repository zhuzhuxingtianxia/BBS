//
//  TCMCartNetwork.m
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMCartNetwork.h"
#import <QuartzCore/QuartzCore.h>

@interface TCMItem : NSObject
@property(nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *itemId;
@end
@implementation TCMItem
@end

@interface TCMStore : NSObject
@property(nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *storeId;
@property (nonatomic,strong)NSArray<TCMItem*> *itemArray;
@end
@implementation TCMStore
@end

@interface TCMMarket : NSObject
@property(nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *marketId;
@property (nonatomic,strong)NSArray<TCMStore*> *storeArray;
@end

@implementation TCMMarket
@end

@interface TCMCartNetwork ()
@property(nonatomic,strong)NSMutableArray *markArray;
@end

@implementation TCMCartNetwork

-(void)buildData {
    CFTimeInterval startTime = CACurrentMediaTime();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 0; i<10; i++) {
            TCMMarket *market = [TCMMarket new];
            market.name = [NSString stringWithFormat:@"name%d",arc4random()%100];
            market.marketId = [NSString stringWithFormat:@"%ld",i+100];
            
            NSMutableArray *storeArray = [NSMutableArray array];
            for (NSInteger j = 0; j<10; j++) {
                TCMStore *store = [TCMStore new];
                store.name = [NSString stringWithFormat:@"name%d",arc4random()%100];
                store.storeId = [NSString stringWithFormat:@"%ld-%ld",i,j+100];
                
                NSMutableArray *itemArray = [NSMutableArray array];
                for (NSInteger k = 0; k<10000; k++){
                    TCMItem *item = [TCMItem new];
                    item.name = [NSString stringWithFormat:@"name%d",arc4random()%1000];
                    item.itemId = [NSString stringWithFormat:@"%ld-%ld",j,k+100];
                    
                    [itemArray addObject:item];
                }
                store.itemArray = itemArray;
                [storeArray addObject:store];
            }
            
            market.storeArray = storeArray;
            [self.markArray addObject:market];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            CFAbsoluteTime linkTime = CACurrentMediaTime() - startTime;
            NSLog(@"create:%f",linkTime);//1.835814
            NSLog(@"完成");
        });
    });
    
}
//单个/多个查询enumerateObjectsUsingBlock效率最高
-(void)queryData {
   CFTimeInterval startTime = CACurrentMediaTime();
   NSArray *markStoreArray = [self.markArray valueForKeyPath:@"storeArray"];
   NSArray *unionStoreArray = [markStoreArray valueForKeyPath:@"@unionOfArrays.self"];
    NSArray *itemArray = [unionStoreArray valueForKeyPath:@"itemArray"];
    
    NSArray *unionitemArray = [itemArray valueForKeyPath:@"@unionOfArrays.self"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId = %@",[NSString stringWithFormat:@"%d-%d",9,160]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId CONTAINS %@",@"0-0-100"];
    NSArray *filterArray = [unionitemArray filteredArrayUsingPredicate:predicate];
    
    NSLog(@"%@",filterArray.firstObject);
    
    CFAbsoluteTime linkTime = CACurrentMediaTime() - startTime;
    NSLog(@"linkTime1:%f",linkTime);//0.538340
    
    startTime = CACurrentMediaTime();
    NSMutableArray *queyArray = [NSMutableArray array];
    for (NSInteger i = 0; i<self.markArray.count; i++) {
        TCMMarket *market = self.markArray[i];
        for (NSInteger j = 0; j<market.storeArray.count; j++) {
            TCMStore *store = market.storeArray[j];
            for (NSInteger k = 0; k<store.itemArray.count; k++) {
                TCMItem *item = store.itemArray[k];
                if ([item.itemId isEqualToString:@"9-160"]) {
                    [queyArray addObject:item];
                }
            }
        }
    }
    
    NSLog(@"%@",queyArray);
    linkTime = CACurrentMediaTime() - startTime;
    NSLog(@"linkTime2:%f",linkTime);//0.230743
    
    startTime = CACurrentMediaTime();
    NSMutableArray *enumArray = [NSMutableArray array];
    [self.markArray enumerateObjectsUsingBlock:^(TCMMarket  *market, NSUInteger idx, BOOL * _Nonnull stop) {
        [market.storeArray enumerateObjectsUsingBlock:^(TCMStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
            [store.itemArray enumerateObjectsUsingBlock:^(TCMItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.itemId isEqualToString:@"9-160"]) {
                    [enumArray addObject:obj];
                }
            }];
            
        }];
    }];
    
    NSLog(@"%@",enumArray);
    linkTime = CACurrentMediaTime() - startTime;
    NSLog(@"linkTime3:%f",linkTime);//0.169244
    
}

-(NSMutableArray*)markArray {
    if (!_markArray) {
        _markArray = [NSMutableArray array];
    }
    return _markArray;
}

@end
