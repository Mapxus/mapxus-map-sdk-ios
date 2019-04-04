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


/**
 MapxusMap的delegate
 */
@protocol MapxusMapDelegate <NSObject>

@optional

/**
 单击地图时的回调，如果 - mapView:didSingleTappedAtCoordinate:onFloor:inBuilding: 实现了，则该方法不回调。
 
 @param mapView 响应的MapxusMap对象
 @param coordinate 点击位置的经纬度
 */
- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 单击地图时的回调

 @param mapView 响应的MapxusMap对象
 @param coordinate 点击位置的经纬度
 @param floorName 点击时所在的楼层名，如果在室外，返回为nil
 @param building 点击的建筑信息，如果在室外，返回为nil
 */
- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building;

/**
 长按地图时的回调，如果 - mapView:didLongPressedAtCoordinate:onFloor:inBuilding: 实现了，则该方法不回调
 
 @param mapView 响应的MapxusMap对象
 @param coordinate 点击位置的经纬度
 */
- (void)mapView:(MapxusMap *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 长按地图时的回调

 @param mapView 响应的MapxusMap对象
 @param coordinate 长按位置的经纬度
 @param floorName 长按时所在的楼层名，如果在室外，返回为nil
 @param building 长按的建筑信息，如果在室外，返回为nil
 */
- (void)mapView:(MapxusMap *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building;

/**
 改变选中建筑或楼层时调用此接口

 @param mapView 响应的MapxusMap对象
 @param floorName 当前选中建筑楼层名字
 @param building 当前选中建筑的信息，信息详细请参考`MXMGeoBuilding`
 */
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(NSString *)floorName atBuilding:(MXMGeoBuilding *)building;

/**
 点击POI时调用此接口

 @param mapView 响应的MapxusMap对象
 @param poi 当前选中POI的信息，信息详细请参考`MXMGeoPOI`
 */
- (void)mapView:(MapxusMap *)mapView didTappedOnPOI:(nullable MXMGeoPOI *)poi;

@end

NS_ASSUME_NONNULL_END




