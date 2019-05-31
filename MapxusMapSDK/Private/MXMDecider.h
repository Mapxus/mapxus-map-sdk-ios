//
//  MXMDecider.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMGeoBuilding.h"
#import "MXMIndoorMapInfo.h"
#import <Mapbox/Mapbox.h>

@class MXMBoundingBox;

NS_ASSUME_NONNULL_BEGIN

@protocol MXMDeciderDelegate <NSObject>

- (void)decideMapViewShouldChangeBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode;


- (void)decideMapViewChangeBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode;

- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox;

- (void)decideMapViewShowFloorBar:(BOOL)show onBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor;

@end



@interface MXMDecider : NSObject

@property (nonatomic, assign) BOOL isMapReload;

@property (nonatomic, weak) id<MXMDeciderDelegate> delegate;

- (instancetype)initWithDelegate:(id<MXMDeciderDelegate>)delegate;

// 当前选中楼层
@property (nonatomic, copy, readonly) NSString *currentFloor;

// 当前选中建筑
@property (nonatomic, copy, readonly) MXMGeoBuilding *currentBuilding;

// 移动地图确定建筑
- (void)decideInRectBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

// 点击地图确定建筑
- (void)decideAtPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

// 定位时确定建筑
- (nullable MXMIndoorMapInfo *)decideWithUserLocationLevel:(NSInteger)level atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

// 指定建筑
- (void)specifyTheBuilding:(NSString *)buildingId
                     floor:(nullable NSString *)floor
              shouldZoomTo:(BOOL)zoomTo
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
       withRectBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

- (float)decideLocationViewAlphaWithCurrentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andLocalFloor:(nullable CLFloor *)floor;

@end

NS_ASSUME_NONNULL_END
