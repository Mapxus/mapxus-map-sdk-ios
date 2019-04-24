//
//  MXMDataQuerier.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/18.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import "MXMGeoPOI.h"
#import "MXMGeoBuilding.h"


NS_ASSUME_NONNULL_BEGIN

// 从地图中查找信息

@interface MXMDataQuerier : NSObject

- (instancetype)initWithMapView:(MGLMapView *)mapView;

// 区域内查找建筑
- (NSDictionary *)findOutBuildingInTheRect:(CGRect)rect;

// 点上查找建筑
- (NSDictionary *)findOutBuildingAtPoint:(CGPoint)point;

// 点上查找POI
- (NSDictionary *)findOutPOIAtPoint:(CGPoint)point coordinate:(CLLocationCoordinate2D)coor;

// 查询点击的楼层
- (NSArray<id <MGLFeature>> *)findOutFloorFeaturesAtPoint:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
