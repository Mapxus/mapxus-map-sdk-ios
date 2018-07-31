//
//  MXMHttpManager.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface MXMHttpManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

+ (void)MXMGET:(NSString *)URLString
    parameters:(NSDictionary *)dic
       success:(void (^)(id respondObject))success
       failure:(void (^)(NSError *error))failure;

+ (void)MXMPOST:(NSString *)URLString
     parameters:(NSDictionary *)dic
        success:(void (^)(id respondObject))success
        failure:(void (^)(NSError *error))failure;

@end
