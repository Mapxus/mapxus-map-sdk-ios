//
//  MXMDecider.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMGeoBuilding.h"
#import "MXMGeoVenue.h"
#import "MXMIndoorMapInfo.h"
#import <Mapbox/Mapbox.h>
#import "MXMDefine.h"
#import "MXMLevelModel.h"

@class MXMBoundingBox;

NS_ASSUME_NONNULL_BEGIN

@protocol MXMDeciderDelegate <NSObject>

- (void)decideMapViewShowFloorBar:(BOOL)show
                       inBuilding:(nullable MXMGeoBuilding *)building
                            floor:(nullable MXMFloor *)floor;
// 将要选中
- (void)decideMapViewShouldChangeBuilding:(nullable MXMGeoBuilding *)building
                                    floor:(nullable MXMFloor *)floor
                 shouldChangeTrackingMode:(BOOL)changeTrackingMode;
// 选中
- (void)decideMapViewChangeBuilding:(nullable MXMGeoBuilding *)building
                              floor:(nullable MXMFloor *)floor
                       trackingMode:(BOOL)changeTrackingMode
                     shouldCallBack:(BOOL)shouldCallBack;
// 操作缩放
- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox
                   zoomMode:(MXMZoomMode)zoomMode
            withEdgePadding:(UIEdgeInsets)insets;


@end



@interface MXMDecider : NSObject

@property (nonatomic, assign) BOOL isMapReload;
@property (nonatomic, assign) MXMFloorSwitchMode floorSwitchMode;
@property (nonatomic, strong) NSMutableDictionary *venueSelectFloorDic; // 保存运行期间看过大厦最后选中的对应楼层
@property (nonatomic, strong) NSMutableDictionary *buildingSelectFloorIdDic; // 保存运行期间大厦对应楼层历史
@property (nonatomic, strong) NSMutableArray<NSString *> *historicalBuildingIds; // 保存运行期间看过的大厦Id，防止同一地点两栋大厦间互相切换

@property (nonatomic, weak) id<MXMDeciderDelegate> delegate;

- (instancetype)initWithDelegate:(id<MXMDeciderDelegate>)delegate;

// 当前选中楼层
@property (nonatomic, copy, readonly, nullable) MXMOrdinal *currentFloorOrdinal;

// 当前选中建筑
@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *currentBuilding;

// 移动地图确定建筑
- (void)decideInRectBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

// 点击地图确定建筑
- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors;

// 定位时确定建筑
- (nullable MXMIndoorMapInfo *)decideWithUserLocationLevel:(NSInteger)level
                                        atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                      atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList;

// 指定建筑
- (void)specifyTheBuilding:(nullable NSString *)buildingId
                 floorCode:(nullable NSString *)floorCode
                   ordinal:(nullable MXMOrdinal *)ordinal
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
           withGeoBuilding:(nullable MXMGeoBuilding *)building;

- (float)decideLocationViewAlphaWithCurrentBuilding:(MXMGeoBuilding *)curBuilding
                                       currentFloor:(NSString *)curFloor
                                      andLocalFloor:(nullable CLFloor *)floor;


- (nullable MXMOrdinal *)electDefaultFloorWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building;
- (nullable NSString *)electDefaultFloorIdWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building;

- (nullable MXMFloor *)absMin:(NSArray<MXMFloor *> *)floors;

@end

NS_ASSUME_NONNULL_END
