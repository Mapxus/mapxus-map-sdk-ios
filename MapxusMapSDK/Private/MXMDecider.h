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
#import "MXMFilterModel.h"
#import "MXMGeoVenue+Private.h"
#import "MXMGeoBuilding+Private.h"
#import "MXMGeoPOI+Private.h"

@class MXMBoundingBox;

NS_ASSUME_NONNULL_BEGIN

@protocol MXMDeciderDelegate <NSObject>

- (void)decideMapViewShowFloorBar:(BOOL)show
                          atVenue:(nullable MXMGeoVenue *)venue
                       inBuilding:(nullable MXMGeoBuilding *)building
                            floor:(nullable MXMFloor *)floor;
// 将要选中
// TODO: 删除venue和building参数
- (void)decideMapViewShouldChangeBuilding:(nullable MXMGeoBuilding *)building
                                  atVenue:(nullable MXMGeoVenue *)venue
                                    floor:(nullable MXMFloor *)floor
                 shouldChangeTrackingMode:(BOOL)changeTrackingMode;
// 选中
- (void)decideMapViewChangeWithFilterModel:(nullable MXMFilterModel *)filter;

- (NSArray<MXMGeoPOI *> *)poisOnRearFloorIds:(NSArray<NSString *> *)floorIds;

// 操作缩放
- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox
                   zoomMode:(MXMZoomMode)zoomMode
            withEdgePadding:(UIEdgeInsets)insets;

@end



@interface MXMDecider : NSObject {
  NSSet *_lastForeFloorIds;
  NSSet *_lastRearFloorIds;
  NSSet *_lastAllFloorIds;
  NSSet *_lastExceptPoiIds;
  NSSet *_lastBuildingIds;
}

@property (nonatomic, assign) BOOL isMapReload;
@property (nonatomic, assign) MXMFloorSwitchMode floorSwitchMode;
@property (nonatomic, assign) BOOL maskNonSelectedSite;

@property (nonatomic, strong, nullable) MXMFloor *selectedFloor;
@property (nonatomic, strong, nullable) NSString *selectedBuildingId;
@property (nonatomic, strong, nullable) NSString *selectedVenueId;

// TODO: 删除
@property (nonatomic, strong, nullable) MXMGeoBuilding *selectedBuilding;
@property (nonatomic, strong, nullable) MXMGeoVenue *selectedVenue;
// TODO: 删除

@property (nonatomic, strong) NSMutableArray<NSString *> *historicalBuildingIds; // 保存运行期间看过的大厦Id，防止同一地点两栋建筑间互相切换
@property (nonatomic, strong) NSMutableDictionary<NSString *, MXMOrdinal *> *venueSelectFloorOrdinalDic; // 保存运行期间看过建筑最后选中的对应楼层
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *buildingSelectFloorIdDic; // 保存运行期间建筑对应楼层历史
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *venueSelectFloorIdDic; // 保存运行期间园区对应楼层历史

@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMLevelModel *> *visibleFloors;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMGeoBuilding *> *visibleBuildings;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, MXMGeoVenue *> *visibleVenues;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *foreRearDic; // YES表示在前景显示

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

- (void)cleanHistory;

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
