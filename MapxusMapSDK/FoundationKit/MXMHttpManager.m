//
//  MXMHttpManager.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMHttpManager.h"
#import "JXJsonFunctionDefine.h"

@implementation MXMHttpManager

+ (instancetype)sharedManager {
    static MXMHttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedManager = [[MXMHttpManager alloc] initWithSessionConfiguration:configuration];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]; // 更换成AFJSONRequestSerializer，post方法用body传输
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"charset=UTF-8", @"application/json", nil];
    });
    return _sharedManager;
}


+ (NSURLSessionDataTask *)MXMGET:(NSString *)URLString
                      parameters:(NSDictionary *)dic
                         success:(void (^)(NSDictionary *content))success
                         failure:(void (^)(NSError *))failure
{
    NSURLSessionDataTask *task = [[MXMHttpManager sharedManager] GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
        } else {
            
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    return task;
}


+ (NSURLSessionDataTask *)MXMPOST:(NSString *)URLString
                       parameters:(NSDictionary *)dic
                          success:(void (^)(NSDictionary *content))success
                          failure:(void (^)(NSError *error))failure
{
    NSURLSessionDataTask *task = [[MXMHttpManager sharedManager] POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    return task;
}

//+ (NSError *)formatAFObject:(id)object
//{
//    NSError *formattedError = nil;
//
//    if ([object isKindOfClass:[NSDictionary class]]) {
//        NSError *businessErr = [self businessError:object];
//        if (businessErr) {
//            formattedError = businessErr;
//        } else {
//            formattedError = error;
//        }
//
//    } else {
//
//        formattedError = error;
//
//    }
//    return formattedError;
//}
//
//+ (NSError *)businessError:(NSDictionary *)dic
//{
//    NSError *error = nil;
//    NSInteger code = 0;
//    if ([dic objectForKey:@"code"]) {
//        code = [[dic objectForKey:@"code"] integerValue];
//    }
//
//    if (code != 200) {
//        if (code == 900001) {
//            // 在跳到登录页前，取消所有http网络请求
//            [self.operationQueue cancelAllOperations];
//            // 跳转到登录页
//            [(AppDelegate *)[UIApplication sharedApplication].delegate goLoginViewController];
//        } else if (code == 900002) {
//            // 在跳到登录页前，取消所有http网络请求
//            [self.operationQueue cancelAllOperations];
//            // 跳转到登录页
//            [(AppDelegate *)[UIApplication sharedApplication].delegate goLoginViewController];
//        }
//
//        //==== 错误码翻译
//        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        NSString *m = [self businessMsg:code];
//        if (m) {
//            [mDic setObject:m forKey:@"message"];
//        }
//        //==== 错误码翻译
//
//        id msg = [mDic objectForKey:@"message"];
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        if (msg) {
//            [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
//        } else {
//            [userInfo setObject:@"服务异常" forKey:NSLocalizedFailureReasonErrorKey];
//        }
//        error = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:code userInfo:userInfo];
//    }
//    return error;
//}

@end
