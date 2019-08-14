//
//  NSObject+YYModelArray.h
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/NSObject+YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YYModelArray)

//字典数组 -> 模型数组
+ (NSMutableArray*)modelArrayWithKeyValuesArray:(NSArray *)keyValuesArray;
+ (NSMutableArray*)modelArrayWithJSON:(id)keyValuesArray;

@end

NS_ASSUME_NONNULL_END
