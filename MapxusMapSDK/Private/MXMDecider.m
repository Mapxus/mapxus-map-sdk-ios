//
//  MXMDecider.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMDecider.h"
#import "MXMSearchBuildingOperation.h"
#import "MXMSearchVenueOperation.h"
#import "MXMSearchFloorOperation.h"
#import "MXMCommonObj.h"
#import <YYModel/YYModel.h>
#import "NSString+Compare.h"
#import "JXJsonFunctionDefine.h"


@interface MXMDecider ()

@property (nonatomic, strong) MXMSearchBuildingOperation *operation;
@property (nonatomic, strong) MXMSearchVenueOperation *venueOperation;
@property (nonatomic, strong) MXMSearchFloorOperation *floorOperation;

@end




@implementation MXMDecider


#pragma mark - init

- (instancetype)initWithDelegate:(id<MXMDeciderDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

#pragma mark - 集合筛选

// 自动选择默认选中建筑
- (void)decideInRectWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
  // 默认选中building，规则为优先选中之前选过的
  MXMSite *site = [self electIndoorSiteWithBuildingHistory:self.historicalBuildingIds
                                               inBuildings:buildings];
  if (site) {
    [self specifyTheFloorId:site.floor.floorId
                   zoomMode:MXMZoomDisable
                edgePadding:UIEdgeInsetsZero
   shouldChangeTrackingMode:NO];
  } else {
// TODO: 因为找不到选中建筑也需要重置一次，如果已选中floor在屏外，会导致无用的floorId search building接口调用，需要进行优化。使用新接口
//    [self specifyTheFloorId:self.selectedFloor.floorId
//                   zoomMode:MXMZoomDisable
//                edgePadding:UIEdgeInsetsZero
//   shouldChangeTrackingMode:NO];
    [self specifyTheBuilding:self.selectedBuilding.identifier
                   floorCode:nil
                     ordinal:self.selectedFloor.ordinal
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:NO
             withGeoBuilding:self.selectedBuilding];
  }
}


- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  MXMSite *info;
  if (self.maskNonSelectedSite) {
    info = [self maskModeSlectIndoorSiteWithCurrentBuilding:self.selectedBuilding
                                                inBuildings:buildings
                                              floorFeatures:floors];
  } else {
    info = [self electIndoorSiteWithCurrentBuilding:self.selectedBuilding
                                        inBuildings:buildings
                                      floorFeatures:floors];
  }
  if (info == nil) { return; }
  [self specifyTheFloorId:info.floor.floorId
                 zoomMode:MXMZoomDisable
              edgePadding:UIEdgeInsetsZero
 shouldChangeTrackingMode:YES];
}

- (nullable MXMSite *)decideWithUserLocationLevel:(NSInteger)level
                               atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                             atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList
{
  for (MXMLevelModel *model in levelInfoList) {
    if (model.ordinal && model.ordinal.level == level) {
      NSString *buildingId = model.refBuildingId;
      
      MXMGeoBuilding *building = [buildings objectForKey:buildingId];
      MXMGeoVenue *venue = self.visibleVenues[building.venueId];
      
      MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
      ordinal.level = level;
      
      MXMFloor *floor = [[MXMFloor alloc] init];
      floor.floorId = model.levelId;
      floor.code = model.name;
      floor.ordinal = ordinal;
      
      [self specifyTheFloorId:floor.floorId
                     zoomMode:MXMZoomDisable
                  edgePadding:UIEdgeInsetsZero
     shouldChangeTrackingMode:NO];
      
      MXMSite *info = [[MXMSite alloc] init];
      info.venue = venue;
      info.building = building;
      info.floor = floor;
      return info;
    }
  }
  return nil;
}

#pragma mark - 指定选中
- (void)specifyTheFloorId:(nullable NSString *)floorId
                 zoomMode:(MXMZoomMode)zoomMode
              edgePadding:(UIEdgeInsets)insets
 shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (floorId) {
    // TODO: 进行速度测试，看是搜索快还是通过生成字典查询快
//    MXMLevelModel *level = self.visibleFloors[floorId];
    MXMFloor *floor;
    MXMGeoBuilding *building;
    for (MXMGeoBuilding *inBuilding in self.visibleBuildings.allValues) {
      for (MXMFloor *inFloor in inBuilding.floors) {
        if ([inFloor.floorId isEqualToString:floorId]) {
          floor = inFloor;
          building = inBuilding;
          break;
        }
      }
      // 退出外层循环
      if (floor) {
        break;
      }
    }
    if (floor && (zoomMode == MXMZoomDisable)) {
      MXMGeoVenue *venue = self.visibleVenues[building.venueId];
      [self displayWihtFloor:floor building:building venue:venue shouldChangeTrackingMode:changeTrackingMode];
    } else {
      __weak typeof(self) weakSelf = self;
      self.floorOperation.complateBlock = ^(MXMBuilding * _Nullable netBuilding) {
        MXMFloor *netFloor = ((MXMFloorInfo *)netBuilding.floors.firstObject).floor;
        if (netFloor && netBuilding) {
          // 调用zoom map
          if (zoomMode != MXMZoomDisable && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
            [weakSelf.delegate decideMapViewZoomTo:netBuilding.bbox zoomMode:zoomMode withEdgePadding:insets];
          }
          // 显示建筑
          MXMGeoBuilding *theEndBuilding = [weakSelf exchangeGeoBuildingFrom:netBuilding];
          MXMGeoVenue *theEndVenue = [weakSelf exchangeGeoVenueFromBuilding:netBuilding];
          [weakSelf displayWihtFloor:netFloor building:theEndBuilding venue:theEndVenue shouldChangeTrackingMode:changeTrackingMode];
        }
      };
      [self.floorOperation searchWithFloorId:floorId];
    }
    return;
  }
  
  // 没有传有效值，清理当前选中
  [self displayWihtFloor:nil building:nil venue:nil shouldChangeTrackingMode:changeTrackingMode];
}

- (void)specifyTheBuildingId:(nullable NSString *)buildingId
                    zoomMode:(MXMZoomMode)zoomMode
                 edgePadding:(UIEdgeInsets)insets
    shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (buildingId) {
    MXMGeoBuilding *building = self.visibleBuildings[buildingId];
    if (building && (zoomMode == MXMZoomDisable)) {
      MXMGeoVenue *venue = self.visibleVenues[building.venueId];
      [self displayWihtFloor:nil building:building venue:venue shouldChangeTrackingMode:changeTrackingMode];
    } else {
      __weak typeof(self) weakSelf = self;
      self.operation.complateBlock = ^(MXMBuilding * _Nullable netBuilding) {
        if (netBuilding) {
          // 调用zoom map
          if (zoomMode != MXMZoomDisable && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
            [weakSelf.delegate decideMapViewZoomTo:netBuilding.bbox zoomMode:zoomMode withEdgePadding:insets];
          }
          // 显示建筑
          MXMGeoBuilding *theEndBuilding = [weakSelf exchangeGeoBuildingFrom:netBuilding];
          MXMGeoVenue *theEndVenue = [weakSelf exchangeGeoVenueFromBuilding:netBuilding];
          [weakSelf displayWihtFloor:nil building:theEndBuilding venue:theEndVenue shouldChangeTrackingMode:changeTrackingMode];
        }
      };
      [self.operation searchWithBuildingId:buildingId];
    }
    return;
  }
  
  // 没有传有效值，清理当前选中
  [self displayWihtFloor:nil building:nil venue:nil shouldChangeTrackingMode:changeTrackingMode];
}

- (void)specifyTheVenueId:(nullable NSString *)venueId
                 zoomMode:(MXMZoomMode)zoomMode
              edgePadding:(UIEdgeInsets)insets
 shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (venueId) {
    // 查看是否有历史选中
    NSString *historyFloorId = self.venueSelectFloorIdDic[venueId];
    if (historyFloorId) {
      [self specifyTheFloorId:historyFloorId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:changeTrackingMode];
      return;
    }
    // 查看是否有defaultBuilding
    MXMGeoVenue *venue = self.visibleVenues[venueId];
    if (venue && venue.defaultDisplayedBuildingId) {
      [self specifyTheBuildingId:venue.defaultDisplayedBuildingId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:changeTrackingMode];
      return;
    }
    // 没有defaultBuilding，获取第一个building
    if (venue) {
      NSString *firstBuildingId = venue.buildingIds.firstObject;
      [self specifyTheBuildingId:firstBuildingId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:changeTrackingMode];
      return;
    }
    // 瓦片找不到venue
    __weak typeof(self) weakSelf = self;
    self.venueOperation.complateBlock = ^(MXMVenue * _Nullable netVenue) {
        // 查看是否有defaultBuilding
        if (netVenue && netVenue.defaultDisplayedBuildingId) {
          [weakSelf specifyTheBuildingId:netVenue.defaultDisplayedBuildingId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:changeTrackingMode];
          return;
        }
        // 没有defaultBuilding，获取第一个building
        if (netVenue) {
          MXMBuilding *firstBuilding = netVenue.buildings.firstObject;
          [weakSelf specifyTheBuildingId:firstBuilding.buildingId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:changeTrackingMode];
          return;
        }
    };
    [self.venueOperation searchWithVenueId:venueId];
    
    return;
  }
  
  // 没有传有效值，清理当前选中
  [self displayWihtFloor:nil building:nil venue:nil shouldChangeTrackingMode:changeTrackingMode];
}

// TODO: 删除
- (void)specifyTheBuilding:(nullable NSString *)buildingId
                 floorCode:(nullable NSString *)floorCode
                   ordinal:(nullable MXMOrdinal *)ordinal
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
           withGeoBuilding:(nullable MXMGeoBuilding *)building
{
  // 从地图瓦片获取建筑数据
  BOOL state = [self shouldBeQueryWithBuilding:building shouldZoomTo:(zoomMode != MXMZoomDisable)];
  if (state) {
    // 因为接口不能什么参数都不传，所以如果 buildingId 为空，不进行网络搜索直接进入下一环节，清理当前选中
    if (buildingId == nil || buildingId.length <= 0) {
      [self displayWihtGeoBuilding:nil geoVenue:nil setFloorCode:nil setOrdinal:nil shouldChangeTrackingMode:changeTrackingMode];
      return;
    }
    __weak typeof(self) weakSelf = self;
    self.operation.complateBlock = ^(MXMBuilding * _Nullable netBuilding) {
      if (netBuilding) {
        // 调用zoom map
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
          [weakSelf.delegate decideMapViewZoomTo:netBuilding.bbox zoomMode:zoomMode withEdgePadding:insets];
        }
        // 显示建筑
        MXMGeoBuilding *theEndBuilding = [weakSelf exchangeGeoBuildingFrom:netBuilding];
        MXMGeoVenue *theEndVenue = [weakSelf exchangeGeoVenueFromBuilding:netBuilding];
        [weakSelf displayWihtGeoBuilding:theEndBuilding geoVenue:theEndVenue setFloorCode:floorCode setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
      }
    };
    [self.operation searchWithBuildingId:buildingId];
  } else { // 不用zoom也不用网络查询的情况
    // 显示建筑
    [self displayWihtGeoBuilding:building geoVenue:nil setFloorCode:floorCode setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
  }
}

#pragma mark - clean
- (void)cleanHistory {
  _lastForeFloorIds = nil;
  _lastRearFloorIds = nil;
  _lastAllFloorIds = nil;
  _lastExceptPoiIds = nil;
  _lastBuildingIds = nil;
}

#pragma mark - private

// TODO: 删除
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)building
                      geoVenue:(nullable MXMGeoVenue *)venue
                  setFloorCode:(nullable NSString *)setFloorCode
                    setOrdinal:(nullable MXMOrdinal *)setOrdinal
      shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
  MXMGeoVenue *theEndVenue = self.visibleVenues[building.venueId] ? : venue;
  MXMGeoBuilding *theEndBuilding = building;
  MXMFloor *theEndFloor;
    
  if (theEndBuilding) {
    // 通过ordinal找floor
    if (setOrdinal) {
      theEndFloor = [self buildingFloors:theEndBuilding.floors whichHasSameOrdinal:setOrdinal];
    }
    // 通过name找floor
    if (setFloorCode && !theEndFloor) {
      theEndFloor = [self buildingFloors:theEndBuilding.floors whichHasSameCode:setFloorCode];
    }
    // 如果没有设置，通过历史找或者最接近地面的层
    if (!theEndFloor) {
      if (self.floorSwitchMode == MXMSwitchedByVenue) {
        theEndFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic
                                                   inBuilding:theEndBuilding
                                                ignoreHistory:YES];
      } else {
        theEndFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic
                                                      inBuilding:theEndBuilding];
      }
    }
    // 如果找不到有效楼层，建筑也设置为空
    if (theEndFloor == nil) {
      theEndBuilding = nil;
      theEndVenue = nil;
    }
  }
  
  [self _selectFloor:theEndFloor building:theEndBuilding venue:theEndVenue shouldChangeTrackingMode:changeTrackingMode];
}

// 取出有效的值building与ordinal，如果取不了，置为building与ordinal应该都为nil
- (void)displayWihtFloor:(nullable MXMFloor *)floor
                building:(nullable MXMGeoBuilding *)building
                   venue:(nullable MXMGeoVenue *)venue
shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
  MXMGeoVenue *theEndVenue = self.visibleVenues[building.venueId] ? : venue;
  MXMGeoBuilding *theEndBuilding = building;
  MXMFloor *theEndFloor = floor;
  
  if (theEndBuilding) {
    // 如果没有设置，通过历史找或者最接近地面的层
    if (!theEndFloor) {
      if (self.floorSwitchMode == MXMSwitchedByVenue) {
        theEndFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic
                                                   inBuilding:theEndBuilding
                                                ignoreHistory:YES];
      } else {
        theEndFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic
                                                      inBuilding:theEndBuilding];
      }
    }
    // 如果找不到有效楼层，建筑也设置为空
    if (theEndFloor == nil) {
      theEndBuilding = nil;
      theEndVenue = nil;
    }
  }
  
  [self _selectFloor:theEndFloor building:theEndBuilding venue:theEndVenue shouldChangeTrackingMode:changeTrackingMode];
}


// 拿到有效唯一值信息，且保证building与floorOrdinal同时为nil或不同时为nil，如果为nil，则清除选中
- (void)_selectFloor:(nullable MXMFloor *)floor
    building:(nullable MXMGeoBuilding *)building
    venue:(nullable MXMGeoVenue *)venue
    shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:atVenue:inBuilding:floor:)]) {
    BOOL show = building ? YES : NO;
    [self.delegate decideMapViewShowFloorBar:show atVenue:venue inBuilding:building floor:floor];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:atVenue:floor:shouldChangeTrackingMode:)]) {
    [self.delegate decideMapViewShouldChangeBuilding:building
                                             atVenue:venue
                                               floor:floor
                            shouldChangeTrackingMode:changeTrackingMode];
  }
  
  BOOL hasChangedBuildingOrOrdinal = [self hasChangedWithBuilding:building
                                                     floorOrdinal:floor.ordinal
                                                  currentBuilding:self.selectedBuilding
                                              currentFloorOrdinal:self.selectedFloor.ordinal
                                                     andMapReload:self.isMapReload];
  
  if (hasChangedBuildingOrOrdinal) {
    self.selectedFloor = floor;
    self.selectedBuildingId = building.identifier;
    self.selectedVenueId = venue.identifier;
    self.selectedBuilding = building;
    self.selectedVenue = venue;
    if (building) {
      // 保存id到选中队列，并取100条数据
      [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
      if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
      }
      
      // 保持建筑的选择楼层，下次作为默认选中楼层
      self.venueSelectFloorOrdinalDic[building.venueId] = floor.ordinal;
      self.buildingSelectFloorIdDic[building.identifier] = floor.floorId;
      self.venueSelectFloorIdDic[building.venueId] = floor.floorId;
    }
  }
  
  MXMFilterModel *filter = [[MXMFilterModel alloc] init];
  filter.selectedBuilding = building;
  filter.selectedVenue = venue;
  filter.selectedFloor = floor;
  filter.selectedBuildingId = building.identifier;
  filter.selectedVenueId = venue.identifier;
  filter.shouldCallBack = hasChangedBuildingOrOrdinal;
  
  // 配置过滤条件
  //  NSMutableArray *sameVenueLevelIds = [NSMutableArray array];
  NSSet *foreFloorIds;
  NSSet *rearFloorIds;
  if (self.floorSwitchMode == MXMSwitchedByVenue) {
    NSDictionary *dic = [self syncModelToGetShowFloorIdsWithFloor:floor building:building];
    foreFloorIds = dic[@"fore"];
    rearFloorIds = dic[@"rear"];
  } else {
    NSDictionary *dic = [self asyncModelToGetShowFloorIdsWithFloor:floor building:building];
    foreFloorIds = dic[@"fore"];
    rearFloorIds = dic[@"rear"];
  }
  
  // 过滤前景
  if (
      _lastForeFloorIds == nil ||
      (foreFloorIds.count == 0 && _lastForeFloorIds.count != 0) ||
      ![foreFloorIds isSubsetOfSet:_lastForeFloorIds] ||
      self.isMapReload
      ) {
        filter.foreFloorIds = [foreFloorIds allObjects];
      }
  // 过滤后景
  if (
      _lastRearFloorIds == nil ||
      ![rearFloorIds isEqualToSet:_lastRearFloorIds] ||
      self.isMapReload
      ) {
        filter.rearFloorIds = [rearFloorIds allObjects];
      }
  
  NSMutableSet *allFloorIds = [NSMutableSet set];
  [allFloorIds unionSet:foreFloorIds];
  [allFloorIds unionSet:rearFloorIds];
  // 计算后景中需要去除的POI
  NSSet *exceptPoiIds = [self findCoverPoiWithLevelIds:foreFloorIds rearLevelIds:rearFloorIds];
  // 添加_lastxxx == nil是为了防止[- isSubsetOfSet:]传入nil
  BOOL allFloorSetChange = _lastAllFloorIds == nil || (allFloorIds.count == 0 && _lastAllFloorIds.count != 0) || ![allFloorIds isSubsetOfSet:_lastAllFloorIds];
  BOOL exceptPoiSetChange = _lastExceptPoiIds == nil || ![exceptPoiIds isEqualToSet:_lastExceptPoiIds];
  
  if (self.isMapReload || allFloorSetChange || exceptPoiSetChange) {
    filter.allFloorIds = [allFloorIds allObjects];
    filter.exceptPoiIds = [exceptPoiIds allObjects];
  }
  
  //  [_mapView.style setLevelIdsTransparent:sameVenueLevelIds];
  // 保存上一次的结果
  _lastForeFloorIds = foreFloorIds;
  _lastRearFloorIds = rearFloorIds;
  _lastAllFloorIds = allFloorIds;
  _lastExceptPoiIds = exceptPoiIds;
  
  // 添加building遮罩层
  if (self.maskNonSelectedSite) {
    NSSet *buildingIdSet = [NSSet set];
    
    if (self.floorSwitchMode == MXMSwitchedByVenue) {
      buildingIdSet = [self syncModelToGetShowBuildingIdsWithSelectedBuilding:building];
    } else {
      if (building.identifier) {
        buildingIdSet = [NSSet setWithObject: building.identifier];
      }
    }
    if (buildingIdSet.count == 0 || ![buildingIdSet isSubsetOfSet:_lastBuildingIds] || self.isMapReload) {
      filter.maskBuildingIds = [buildingIdSet allObjects];
      filter.maskBuildingIdNotInList = (self.floorSwitchMode == MXMSwitchedByVenue);
    }
    // 保存上一次的结果
    _lastBuildingIds = buildingIdSet;
  }
  
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeWithFilterModel:)]) {
    [self.delegate decideMapViewChangeWithFilterModel:filter];
  }
}

#pragma mark - 筛选逻辑
- (BOOL)shouldBeQueryWithBuilding:(nullable MXMGeoBuilding *)building shouldZoomTo:(BOOL)zoomTo
{
  if (building && !zoomTo) {
    return NO;
  } else {
    return YES;
  }
}

- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameOrdinal:(nullable MXMOrdinal *)ordinal {
  if (ordinal == nil) { return nil;}
  for (MXMFloor *floor in floors) {
    if (floor.ordinal && floor.ordinal.level == ordinal.level) {
      return floor;
    }
  }
  return nil;
}

- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameId:(nullable NSString *)floorId {
  if (floorId == nil) { return nil;}
  for (MXMFloor *floor in floors) {
    if (floor.floorId && [floorId isEqualToString:floor.floorId]) {
      return floor;
    }
  }
  return nil;
}

- (nullable MXMFloor *)buildingFloors:(NSArray *)floors whichHasSameCode:(nullable NSString *)floorCode {
  if (floorCode == nil) { return nil;}
  for (MXMFloor *floor in floors) {
    if (floor.code && [floorCode isEqualToString:floor.code]) {
      return floor;
    }
  }
  return nil;
}


// 选举默认选中建筑，参考历史最近选中
- (nullable MXMSite *)electIndoorSiteWithBuildingHistory:(NSArray<NSString *> *)historyList
                                             inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
  MXMGeoBuilding *selectedBuilding;
  MXMFloor *selectedFloor;
  // 查看历史选中
  for (NSString *buildingId in historyList) {
    MXMGeoBuilding *building = buildings[buildingId];
    if (building) {
      if (self.floorSwitchMode == MXMSwitchedByVenue) {
        selectedFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic inBuilding:building ignoreHistory:NO];
      } else {
        selectedFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic inBuilding:building];
      }
      if (selectedFloor) {
        selectedBuilding = building;
        break;
      }
    }
  }
  // 随机选中
  if (selectedBuilding == nil) {
    if (self.floorSwitchMode == MXMSwitchedByVenue) {
      for (MXMGeoBuilding *iBuilding in buildings.allValues) {
        selectedFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic inBuilding:iBuilding ignoreHistory:NO];
        if (selectedFloor) {
          selectedBuilding = iBuilding;
          break;
        }
      }
    } else {
      MXMGeoBuilding *firstBuilding = [buildings allValues].firstObject;
      selectedFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic inBuilding:firstBuilding];
      if (selectedFloor) {
        selectedBuilding = firstBuilding;
      }
    }
  }
  
  MXMSite *info;
  if (selectedBuilding && selectedFloor) {
    info = [[MXMSite alloc] init];
    info.building = selectedBuilding;
    info.floor = selectedFloor;
  }
  return info;
}

// 在点击位置上筛选应该选中的楼层与建筑
- (nullable MXMSite *)maskModeSlectIndoorSiteWithCurrentBuilding:(nullable MXMGeoBuilding *)building
                                                     inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                                   floorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  // 点击了不显示覆盖层的地方，按原来的逻辑跑
  if (floors.count && (self.floorSwitchMode == MXMSwitchedByVenue)) {
    MXMSite *info = [self electIndoorSiteWithCurrentBuilding:self.selectedBuilding
                                                 inBuildings:buildings
                                               floorFeatures:floors];
    return info;
  }
  
  // 点击了显示覆盖层的地方
  // 查找该点上的其他建筑信息
  MXMGeoBuilding *selectedBuilding;
  MXMFloor *selectedFloor;
  if (self.floorSwitchMode == MXMSwitchedByVenue) {
    for (MXMGeoBuilding *buildingItem in [buildings allValues]) {
      selectedFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic
                                                 inBuilding:buildingItem
                                              ignoreHistory:NO];
      if (selectedFloor) {
        selectedBuilding = buildingItem;
        break;
      }
    }
  } else {
    for (MXMGeoBuilding *buildingItem in [buildings allValues]) {
      selectedFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic
                                                    inBuilding:buildingItem];
      if (selectedFloor) {
        selectedBuilding = buildingItem;
        break;
      }
    }
  }
  
  MXMSite *info;
  if (selectedBuilding && selectedFloor) {
    info = [[MXMSite alloc] init];
    info.building = selectedBuilding;
    info.floor = selectedFloor;
  }
  return info;
}

// 在点击位置上筛选应该选中的楼层与建筑
- (nullable MXMSite *)electIndoorSiteWithCurrentBuilding:(nullable MXMGeoBuilding *)building
                                             inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                           floorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  if (floors.count <= 0) { return nil; }
  
  // 查找该点上的其他建筑信息
  MXMGeoBuilding *selectedBuilding;
  MXMFloor *selectedFloor;
  
  if (building == nil) {
    // 当前没有选中建筑
    MXMLevelModel *theFloor = floors.firstObject;
    MXMGeoBuilding *refBuilding = buildings[theFloor.refBuildingId];
    selectedFloor = [self buildingFloors:refBuilding.floors whichHasSameId:theFloor.levelId];
    if (selectedFloor) {
      selectedBuilding = refBuilding;
    }
  } else {
    // 当前有选中建筑
    // 找出与当前选中建筑相同building或相同venue的楼层
    NSMutableArray<MXMLevelModel *> *sameBuildingLevelList = [NSMutableArray array];
    NSMutableArray<MXMLevelModel *> *sameVenueLevelList = [NSMutableArray array];
    for (MXMLevelModel *theFloor in floors) {
      MXMGeoBuilding *refBuilding = buildings[theFloor.refBuildingId];
      if ([refBuilding.identifier isEqualToString:building.identifier]) {
        [sameBuildingLevelList addObject:theFloor];
      }
      if ([refBuilding.venueId isEqualToString:building.venueId]) {
        [sameVenueLevelList addObject:theFloor];
      }
    }
    
    NSInteger type = 0; // 0: not same building or venue; 1: same venue; 2: same building
    // 表明点在了已选中的building上，不做任何操作
    if (sameVenueLevelList.count > 0) {
      type = 1;
    }
    if (sameBuildingLevelList.count > 0) {
      type = 2;
    }
    switch (type) {
      case 1:
      {
        // 表明点在了与选中building相同的venue上，选中子队列的第一个
        MXMLevelModel *theFloor = sameVenueLevelList.firstObject;
        MXMGeoBuilding *refBuilding = buildings[theFloor.refBuildingId];
        selectedFloor = [self buildingFloors:refBuilding.floors whichHasSameId:theFloor.levelId];
        if (selectedFloor) {
          selectedBuilding = refBuilding;
        }
      }
        break;
      case 2:
      {
        selectedBuilding = nil;
        selectedFloor = nil;
      }
        break;
      default:
      {
        // 表明与选中building不同和不在同一个venue
        MXMLevelModel *theFloor = floors.firstObject;
        MXMGeoBuilding *refBuilding = buildings[theFloor.refBuildingId];
        selectedFloor = [self buildingFloors:refBuilding.floors whichHasSameId:theFloor.levelId];
        if (selectedFloor) {
          selectedBuilding = refBuilding;
        }
      }
        break;
    }
  }
  
  MXMSite *info;
  if (selectedBuilding && selectedFloor) {
    info = [[MXMSite alloc] init];
    info.building = selectedBuilding;
    info.floor = selectedFloor;
  }
  return info;
}


// 选举默认选中楼层，参考历史最近选中
- (nullable MXMFloor *)electDefaultFloorWithVenueHistory:(NSDictionary *)historyDic
                                              inBuilding:(MXMGeoBuilding *)building
                                           ignoreHistory:(BOOL)ignore
{
  MXMFloor *selectedFloor;
  
  MXMOrdinal *historyFloorOrdinal = historyDic[building.venueId];
  selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:historyFloorOrdinal];
  if (historyFloorOrdinal && !selectedFloor && !ignore) {
    return nil;
  }
  
  if (!selectedFloor) {
    MXMGeoVenue *venue = self.visibleVenues[building.venueId];
    MXMOrdinal *defaultFloorOrdinal = venue.defaultDisplayedOrdinal;
    selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:defaultFloorOrdinal];
    if (defaultFloorOrdinal && !selectedFloor && !ignore) {
      return nil;
    }
  }
  
  if (!selectedFloor) {
    NSString *defaultFloorId = building.defaultDisplayedFloorId;
    selectedFloor = [self buildingFloors:building.floors whichHasSameId:defaultFloorId];
  }
  if (!selectedFloor) {
    selectedFloor = [self absMin:building.floors];
  }
  return selectedFloor;
}

- (nullable MXMFloor *)electDefaultFloorWithBuildingHistory:(NSDictionary *)historyDic
                                                 inBuilding:(MXMGeoBuilding *)building
{
  MXMFloor *selectedFloor;
  
  NSString *historyFloorId = historyDic[building.identifier];
  selectedFloor = [self buildingFloors:building.floors whichHasSameId:historyFloorId];
  if (!selectedFloor) {
    NSString *defaultFloorId = building.defaultDisplayedFloorId;
    selectedFloor = [self buildingFloors:building.floors whichHasSameId:defaultFloorId];
  }
  if (!selectedFloor) {
    selectedFloor = [self absMin:building.floors];
  }
  return selectedFloor;
}

// nil表明传入了空的floors数组
- (nullable MXMFloor *)absMin:(nullable NSArray<MXMFloor *> *)floors
{
  if (!floors) { return nil;}
  NSUInteger size = floors.count;
  NSInteger low = 0, high = size-1, mid = 0;
  while (low <= high) {
    NSInteger lowO = ((MXMFloor *)floors[low]).ordinal.level;
    NSInteger highO = ((MXMFloor *)floors[high]).ordinal.level;
    if (lowO * highO >= 0)
      return (lowO >= 0) ? (MXMFloor *)floors[low] : (MXMFloor *)floors[high];
    if (low + 1 == high)
      return labs(lowO) < labs(highO) ? (MXMFloor *)floors[low] : (MXMFloor *)floors[high];
    mid = low + (high - low) / 2;
    NSInteger midO = ((MXMFloor *)floors[mid]).ordinal.level;
    if(lowO * midO >= 0)
      low = mid;
    if(highO * midO >= 0)
      high = mid;
  }
  return nil;
}

- (BOOL)hasChangedWithBuilding:(nullable MXMGeoBuilding *)building
                  floorOrdinal:(nullable MXMOrdinal *)floorOrdinal
               currentBuilding:(nullable MXMGeoBuilding *)curBuilding
           currentFloorOrdinal:(nullable MXMOrdinal *)curFloorOrdinal
                  andMapReload:(BOOL)isMapReload
{
  // 一个为nil，一个不为nil
  if ((building == nil) != (curBuilding == nil)) {
    return YES;
  }
  
  if (building == nil && floorOrdinal == nil) {
    return isMapReload;
  } else {
    // 已选中则不进行后续操作，提高应用性能
    if ([curBuilding.identifier isEqualToString:building.identifier] &&
        curFloorOrdinal.level == floorOrdinal.level &&
        !isMapReload) {
      return NO;
    }
    return YES;
  }
}

// TODO: 使用floorId进行同楼层判断
//                     |-同建筑楼层->实
// |--定位点找到楼层瓦片——|
// |                   |-不同建筑楼层->虚
// |
// |
// |--定位点找不到楼层瓦片——|->实
- (float)decideLocationViewAlphaWithCurrentFloorId:(NSString *)curFloorId
                                     andLocalFloor:(nullable CLFloor *)floor
                              atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList
{
  if (levelInfoList.count < 1) {
    return 1.0f;
  }
  
  MXMLevelModel *m = nil;
  if (floor) {
    for (MXMLevelModel *model in levelInfoList) {
      if (model.ordinal && model.ordinal.level == floor.level) {
        m = model;
        break;
      }
    }
  }
  
  if (m) {
    if (curFloorId && [m.levelId isEqualToString:curFloorId]) {
      return 1.0f;
    } else {
      return 0.5f;
    }
  } else {
    return 0.5f;
  }
}

#pragma mark - 筛选其他无选中建筑
- (NSSet *)findCoverPoiWithLevelIds:(NSSet *)levelIds rearLevelIds:(NSSet *)rearLevelIds {
  NSMutableSet *coverPois = [NSMutableSet set];
  NSArray *pois = [self.delegate poisOnRearFloorIds:[rearLevelIds allObjects]];
  for (MXMGeoPOI *p in pois) {
    NSSet *poiOverSet = [NSSet setWithArray:p.overlapFloorIds];
    if ([poiOverSet intersectsSet:levelIds]) {
      [coverPois addObject:p.identifier];
    }
  }
  return [coverPois copy];
}

- (NSSet *)syncModelToGetShowBuildingIdsWithSelectedBuilding:(nullable MXMGeoBuilding *)building {
  NSMutableSet *buildingIds = [NSMutableSet set];
  // 通过venue设置必不覆盖不buildingId，提高效率且优化移动地图显示的体验
  //  if (building) {
  //    MXMGeoVenue *refVenue = self.decider.visibleVenues[building.venueId];
  //    [buildingIds addObjectsFromArray:refVenue.buildingIds];
  //  }
  for (MXMGeoBuilding *buildingItem in self.visibleBuildings.allValues) {
    if (!building || ![buildingItem.venueId isEqualToString:building.venueId]) {
      MXMOrdinal *historyOrdinal = self.venueSelectFloorOrdinalDic[buildingItem.venueId];
      BOOL shouldShow = NO;
      for (MXMFloor *floorItem in buildingItem.floors) {
        if (historyOrdinal && historyOrdinal.level == floorItem.ordinal.level) {
          shouldShow = YES;
          break;
        }
      }
      if (shouldShow) {
        [buildingIds addObject:buildingItem.identifier];
      }
    }
  }
  return [buildingIds copy];
}

- (NSDictionary *)syncModelToGetShowFloorIdsWithFloor:(nullable MXMFloor *)floor
                                             building:(nullable MXMGeoBuilding *)building {
  // 选中的建筑必设为前景
  // TODO: 如果building是网络获取的信息，没有overlapBuildingIds，会发生什么
  if (building.identifier) {
    self.foreRearDic[building.identifier] = @(YES);
    for (NSString *otherBuilding in building.overlapBuildingIds) {
      self.foreRearDic[otherBuilding] = @(NO);
    }
  }
  // 分组查找前后景levelId
  NSMutableSet *foreLevelIds = [NSMutableSet set];
  NSMutableSet *rearLevelIds = [NSMutableSet set];
  
  for (MXMGeoBuilding *buildingItem in self.visibleBuildings.allValues) {
    if ([buildingItem.venueId isEqualToString:building.venueId]) {
      // 已选中venue的建筑
      MXMFloor *theFloor = [self buildingFloors:buildingItem.floors whichHasSameOrdinal:floor.ordinal];
      if (theFloor) {
        
        NSNumber *isFont = self.foreRearDic[buildingItem.identifier];
        BOOL selfFont = isFont ? [isFont boolValue] : NO;
        if (selfFont) {
          [foreLevelIds addObject:theFloor.floorId];
        } else {
          BOOL otherFont = NO;
          for (NSString *buildingId in buildingItem.overlapBuildingIds) {
            NSNumber *isFont = self.foreRearDic[buildingId];
            otherFont = isFont ? [isFont boolValue] : NO;
            if (otherFont) {
              break;
            }
          }
          if (otherFont) {
            [rearLevelIds addObject:theFloor.floorId];
          } else {
            self.foreRearDic[buildingItem.identifier] = @(YES);
            [foreLevelIds addObject:theFloor.floorId];
          }
        }
        
      }
      
    } else {
      // 未选中venue的建筑
      // 无历史时要可以让其造历史
      MXMFloor *theFloor = [self electDefaultFloorWithVenueHistory:self.venueSelectFloorOrdinalDic
                                                        inBuilding:buildingItem
                                                     ignoreHistory:NO];
      if (theFloor) {
        self.venueSelectFloorOrdinalDic[buildingItem.venueId] = theFloor.ordinal;
        // 如果需要覆盖，不再添加未选中venue的floor
        if (!self.maskNonSelectedSite) {
          NSNumber *isFont = self.foreRearDic[buildingItem.identifier];
          BOOL selfFont = isFont ? [isFont boolValue] : NO;
          if (selfFont) {
            [foreLevelIds addObject:theFloor.floorId];
          } else {
            BOOL otherFont = NO;
            for (NSString *buildingId in buildingItem.overlapBuildingIds) {
              NSNumber *isFont = self.foreRearDic[buildingId];
              otherFont = isFont ? [isFont boolValue] : NO;
              if (otherFont) {
                break;
              }
            }
            if (otherFont) {
              [rearLevelIds addObject:theFloor.floorId];
            } else {
              self.foreRearDic[buildingItem.identifier] = @(YES);
              [foreLevelIds addObject:theFloor.floorId];
            }
          }
        }
      }
    }
  }
  return @{@"rear": [rearLevelIds copy], @"fore": [foreLevelIds copy]};
}

- (NSDictionary *)asyncModelToGetShowFloorIdsWithFloor:(nullable MXMFloor *)floor
                                              building:(nullable MXMGeoBuilding *)building {
  // 选中的建筑必设为前景
  // TODO: 如果building是网络获取的信息，没有overlapBuildingIds，会发生什么
  if (building.identifier) {
    self.foreRearDic[building.identifier] = @(YES);
    for (NSString *otherBuilding in building.overlapBuildingIds) {
      self.foreRearDic[otherBuilding] = @(NO);
    }
  }
  
  NSMutableSet *foreLevelIds = [NSMutableSet set];
  NSMutableSet *rearLevelIds = [NSMutableSet set];

  // 已选中的floor必定加入levelIds中，不放在循环中是为了加快已选中floor的显示，因为这样即使选中building不在可视范围内，依然会加入到显示队列中
  // 已选中的建筑
  if (floor.floorId) {
    [foreLevelIds addObject:floor.floorId];
  }
  
  // 如果需要覆盖，不再添加未选中building的floor
  if (self.maskNonSelectedSite) {
    return @{@"rear": [rearLevelIds copy], @"fore": [foreLevelIds copy]};
  }
  
  // 未选中的建筑
  for (MXMGeoBuilding *buildingItem in self.visibleBuildings.allValues) {
    if ([buildingItem.identifier isEqualToString:building.identifier]) {
      continue;
    }
    MXMFloor *theFloor = [self electDefaultFloorWithBuildingHistory:self.buildingSelectFloorIdDic
                                                         inBuilding:buildingItem];
    if (theFloor) {
      self.buildingSelectFloorIdDic[buildingItem.identifier] = theFloor.floorId;
      
      NSNumber *isFont = self.foreRearDic[buildingItem.identifier];
      BOOL selfFont = isFont ? [isFont boolValue] : NO;
      if (selfFont) {
        [foreLevelIds addObject:theFloor.floorId];
      } else {
        BOOL otherFont = NO;
        for (NSString *buildingId in buildingItem.overlapBuildingIds) {
          NSNumber *isFont = self.foreRearDic[buildingId];
          otherFont = isFont ? [isFont boolValue] : NO;
          if (otherFont) {
            break;
          }
        }
        if (otherFont) {
          [rearLevelIds addObject:theFloor.floorId];
        } else {
          self.foreRearDic[buildingItem.identifier] = @(YES);
          [foreLevelIds addObject:theFloor.floorId];
        }
      }
    }
    
  }
  return @{@"rear": [rearLevelIds copy], @"fore": [foreLevelIds copy]};
}
// 筛选其他无选中建筑


#pragma mark - net转geo
- (nullable MXMGeoBuilding *)exchangeGeoBuildingFrom:(nullable MXMBuilding *)netBuilding
{
  if (netBuilding == nil) { return nil; }
  MXMGeoBuilding *geoBuilding = [[MXMGeoBuilding alloc] init];
  geoBuilding.identifier = netBuilding.buildingId;
  geoBuilding.venueId = netBuilding.venueId;
  geoBuilding.category = netBuilding.type;
  geoBuilding.name = netBuilding.name_default;
  geoBuilding.name_cn = netBuilding.name_cn;
  geoBuilding.name_en = netBuilding.name_en;
  geoBuilding.name_zh = netBuilding.name_zh;
  geoBuilding.name_ja = netBuilding.name_ja;
  geoBuilding.name_ko = netBuilding.name_ko;
  geoBuilding.floors = [netBuilding.floors valueForKey:@"floor"];
  geoBuilding.groundFloor = netBuilding.groundFloor;
  geoBuilding.defaultDisplayedFloorId = netBuilding.defaultDisplayedFloorId;
  geoBuilding.bbox = netBuilding.bbox;
  return geoBuilding;
}

- (nullable MXMGeoVenue *)exchangeGeoVenueFrom:(nullable MXMVenue *)netVenue {
  if (netVenue == nil) { return nil; }
  MXMGeoVenue *geoVenue = [[MXMGeoVenue alloc] init];
  geoVenue.identifier = netVenue.venueId;
  geoVenue.category = netVenue.type;
  geoVenue.name = netVenue.name_default;
  geoVenue.name_cn = netVenue.name_cn;
  geoVenue.name_en = netVenue.name_en;
  geoVenue.name_ja = netVenue.name_ja;
  geoVenue.name_ko = netVenue.name_ko;
  geoVenue.name_zh = netVenue.name_zh;
  geoVenue.address = netVenue.address_default;
  geoVenue.address_cn = netVenue.address_cn;
  geoVenue.address_en = netVenue.address_en;
  geoVenue.address_ja = netVenue.address_ja;
  geoVenue.address_ko = netVenue.address_ko;
  geoVenue.address_zh = netVenue.address_zh;
  geoVenue.bbox = netVenue.bbox;
  geoVenue.buildingIds = [netVenue.buildings valueForKey:@"buildingId"];
  geoVenue.defaultDisplayedBuildingId = netVenue.defaultDisplayedBuildingId;
  return geoVenue;
}

- (nullable MXMGeoVenue *)exchangeGeoVenueFromBuilding:(nullable MXMBuilding *)netBuilding {
  if (netBuilding == nil) { return nil; }
  MXMGeoVenue *geoVenue = [[MXMGeoVenue alloc] init];
  geoVenue.identifier = netBuilding.venueId;
  geoVenue.category = netBuilding.type;
  geoVenue.name = netBuilding.venueName_default;
  geoVenue.name_cn = netBuilding.venueName_cn;
  geoVenue.name_en = netBuilding.venueName_en;
  geoVenue.name_ja = netBuilding.venueName_ja;
  geoVenue.name_ko = netBuilding.venueName_ko;
  geoVenue.name_zh = netBuilding.venueName_zh;
  geoVenue.address = netBuilding.address_default;
  geoVenue.address_cn = netBuilding.address_cn;
  geoVenue.address_en = netBuilding.address_en;
  geoVenue.address_ja = netBuilding.address_ja;
  geoVenue.address_ko = netBuilding.address_ko;
  geoVenue.address_zh = netBuilding.address_zh;
  return geoVenue;
}

#pragma mark - access

- (NSMutableDictionary<NSString *,MXMOrdinal *> *)venueSelectFloorOrdinalDic {
  if (!_venueSelectFloorOrdinalDic) {
    _venueSelectFloorOrdinalDic = [NSMutableDictionary dictionary];
  }
  return _venueSelectFloorOrdinalDic;
}

- (NSMutableDictionary<NSString *,NSString *> *)buildingSelectFloorIdDic {
  if (!_buildingSelectFloorIdDic) {
    _buildingSelectFloorIdDic = [NSMutableDictionary dictionary];
  }
  return _buildingSelectFloorIdDic;
}

- (NSMutableDictionary<NSString *,NSString *> *)venueSelectFloorIdDic {
  if (!_venueSelectFloorIdDic) {
    _venueSelectFloorIdDic = [NSMutableDictionary dictionary];
  }
  return _venueSelectFloorIdDic;
}

- (NSMutableArray<NSString *> *)historicalBuildingIds
{
  if (!_historicalBuildingIds) {
    _historicalBuildingIds = [NSMutableArray array];
  }
  return _historicalBuildingIds;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)foreRearDic {
  if (!_foreRearDic) {
    _foreRearDic = [NSMutableDictionary dictionary];
  }
  return _foreRearDic;
}

- (MXMSearchBuildingOperation *)operation
{
  if (!_operation) {
    _operation = [[MXMSearchBuildingOperation alloc] init];
  }
  return _operation;
}

- (MXMSearchVenueOperation *)venueOperation {
  if (!_venueOperation) {
    _venueOperation = [[MXMSearchVenueOperation alloc] init];
  }
  return _venueOperation;
}

- (MXMSearchFloorOperation *)floorOperation {
  if (!_floorOperation) {
    _floorOperation = [[MXMSearchFloorOperation alloc] init];
  }
  return _floorOperation;
}
@end
