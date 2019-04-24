//
//  MGLStyleLayer+MXMFilter.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/18.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLStyleLayer (MXMFilter)

- (BOOL)isBuildingFillLayer;

- (BOOL)isIndoorSymbolLayer;

- (BOOL)isOutdoorLayer;

@end

NS_ASSUME_NONNULL_END
