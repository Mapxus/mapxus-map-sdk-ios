//
//  NSObject+MXMThrottle.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/10/19.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MXMThrottle)

- (void)mxm_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval;

@end

NS_ASSUME_NONNULL_END
