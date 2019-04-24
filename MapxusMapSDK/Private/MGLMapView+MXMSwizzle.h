//
//  MGLMapView+MXMSwizzle.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

@class MapxusMap;

@interface MGLMapView (MXMSwizzle) <MGLMapViewDelegate>

@property (nonatomic, weak) MapxusMap *mxmMap;

@end
