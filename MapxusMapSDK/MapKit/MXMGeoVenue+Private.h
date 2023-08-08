//
//  MXMGeoVenue+Private.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/8/8.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoVenue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Venue information in tiles
 */
@interface MXMGeoVenue ()

/// A string that uniquely identifies the venue in the mapxus system.
@property (nonatomic, strong) MXMOrdinal *defaultDisplayedOrdinal;

@end

NS_ASSUME_NONNULL_END
