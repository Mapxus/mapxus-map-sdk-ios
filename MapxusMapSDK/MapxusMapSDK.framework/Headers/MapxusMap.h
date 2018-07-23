//
//  MapxusMap.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGLMapView;
@class MXMGeoBuilding;
@class MXMPointAnnotation;
@protocol MGLMapViewDelegate;
@protocol MapxusMapDelegate;

/**
 BeeMap地图外观
 */
typedef NS_ENUM(NSUInteger, MXMStyle) {
    /**
     默认类型
     */
    MXMStyleCOMMON,
    /**
     圣诞节风格
     */
    MXMStyleCHRISTMAS,
    /**
     万圣节风格
     */
    MXMStyleHALLOWMAS,
    /**
     MAPPYBEE风格
     */
    MXMStyleMAPPYBEE,
    /**
     openStreet风格
     */
    MXMStyleOPENMAP,
};

NS_ASSUME_NONNULL_BEGIN


@interface MapxusMap : NSObject


/**
 MapxusMap的事件回调代理
 */
@property (nonatomic, weak) id<MapxusMapDelegate> delegate;

/**
 MapxusMap初始化函数，初始化只能调用此函数

 @param mapView MapBox的mapView
 @return MapxusMap对象
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

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
 可选建筑列表
 */
@property (nonatomic, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

/**
 选择当前选中建筑的楼层
 
 @param floor 选择的楼层名字。
 */
- (void)selectFloor:(nullable NSString *)floor;

/**
 选择建筑
 
 @param buildingId 要选中的建筑ID
 */
- (void)selectBuilding:(nullable NSString *)buildingId;

/**
 选择建筑与该建筑的楼层
 
 @param buildingId 要选中的建筑ID
 @param floor 选择的楼层名字
 */
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor;

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



