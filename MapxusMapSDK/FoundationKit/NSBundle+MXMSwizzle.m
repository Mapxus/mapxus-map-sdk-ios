//
//  NSBundle+MXMSwizzle.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/10/15.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <objc/runtime.h>
#import "NSBundle+MXMSwizzle.h"

@implementation NSBundle (MXMSwizzle)

+ (void)load
{
    SEL oldSelector = @selector(objectForInfoDictionaryKey:);
    SEL newSelector = @selector(hook_objectForInfoDictionaryKey:);
    Method oldMethod = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([self class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([self class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod));
    } else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

- (nullable id)hook_objectForInfoDictionaryKey:(NSString *)key
{
    if ([key isEqualToString:@"MGLIdeographicFontFamilyName"]) {
        return @"PingFang";
    } else if ([key isEqualToString:@"MGLMapboxMetricsEnabledSettingShownInApp"]) {
        return @(YES);
    } else {
        return [self hook_objectForInfoDictionaryKey:key];
    }
}


@end
