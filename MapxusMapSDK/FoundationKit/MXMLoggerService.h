//
//  MXMLoggerService.h
//  MapxusBaseSDK
//
//  Created by Chenghao Guo on 2019/4/12.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Holding a single instance of MXMLogger
 */
@interface MXMLoggerService : NSObject

// Output log
+ (void)logMsg:(NSString *)msg;
// Log enable
+ (void)enableLog:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
