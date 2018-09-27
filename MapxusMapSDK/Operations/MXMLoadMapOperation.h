//
//  MXMLoadMapOperation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoadMapBlock)(NSString *token);

@interface MXMLoadMapOperation : NSOperation

@property (nonatomic, copy) NSString *token;

- (instancetype)initWithBlock:(LoadMapBlock)block;

- (void)finish;

@end

NS_ASSUME_NONNULL_END
