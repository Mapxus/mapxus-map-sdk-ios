//
//  UploadLogManager.h
//  healthCare
//
//  Created by GuoChenghao on 2017/7/17.
//  Copyright © 2017年 WideVision. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGPOSITION @"LOGPOSITION"

@interface UploadLogManager : NSObject

/**
 *  获取单例实例，暂时只限于在登录后才能调用
 *
 *  @return 单例实例
 */
+ (instancetype) sharedInstance;

#pragma mark - Method

/**
 *  写入日志
 *
 *  @param module 模块名称
 *  @param logStr 日志信息,动态参数
 */
- (void)logInfo:(NSString*)module logStr:(NSString*)logStr;

/**
 *  清空过期的日志
 */
- (void)clearExpiredLog;

@end
