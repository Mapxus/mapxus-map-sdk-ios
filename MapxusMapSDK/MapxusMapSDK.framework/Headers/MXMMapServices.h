//
//  MXMMapServices.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 BeeMap服务配置类
 */
@interface MXMMapServices : NSObject

/**
 生成BeeMap服务单例
 
 @return MXMMapServices对象
 */
+ (instancetype)sharedServices;

/**
 注册BeeMap地图服务
 
 @param apiKey BeeMap账号
 @param secret BeeMap密码
 */
- (void)registerWithApiKey:(NSString *)apiKey secret:(NSString *)secret;

@end
