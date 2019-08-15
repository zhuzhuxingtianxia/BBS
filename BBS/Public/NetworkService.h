//
//  NetworkService.h
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//
//状态栏高
#define statusBarH    CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define safeAreaBottomH (statusBarH > 20 ? 34 : 0)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

+ (void)sendRequestWithUrl:(NSString*)url parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject, NSError* connectionError)) handler;

@end

NS_ASSUME_NONNULL_END
