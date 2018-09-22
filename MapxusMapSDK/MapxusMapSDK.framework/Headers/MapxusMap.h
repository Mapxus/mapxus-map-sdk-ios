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
     蒂芙尼蓝风格
     */
    MXMStyleMAPXUS,
};



/**
 楼层控制器位置
 */
typedef NS_ENUM(NSInteger, MXMSelectorPosition) {
    /**
     楼层控制器在左边
     */
    MXMSelectorPositionCenterLeft,
    /**
     楼层控制器在右边
     */
    MXMSelectorPositionCenterRight,
    /**
     楼层控制器在左下角
     */
    MXMSelectorPositionBottomLeft,
    /**
     楼层控制器在右下角
     */
    MXMSelectorPositionBottomRight,
    /**
     楼层控制器在左上角
     */
    MXMSelectorPositionTopLeft,
    /**
     楼层控制器在右上角
     */
    MXMSelectorPositionTopRight,
};


NS_ASSUME_NONNULL_BEGIN



/**
 MapxusMap主类
 */
@interface MapxusMap : NSObject


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
 添加地图标注，如需要添加室内点，必须调用此方法才会分层显示。

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



