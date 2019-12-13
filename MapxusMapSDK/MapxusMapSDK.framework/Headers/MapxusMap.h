//
//  MapxusMap.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMFloorSelectorBar.h"
#import "MXMConfiguration.h"
#import "MXMDefine.h"

@class MGLMapView;
@class MXMGeoBuilding;
@class MXMPointAnnotation;
@protocol MapxusMapDelegate;


NS_ASSUME_NONNULL_BEGIN

/**
 * MapxusMap主类
 */
@interface MapxusMap : NSObject

/**
 MapxusMap初始化函数
 @param mapView 绑定MGLMapView，引入MapBox作为地图渲染工具
 @return MapxusMap对象
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView;

/**
 MapxusMap初始化函数
 @param mapView 绑定MGLMapView，引入MapBox作为地图渲染工具
 @param configuration 初始化参数，详情请看`MXMConfiguration`
 @return MapxusMap对象
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// MapxusMap的事件回调代理
@property (nonatomic, weak, nullable) id<MapxusMapDelegate> delegate;

/// 建筑选择按钮，在屏幕中心矩形区域出现多栋建筑时出现
@property (nonatomic, strong, readonly) UIButton *buildingSelectButton;

/// 楼层选择器
@property (nonatomic, strong, readonly) MXMFloorSelectorBar *floorBar;

/// 一直隐藏地图控件，默认为NO
@property (nonatomic, assign) BOOL indoorControllerAlwaysHidden;

/// 设置地图控件的位置，默认为`MXMSelectorPositionCenterLeft`
@property (nonatomic, assign) MXMSelectorPosition selectorPosition;

/// 设置室外地图是否显示
@property (nonatomic, assign) BOOL outdoorHidden;

/// 点击地图切换建筑功能，默认状态为YES。
@property (nonatomic, assign) BOOL gestureSwitchingBuilding;

/// 是否支持自动切换建筑，默认状态为YES。当自动切换模式打开时，建筑移到视图中心，会自动选中建筑，显示其内部结构。
@property (nonatomic, assign) BOOL autoChangeBuilding;

/**
 设置地图外观
 @param style 外观类型。具体属性字段请参考 `MXMStyle` 。
 */
- (void)setMapSytle:(MXMStyle)style;

/**
 设置地图语言
 @param language 地图语言，可选项为en，zh-Hant，zh-Hans，default
 */
- (void)setMapLanguage:(NSString *)language;

/// 当前选中楼层
@property (nonatomic, copy, readonly, nullable) NSString *floor;

/// 当前选中建筑
@property (nonatomic, copy, readonly, nullable) MXMGeoBuilding *building;

/**
 用户当前所在楼层，只有当`MGLMapView`的`userTrackingMode`不为`MGLUserTrackingModeNone`值才可信，
 没有室内数据时为nil
 */
@property (nonatomic, copy, readonly, nullable) NSString *userLocationFloor;

/**
 用户当前所在建筑，只有当`MGLMapView`的`userTrackingMode`不为`MGLUserTrackingModeNone`值才可信，
 没有室内数据时为nil
 */
@property (nonatomic, copy, readonly, nullable) MXMGeoBuilding *userLocationBuilding;

/// 返回当前绑定的MGLMapView视窗中所有可见的已测量建筑
@property (nonatomic, copy, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

/**
 选择当前选中建筑的楼层，地图默认会移动到该建筑区域，缩放适配边距为0
 @param floor 选择的楼层名字。
 */
- (void)selectFloor:(nullable NSString *)floor;

/**
 选择当前选中建筑的楼层
 @param floor 选择的楼层名字。
 @param zoomTo 设置楼层后当前建筑是否缩放到占用整屏
 */
- (void)selectFloor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo DEPRECATED_MSG_ATTRIBUTE("Use `-selectFloor:zoomMode:edgePadding:` instead.");

/**
 选择当前选中建筑的楼层
 @param floor 选择的楼层名字。
 @param zoomMode 缩放方式
 @param insets 缩放适配边距，如果 zoomMode 为 `MXMZoomDisable`，则传入值无效
 */
- (void)selectFloor:(nullable NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets;

/**
 选择建筑，楼层会自动切换到map从创建开始最近一次的楼层切换历史，如果没有，则切换到地面层，地图默认会移动到该建筑区域，缩放适配边距为0
 @param buildingId 要选中的建筑ID
 */
- (void)selectBuilding:(nullable NSString *)buildingId;

/**
 选择建筑，楼层会自动切换到map从创建开始最近一次的楼层切换历史，如果没有，则切换到地面层
 @param buildingId 要选中的建筑ID
 @param zoomTo 设置ID后是否缩放到该建筑占用整屏
 */
- (void)selectBuilding:(nullable NSString *)buildingId shouldZoomTo:(BOOL)zoomTo DEPRECATED_MSG_ATTRIBUTE("Use `-selectBuilding:zoomMode:edgePadding:` instead.");

/**
 选择建筑，楼层会自动切换到map从创建开始最近一次的楼层切换历史，如果没有，则切换到地面层
 @param buildingId 要选中的建筑ID
 @param zoomMode 缩放方式
 @param insets 缩放适配边距，如果 zoomMode 为 `MXMZoomDisable`，则传入值无效
 */
- (void)selectBuilding:(nullable NSString *)buildingId
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets;

/**
 选择建筑与该建筑的楼层，地图默认会移动到该建筑区域，缩放适配边距为0
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
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo DEPRECATED_MSG_ATTRIBUTE("Use `-selectBuilding:floor:zoomMode:edgePadding:` instead.");

/**
 选择建筑与该建筑的楼层
 @param buildingId 要选中的建筑ID
 @param floor 选择的楼层名字
 @param zoomMode 缩放方式
 @param insets 缩放适配边距，如果 zoomMode 为 `MXMZoomDisable`，则传入值无效
 */
- (void)selectBuilding:(nullable NSString *)buildingId
                 floor:(nullable NSString *)floor
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets;

/// 当前地图View的已经添加的室内标注数组
@property (nonatomic, readonly) NSArray<MXMPointAnnotation *> *MXMAnnotations;

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



