//
//  MGLNetworkConfiguration+MXMSwizzle.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/10/24.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MGLNetworkConfiguration+MXMSwizzle.h"
#import "MXMURLProtocol.h"
#import <objc/runtime.h>


@implementation MGLNetworkConfiguration (MXMSwizzle)

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    SEL originalSelector = @selector(sessionConfiguration);
    SEL swizzledSelector = @selector(hook_getSessionConfiguration);
    
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

- (NSURLSessionConfiguration *)hook_getSessionConfiguration
{
  NSURLSessionConfiguration *configuration = [self hook_getSessionConfiguration];
  NSMutableArray *protocols = [NSMutableArray array];
  [protocols addObject:[MXMURLProtocol class]];
  if (configuration.protocolClasses.count) {
    [protocols addObjectsFromArray:configuration.protocolClasses];
  }
  configuration.protocolClasses = protocols;
  return configuration;
}

@end
