//
//  NSBundle+MXMSwizzle.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/6/7.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <objc/runtime.h>
#import "NSBundle+MXMSwizzle.h"

@implementation NSBundle (MXMSwizzle)

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    SEL originalSelector = @selector(objectForInfoDictionaryKey:);
    SEL swizzledSelector = @selector(hook_objectForInfoDictionaryKey:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class,
                          swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

- (nullable id)hook_objectForInfoDictionaryKey:(NSString *)key
{
  if ([key isEqualToString:@"MGLIdeographicFontFamilyName"]) {
    // 如果App端有设置，使用App端的设置
    if ([self hook_objectForInfoDictionaryKey:key] != nil) {
      return [self hook_objectForInfoDictionaryKey:key];
    }
    return @"PingFang";
  } else {
    return [self hook_objectForInfoDictionaryKey:key];
  }
}

@end
