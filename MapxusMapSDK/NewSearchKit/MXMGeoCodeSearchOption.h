//
//  MXMGeoCodeSearchOption.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Reverse geo search parameters
 */
@interface MXMReverseGeoCodeSearchOption : NSObject
/// Latitude and longitude coordinates to be resolved (mandatory)
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// Level values of floor, corresponding to floor.level in CLLocation
@property (nonatomic, strong) NSNumber *ordinalFloor;
@end

NS_ASSUME_NONNULL_END
