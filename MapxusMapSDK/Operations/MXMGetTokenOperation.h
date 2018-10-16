//
//  MXMGetTokenOperation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMGetTokenOperation : NSOperation

@property (nonatomic, copy) void (^complateBlock)(NSString *token);

@end

NS_ASSUME_NONNULL_END
