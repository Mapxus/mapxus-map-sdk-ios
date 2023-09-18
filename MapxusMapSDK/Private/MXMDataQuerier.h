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
#import "MXMLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

// 从地图中查找信息

@interface MXMDataQuerier : NSObject

- (instancetype)initWithMapView:(MGLMapView *)mapView;

// 区域内查找建筑
- (NSDictionary *)findOutFloorInTheRect:(CGRect)rect;

- (NSDictionary *)findOutBuildingInTheRect:(CGRect)rect;

- (NSDictionary *)findOutVenueInTheRect:(CGRect)rect;

// 点上查找建筑
- (NSDictionary *)findOutBuildingAtPoint:(CGPoint)point;

// 点上查找POI
- (NSDictionary *)findOutPOIAtPoint:(CGPoint)point;

- (NSDictionary *)findOutPOIOnLevelIds:(NSArray *)levelIds;

// 查询点击的楼层
- (NSArray<MXMLevelModel *> *)findOutFloorFeaturesAtPoint:(CGPoint)point;

// 查询点上的所有level辅助信息
- (NSArray<MXMLevelModel *> *)findOutAssistantFloorFeaturesAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
