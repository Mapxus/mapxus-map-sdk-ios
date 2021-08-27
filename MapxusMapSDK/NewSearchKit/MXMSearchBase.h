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
 Search Service Base Class
 */
@interface MXMSearchBase : NSObject
/**
 Cancellation of network requests with the given id
 @param taskId The id of the network request
 */
- (void)cancelTaskById:(NSInteger)taskId;

@end

NS_ASSUME_NONNULL_END
