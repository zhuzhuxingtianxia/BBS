//
//  TCMCartManger.m
//  BBS
//
//  Created by ZZJ on 2019/8/7.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "TCMCartManger.h"
@interface TCMCartManger ()

@end
@implementation TCMCartManger

static TCMCartManger *manger = nil;
+(instancetype)manger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [TCMCartManger new];
    });
    
    return manger;
}

//保存更新购物车数据接口
-(void)saveUpdateItems:(id)cartData {
    
}
//添加商品到购物车
-(void)addItem:(id)item{
    
}
//根据商品ID，获取一个商品数据
-(id)getItemById:(NSString*)goodsId {
    
    return nil;
}

//改变购物车商品数量
-(void)changeItemCount:(id)item {
    
}

//根据商品id，删除购物车商品
-(void)deleteItemById:(NSString*)goodsId {
    
}

//获取购物车商品总数量
-(void)getTotalCount:(void(^)(NSInteger))block{
    
    dispatch_queue_t queue = dispatch_queue_create("getTotalCount_label", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //查询
        NSInteger count = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(count);
        });
    });
}

//清空购物车数据接口
-(void)clearCartItems {
    
}

@end
