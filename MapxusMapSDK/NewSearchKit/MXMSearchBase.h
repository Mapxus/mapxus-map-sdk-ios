//
//  MXMSearchBase.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// `MXMSearchBase` is a base class that provides common functionality for search services.
@interface MXMSearchBase : NSObject


/// Cancels the network request with the given id.
///
/// @param taskId The id of the network request to be cancelled.
- (void)cancelTaskById:(NSInteger)taskId;

@end

NS_ASSUME_NONNULL_END
