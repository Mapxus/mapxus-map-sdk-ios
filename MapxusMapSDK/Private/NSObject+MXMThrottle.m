//
//  NSObject+MXMThrottle.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/10/19.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "NSObject+MXMThrottle.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char MXMThrottledSelectorKey;
static char MXMThrottledSerialQueue;

@implementation NSObject (MXMThrottle)

- (void)mxm_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval
{
  dispatch_async([self getSerialQueue], ^{
    NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &MXMThrottledSelectorKey) mutableCopy];
    
    if (!blockedSelectors) {
      blockedSelectors = [NSMutableDictionary dictionary];
      objc_setAssociatedObject(self, &MXMThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    if (![blockedSelectors objectForKey:selectorName]) {
      [blockedSelectors setObject:selectorName forKey:selectorName];
      objc_setAssociatedObject(self, &MXMThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
      
      dispatch_async(dispatch_get_main_queue(), ^{
        ((id (*)(id, SEL))objc_msgSend)(self, aSelector);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(inteval * NSEC_PER_SEC)), [self getSerialQueue], ^{
          [self unlockSelector:selectorName];
        });
      });
    }
  });
}

#pragma mark -
- (void)unlockSelector:(NSString *)selectorName
{
  dispatch_async([self getSerialQueue], ^{
    NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &MXMThrottledSelectorKey) mutableCopy];
    
    if ([blockedSelectors objectForKey:selectorName]) {
      [blockedSelectors removeObjectForKey:selectorName];
    }
    
    objc_setAssociatedObject(self, &MXMThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
  });
}

- (dispatch_queue_t)getSerialQueue
{
  dispatch_queue_t serialQueur = objc_getAssociatedObject(self, &MXMThrottledSerialQueue);
  if (!serialQueur) {
    serialQueur = dispatch_queue_create("com.mapxus.throttle", NULL);
    objc_setAssociatedObject(self, &MXMThrottledSerialQueue, serialQueur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return serialQueur;
}

@end
