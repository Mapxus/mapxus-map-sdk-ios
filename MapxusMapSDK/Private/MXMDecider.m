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
#import "MXMCommonObj.h"
#import <YYModel/YYModel.h>
#import "NSString+Compare.h"
#import "JXJsonFunctionDefine.h"



@interface MXMDecider ()

@property (nonatomic, strong) MXMSearchBuildingOperation *operation;
@property (nonatomic, strong) MXMSearchVenueOperation *venueOperation;

@end




@implementation MXMDecider


#pragma mark - public

- (instancetype)initWithDelegate:(id<MXMDeciderDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

#pragma mark - public 兼控制是否进入私有过滤方法

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
    [self specifyTheFloorId:self.selectedFloor.floorId
                   zoomMode:MXMZoomDisable
                edgePadding:UIEdgeInsetsZero
   shouldChangeTrackingMode:NO];
  }
}


- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  MXMSite *info = [self electIndoorSiteWithCurrentBuilding:self.selectedBuilding
                                               inBuildings:buildings
                                             floorFeatures:floors];
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
      info.building = building;
      info.floor = floor;
      return info;
    }
  }
  return nil;
}

- (void)specifyTheFloorId:(nullable NSString *)floorId
                 zoomMode:(MXMZoomMode)zoomMode
              edgePadding:(UIEdgeInsets)insets
 shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (floorId) {
    MXMLevelModel *level = self.visibleFloors[floorId];
    if (level) {
      MXMFloor *floor = [[MXMFloor alloc] init];
      floor.floorId = level.levelId;
      floor.code = level.name;
      floor.ordinal = level.ordinal;
      MXMGeoBuilding *building = self.visibleBuildings[level.refBuildingId];
      MXMGeoVenue *venue = self.visibleVenues[building.venueId];
      
      if (zoomMode != MXMZoomDisable && self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
        [self.delegate decideMapViewZoomTo:building.bbox zoomMode:zoomMode withEdgePadding:insets];
      }
      [self displayWihtFloor:floor building:building venue:venue shouldChangeTrackingMode:changeTrackingMode];
    } else {
      // TODO: 网络请求building信息
      
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
    if (building) {
      MXMGeoVenue *venue = self.visibleVenues[building.venueId];
      
      if (zoomMode != MXMZoomDisable && self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
        [self.delegate decideMapViewZoomTo:building.bbox zoomMode:zoomMode withEdgePadding:insets];
      }
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
          // TODO: 如何获取venue？
          MXMGeoBuilding *theEndBuilding = [weakSelf exchangeFrom:netBuilding];
          [weakSelf displayWihtFloor:nil building:theEndBuilding venue:nil shouldChangeTrackingMode:changeTrackingMode];
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
    MXMGeoVenue *venue = self.visibleVenues[venueId];
    MXMGeoBuilding *building = self.visibleBuildings[venue.defaultDisplayedBuildingId];
    if (building) {
      if (zoomMode != MXMZoomDisable && self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
        [self.delegate decideMapViewZoomTo:building.bbox zoomMode:zoomMode withEdgePadding:insets];
      }
      [self displayWihtFloor:nil building:building venue:venue shouldChangeTrackingMode:changeTrackingMode];
    } else {
      __weak typeof(self) weakSelf = self;
      self.venueOperation.complateBlock = ^(MXMVenue * _Nullable netVenue) {
        if (netVenue) {
          // TODO: 是否需要查询历史选中?
          MXMBuilding *defaultBuilding;
          for (MXMBuilding *itemBuilding in netVenue.buildings) {
            if ([netVenue.defaultDisplayedBuildingId isEqualToString:itemBuilding.buildingId]) {
              defaultBuilding = itemBuilding;
            }
          }
          if (defaultBuilding == nil) {
            defaultBuilding = netVenue.buildings.firstObject;
          }
          MXMGeoBuilding *theEndBuilding = [weakSelf exchangeFrom:defaultBuilding];
          if (zoomMode != MXMZoomDisable && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
            [weakSelf.delegate decideMapViewZoomTo:theEndBuilding.bbox zoomMode:zoomMode withEdgePadding:insets];
          }
          // 显示建筑
          [weakSelf displayWihtFloor:nil building:theEndBuilding venue:nil shouldChangeTrackingMode:changeTrackingMode];
        }
      };
      [self.venueOperation searchWithVenueId:venueId];
    }
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
      [self displayWihtGeoBuilding:nil orNetBuilding:nil setFloorCode:nil setOrdinal:nil shouldChangeTrackingMode:changeTrackingMode];
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
        [weakSelf displayWihtGeoBuilding:building orNetBuilding:netBuilding setFloorCode:floorCode setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
      }
    };
    [self.operation searchWithBuildingId:buildingId];
  } else { // 不用zoom也不用网络查询的情况
    // 显示建筑
    [self displayWihtGeoBuilding:building orNetBuilding:nil setFloorCode:floorCode setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
  }
}

#pragma mark - private

// TODO: 删除
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)geo
                 orNetBuilding:(nullable MXMBuilding *)net
                  setFloorCode:(nullable NSString *)setFloorCode
                    setOrdinal:(nullable MXMOrdinal *)setOrdinal
      shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
  MXMGeoBuilding *theEndBuilding;
  MXMFloor *theEndFloor;
  
  theEndBuilding = geo ? : [self exchangeFrom:net];
  
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
    }
  }
  
  [self selectFloor:theEndFloor building:theEndBuilding shouldChangeTrackingMode:changeTrackingMode];
}

// 取出有效的值building与ordinal，如果取不了，置为building与ordinal应该都为nil
- (void)displayWihtFloor:(nullable MXMFloor *)floor
                building:(nullable MXMGeoBuilding *)building
                   venue:(nullable MXMGeoVenue *)venue
shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
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
    }
  }
  
  [self selectFloor:theEndFloor building:theEndBuilding shouldChangeTrackingMode:changeTrackingMode];
}


// 拿到有效唯一值信息，且保证building与floorOrdinal同时为nil或不同时为nil，如果为nil，则清除选中
- (void)selectFloor:(nullable MXMFloor *)floor
           building:(nullable MXMGeoBuilding *)building
shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:inBuilding:floor:)]) {
    BOOL show = building ? YES : NO;
    [self.delegate decideMapViewShowFloorBar:show inBuilding:building floor:floor];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:floor:shouldChangeTrackingMode:)]) {
    [self.delegate decideMapViewShouldChangeBuilding:building
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
    self.selectedBuilding = building;
    if (building) {
      // 保存id到选中队列，并取100条数据
      [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
      if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
      }
      
      // 保持建筑的选择楼层，下次作为默认选中楼层
      self.venueSelectFloorOrdinalDic[building.venueId] = floor.ordinal;
      self.buildingSelectFloorIdDic[building.identifier] = floor.floorId;
    }
  }
  
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeBuilding:floor:shouldCallBack:)]) {
    [self.delegate decideMapViewChangeBuilding:building
                                         floor:floor
                                shouldCallBack:hasChangedBuildingOrOrdinal];
  }
}

- (BOOL)shouldBeQueryWithBuilding:(nullable MXMGeoBuilding *)building shouldZoomTo:(BOOL)zoomTo
{
  if (building && !zoomTo) {
    return NO;
  } else {
    return YES;
  }
}

- (nullable MXMGeoBuilding *)exchangeFrom:(nullable MXMBuilding *)netBuilding
{
  if (netBuilding == nil) { return nil; }
  MXMGeoBuilding *geoBuilding = [[MXMGeoBuilding alloc] init];
  geoBuilding.identifier = netBuilding.buildingId;
  geoBuilding.venueId = netBuilding.venueId;
  geoBuilding.building = netBuilding.type;
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

- (NSMutableArray<NSString *> *)historicalBuildingIds
{
  if (!_historicalBuildingIds) {
    _historicalBuildingIds = [NSMutableArray array];
  }
  return _historicalBuildingIds;
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
@end
