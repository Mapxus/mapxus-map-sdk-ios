//
//  MXMSearchVenueOperation.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/8/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMSearchAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMSearchVenueOperation : NSOperation

@property (nonatomic, copy) void (^complateBlock)(MXMVenue * _Nullable venue);

- (void)searchWithVenueId:(NSString *)venueId;

@end

NS_ASSUME_NONNULL_END
