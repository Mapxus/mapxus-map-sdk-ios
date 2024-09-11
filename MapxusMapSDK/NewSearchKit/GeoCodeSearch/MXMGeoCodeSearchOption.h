//
//  MXMGeoCodeSearchOption.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// `MXMReverseGeoCodeSearchOption` is a class that encapsulates the parameters for a reverse geocoding search.
@interface MXMReverseGeoCodeSearchOption : NSObject


/// The `location` property represents the latitude and longitude coordinates to be resolved.
/// This property is mandatory for the reverse geocoding search.
@property (nonatomic, assign) CLLocationCoordinate2D location;


/// The `floorOrdinal` property represents the level values of the floor, corresponding to `floor.level` in `CLLocation`.
@property (nonatomic, strong) NSNumber *floorOrdinal;

@property (nonatomic, strong) NSNumber *ordinalFloor DEPRECATED_MSG_ATTRIBUTE("Please use `floorOrdinal`");

@end

NS_ASSUME_NONNULL_END
