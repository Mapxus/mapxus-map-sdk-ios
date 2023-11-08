//
//  MGLPolygon+MXMFuction.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/11/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MGLPolygon+MXMFuction.h"
#import "MXMCommonObj.h"

@implementation MGLPolygon (MXMFuction)

/**
 * Determines if the given point falls within the ring.
 * The optional parameter `ignoreBoundary` will result in the method returning true if the given point
 * lies on the boundary line of the ring.
 *
 * Ported from: https://github.com/Turfjs/turf/blob/e53677b0931da9e38bb947da448ee7404adc369d/packages/turf-boolean-point-in-polygon/index.ts#L77-L108
 */
- (BOOL)contains:(CLLocationCoordinate2D)coordinate ignoreBoundary:(BOOL)ignoreBoundary {
  NSMutableArray<MXMGeoPoint *> *points = [NSMutableArray array];
  for (int i=0; i<self.pointCount; i++) {
    CLLocationCoordinate2D loc = self.coordinates[i];
    MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
    point.latitude = loc.latitude;
    point.longitude = loc.longitude;
    [points addObject:point];
  }
  MXMBoundingBox *bbox = [MXMBoundingBox boundingBoxWithPoints:points];
  if (!bbox || ![bbox contains:coordinate ignoreBoundary:ignoreBoundary]) {
    return NO;
  }
  
  BOOL isInside = NO;
  if (points.firstObject.latitude == points.lastObject.latitude &&
      points.firstObject.longitude == points.lastObject.longitude) {
    [points removeLastObject];
  }
  NSUInteger i = 0;
  NSUInteger j = points.count - 1;
  while (i < points.count) {
    double xi = points[i].longitude;
    double yi = points[i].latitude;
    double xj = points[j].longitude;
    double yj = points[j].latitude;
    BOOL onBoundary = (coordinate.latitude * (xi - xj) + yi * (xj - coordinate.longitude) + yj * (coordinate.longitude - xi) == 0) &&
    ((xi - coordinate.longitude) * (xj - coordinate.longitude) <= 0) && ((yi - coordinate.latitude) * (yj - coordinate.latitude) <= 0);
    if (onBoundary) {
      return !ignoreBoundary;
    }
    BOOL intersect = ((yi > coordinate.latitude) != (yj > coordinate.latitude)) &&
    (coordinate.longitude < (xj - xi) * (coordinate.latitude - yi) / (yj - yi) + xi);
    if (intersect) {
      isInside = !isInside;
    }
    j = i;
    i = i + 1;
  }
  return isInside;
}

@end
