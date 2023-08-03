//
//  MXMDecider.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MXMDefine.h"
#import "MXMLevelModel.h"
#import "MXMSite.h"

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
                     shouldCallBack:(BOOL)shouldCallBack;
// 操作缩放
- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox
                   zoomMode:(MXMZoomMode)zoomMode
            withEdgePadding:(UIEdgeInsets)insets;


@end



@interface MXMDecider : NSObject

@property (nonatomic, assign) BOOL isMapReload;
@property (nonatomic, assign) MXMFloorSwitchMode floorSwitchMode;

@property (nonatomic, strong, nullable) MXMFloor *selectedFloor;
@property (nonatomic, strong, nullable) MXMGeoBuilding *selectedBuilding;
@property (nonatomic, strong, nullable) MXMGeoVenue *selectedVenue;

@property (nonatomic, strong) NSMutableArray<NSString *> *historicalBuildingIds; // 保存运行期间看过的大厦Id，防止同一地点两栋大厦间互相切换
@property (nonatomic, strong) NSMutableDictionary<NSString *, MXMOrdinal *> *venueSelectFloorOrdinalDic; // 保存运行期间看过大厦最后选中的对应楼层
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *buildingSelectFloorIdDic; // 保存运行期间大厦对应楼层历史

@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMLevelModel *> *visibleFloors;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMGeoBuilding *> *visibleBuildings;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMGeoVenue *> *visibleVenues;

@property (nonatomic, weak) id<MXMDeciderDelegate> delegate;

- (instancetype)initWithDelegate:(id<MXMDeciderDelegate>)delegate;

// 移动地图确定建筑
- (void)decideInRectWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings;

// 点击地图确定建筑
- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors;

// 定位时确定建筑
- (nullable MXMSite *)decideWithUserLocationLevel:(NSInteger)level
                               atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                             atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList;

- (void)specifyTheFloorId:(nullable NSString *)floorId
                 zoomMode:(MXMZoomMode)zoomMode
              edgePadding:(UIEdgeInsets)insets
 shouldChangeTrackingMode:(BOOL)changeTrackingMode;

- (void)specifyTheBuildingId:(nullable NSString *)buildingId
                    zoomMode:(MXMZoomMode)zoomMode
                 edgePadding:(UIEdgeInsets)insets
    shouldChangeTrackingMode:(BOOL)changeTrackingMode;

- (void)specifyTheVenueId:(nullable NSString *)venueId
                 zoomMode:(MXMZoomMode)zoomMode
              edgePadding:(UIEdgeInsets)insets
 shouldChangeTrackingMode:(BOOL)changeTrackingMode;


// TODO: 删除
- (void)specifyTheBuilding:(nullable NSString *)buildingId
                 floorCode:(nullable NSString *)floorCode
                   ordinal:(nullable MXMOrdinal *)ordinal
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
           withGeoBuilding:(nullable MXMGeoBuilding *)building;

- (float)decideLocationViewAlphaWithCurrentFloorId:(NSString *)curFloorId
                                     andLocalFloor:(nullable CLFloor *)floor
                              atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList;

- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameOrdinal:(nullable MXMOrdinal *)ordinal;
- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameId:(nullable NSString *)floorId;
- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameCode:(nullable NSString *)floorCode;

- (nullable MXMFloor *)electDefaultFloorWithVenueHistory:(NSDictionary *)historyDic
                                              inBuilding:(MXMGeoBuilding *)building
                                           ignoreHistory:(BOOL)ignore;
- (nullable MXMFloor *)electDefaultFloorWithBuildingHistory:(NSDictionary *)historyDic
                                                 inBuilding:(MXMGeoBuilding *)building;

@end

NS_ASSUME_NONNULL_END
