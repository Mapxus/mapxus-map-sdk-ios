//
//  MXMSearchBase.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 查询服务基类
 */
@interface MXMSearchBase : NSObject
/**
 取消对应id的网络请求
 @param taskId 网络请求的 id
 */
- (void)cancelTaskById:(NSInteger)taskId;

@end

NS_ASSUME_NONNULL_END
