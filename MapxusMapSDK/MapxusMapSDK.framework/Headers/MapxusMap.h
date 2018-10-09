//
//  MapxusMap.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMConfiguration.h"
#import "MXMDefine.h"

@class MGLMapView;
@class MXMGeoBuilding;
@class MXMPointAnnotation;
@protocol MapxusMapDelegate;


NS_ASSUME_NONNULL_BEGIN

/**
 MapxusMap主类
 */
@interface MapxusMap : NSObject

/**
 MapxusMap初始化函数

 @param mapView MapBox的mapView
 @return MapxusMap对象
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView;

/**
 MapxusMap初始化函数
 
 @param mapView MapBox的mapView
 @param configuration 初始化参数，详情请看`MXMConfiguration`
 @return MapxusMap对象
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 MapxusMap的事件回调代理
 */
@property (nonatomic, weak) id<MapxusMapDelegate> delegate;

/**
 一直隐藏地图控件，默认为NO
 */
@property (nonatomic, assign) BOOL indoorControllerAlwaysHidden;

/**
 设置地图控件的位置，默认为`MXMSelectorPositionCenterLeft`
 */
@property (nonatomic, assign) MXMSelectorPosition selectorPosition;

/**
 设置地图外观
 
 @param style 外观类型。具体属性字段请参考 `MXMStyle` 。
 */
- (void)setMapSytle:(MXMStyle)style;

/**
 当前选中楼层
 */
@property (nonatomic, readonly) NSString *floor;

/**
 当前选中建筑
 */
@property (nonatomic, readonly) MXMGeoBuilding *building;

/**
 返回当前MapView中所有可见建筑
 */
@property (nonatomic, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

/**
 选择当前选中建筑的楼层，地图默认会移动到该建筑区域
 
 @param floor 选择的楼层名字。
 */
- (void)selectFloor:(nullable NSString *)floor;

/**
 选择当前选中建筑的楼层
 
 @param floor 选择的楼层名字。
 @param zoomTo 设置楼层后当前建筑是否缩放到占用整屏
 */
- (void)selectFloor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo;

/**
 选择建筑，地图默认会移动到该建筑区域
 
 @param buildingId 要选中的建筑ID
 */
- (void)selectBuilding:(nullable NSString *)buildingId;

/**
 选择建筑
 
 @param buildingId 要选中的建筑ID
 @param zoomTo 设置ID后是否缩放到该建筑占用整屏
 */
- (void)selectBuilding:(nullable NSString *)buildingId shouldZoomTo:(BOOL)zoomTo;

/**
 选择建筑与该建筑的楼层，地图默认会移动到该建筑区域
 
 @param buildingId 要选中的建筑ID
 @param floor 选择的楼层名字
 */
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor;

/**
 选择建筑与该建筑的楼层
 
 @param buildingId 要选中的建筑ID
 @param floor 选择的楼层名字
 @param zoomTo 设置ID后是否缩放到该建筑占用整屏
 */
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo;

/**
 添加地图标注，如需要添加室内点，必须调用些方法才会分层。

 @param annotations MXMPointAnnotation队列
 */
- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations;

/**
 删除地图标注，如需要删除室内点，必须调用此方法才能彻底删除。

 @param annotations MXMPointAnnotation队列
 */
- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations;

@end

NS_ASSUME_NONNULL_END



