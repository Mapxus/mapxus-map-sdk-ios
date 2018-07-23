//
//  MapxusMapDelegate.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class MapxusMap;
@class MXMGeoPOI;
@class MXMGeoBuilding;

NS_ASSUME_NONNULL_BEGIN

@protocol MapxusMapDelegate <NSObject>

@optional
/**
 * @brief 单击地图时的回调
 * @param mapView 地图View
 * @param coordinate 点击位置的经纬度
 */
- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 * @brief 长按地图时的回调
 * @param mapView 地图View
 * @param coordinate 点击位置的经纬度
 */
- (void)mapView:(MapxusMap *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 * @brief 改变选中楼层时调用此接口
 * @param mapView 地图View
 * @param floorName 当前选中建筑楼层名字
 * @param building 当前选中建筑的信息，信息详细请参考`MXMIndoorBuilding`
 */
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building;

/**
 * @brief 选中POI时调用此接口
 * @param mapView 地图View
 * @param poi 当前选中POI的信息，信息详细请参考`MXMIndoorPOI`
 */
- (void)mapView:(MapxusMap *)mapView didTappedOnPOI:(nullable MXMGeoPOI *)poi;

@end

NS_ASSUME_NONNULL_END
