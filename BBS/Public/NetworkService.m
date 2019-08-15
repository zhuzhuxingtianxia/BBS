//
//  NetworkService.m
//  BBS
//
//  Created by ZZJ on 2019/8/9.
//  Copyright © 2019 Jion. All rights reserved.
//

#import "NetworkService.h"
#import "AFNetworking.h"

@implementation NetworkService

+ (NSString *)currentNetworkEnvironment {
    return @"http://app.taocaimall.com/taocaimall";
}

+ (void)sendRequestWithUrl:(NSString*)url parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject, NSError* connectionError)) handler {
    NSString *requestModel = @"requestmodel";
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
    NSString *touristId = [[NSUserDefaults standardUserDefaults] objectForKey:@"touristId"];
    NSString *URLString = url;
    
    URLString = [NSString stringWithFormat:@"%@/%@",[self currentNetworkEnvironment], [url hasSuffix:@".json"] ? url : [url hasSuffix:@".htm"] ? url : [NSString stringWithFormat:@"%@.json",url]];
    NSLog(@"\n %@:请求参数：%@\n",URLString,parameters);
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    if (parameters) {
        if (requestModel.length) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [par setValue:jsonStr forKey:requestModel];
        }else{
            par = [NSMutableDictionary dictionaryWithDictionary:parameters];
        }
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:par error:nil];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (version.length > 0) {
        [request setValue:version forHTTPHeaderField:@"appVersionNo"];
    }
    if (sessionId.length > 0){
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId] forHTTPHeaderField:@"Cookie"];
    }
    if (touristId.length > 0) {
        [request setValue:touristId forHTTPHeaderField:@"TouristId"];
    }
    [request setValue:@"ios_buyer" forHTTPHeaderField:@"app_name"];
    request.timeoutInterval = 20;
    
    if ([url isEqualToString:@"buyer/market/goods/classify/classes"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"response" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (json) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    handler(json,nil);
                });
                return;
            }
        }
        
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ([[responseObject valueForKey:@"op_flag"] isEqualToString:@"success"]){
             handler(responseObject,nil);
        }else{
            handler(nil,error);
        }
        
    }];
    [dataTask resume];
}

@end
