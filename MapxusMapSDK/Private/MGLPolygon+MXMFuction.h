//
//  MGLPolygon+MXMFuction.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/11/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLPolygon (MXMFuction)

- (BOOL)contains:(CLLocationCoordinate2D)coordinate ignoreBoundary:(BOOL)ignoreBoundary;

@end

NS_ASSUME_NONNULL_END
