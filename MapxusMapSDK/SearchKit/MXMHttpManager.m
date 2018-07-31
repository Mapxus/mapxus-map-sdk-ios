//
//  MXMHttpManager.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMHttpManager.h"
#import "MXMMapServices+Private.h"

@implementation MXMHttpManager

+ (instancetype)sharedManager {
    static MXMHttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPShouldSetCookies = YES;
        _sharedManager = [[MXMHttpManager alloc] initWithSessionConfiguration:configuration];
        _sharedManager.requestSerializer.timeoutInterval = 50.0f;
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"charset=UTF-8", @"application/json", nil];
    });
    return _sharedManager;
}


+ (void)MXMGET:(NSString *)URLString parameters:(NSDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        [[MXMHttpManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"token"];
        [[MXMHttpManager sharedManager] GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }];
}


+ (void)MXMPOST:(NSString *)URLString
     parameters:(NSDictionary *)dic
        success:(void (^)(id respondObject))success
        failure:(void (^)(NSError *error))failure
{
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        [[MXMHttpManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"token"];
        [[MXMHttpManager sharedManager] POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }];
}

@end
