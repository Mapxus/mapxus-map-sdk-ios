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
                         failure:(void (^)(NSError *error))failure
{
    NSURLSessionDataTask *task = [[MXMHttpManager sharedManager] GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = DecodeDicFromDic(responseObject, @"result");
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [[MXMHttpManager sharedManager] _dealWithTask:task error:error];
        if (failure && newError) {
            failure(newError);
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
        NSDictionary *result = DecodeDicFromDic(responseObject, @"result");
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [[MXMHttpManager sharedManager] _dealWithTask:task error:error];
        if (failure && newError) {
            failure(newError);
        }
    }];
    return task;
}



- (NSError *)_dealWithTask:(NSURLSessionDataTask *)task error:(NSError *)afError
{
    // get response body
    NSData *data = afError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSError *jsonError;
    NSDictionary *dataDic;
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if ([json isKindOfClass:[NSDictionary class]]) {
            dataDic = json;
        }
    }
    
    
    // get body message string
    NSString *message = DecodeStringFromDic(dataDic, @"message");
    if (message == nil) {
        message = afError.userInfo[NSLocalizedDescriptionKey];
    }
    
    // get response
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[NSLocalizedDescriptionKey] = message;
    NSError *err = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:response.statusCode userInfo:info];
    return err;
}


@end
