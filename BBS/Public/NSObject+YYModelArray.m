//
//  NSObject+YYModelArray.m
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "NSObject+YYModelArray.h"

@implementation NSObject (YYModelArray)

#pragma mark - 字典数组 -> 模型数组

+ (NSMutableArray*)modelArrayWithKeyValuesArray:(NSArray *)keyValuesArray {
    return [self modelArrayWithJSON:keyValuesArray];
}

+ (NSMutableArray*)modelArrayWithJSON:(id)keyValuesArray {
    if (![keyValuesArray isKindOfClass:[NSArray class]]) {
        // 如果是JSON字符串
        keyValuesArray = [keyValuesArray yy_JSONObject];
        // 1.判断真实性
        NSAssert([keyValuesArray isKindOfClass:[NSArray class]], @"keyValuesArray参数不是一个数组");
    }
    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    // 3.遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if ([keyValues isKindOfClass:[NSArray class]]){
            [modelArray addObject:[self modelArrayWithJSON:keyValues]];
        } else {
            id model = [self modelWithJSON:keyValues];
            if (model) [modelArray addObject:model];
        }
    }
    
    return modelArray;
}

- (id)yy_JSONObject
{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    return self.modelToJSONObject;
}

@end
