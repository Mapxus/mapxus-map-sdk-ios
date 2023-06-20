//
//  MXMDecider.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMDecider.h"
#import "MXMSearchBuildingOperation2.h"
#import "MXMCommonObj.h"
#import <YYModel/YYModel.h>
#import "NSString+Compare.h"
#import "JXJsonFunctionDefine.h"



@interface MXMDecider ()

@property (nonatomic, copy, readwrite, nullable) MXMOrdinal *currentFloorOrdinal;
@property (nonatomic, strong, readwrite, nullable) MXMGeoBuilding *currentBuilding;
@property (nonatomic, strong) MXMSearchBuildingOperation2 *operation;

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
- (void)decideInRectBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
  // 默认选中building，规则为优先选中之前选过的
  MXMIndoorMapInfo *info = [self electIndoorSceneRecentlyWithHistory:self.historicalBuildingIds
                                                         inBuildings:buildings];
  if (info) {
    [self specifyTheBuilding:info.building.identifier
                   floorCode:info.floor.code
                     ordinal:info.floor.ordinal
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:NO
             withGeoBuilding:info.building];
  } else {
    [self specifyTheBuilding:self.currentBuilding.identifier
                   floorCode:nil
                     ordinal:self.currentFloorOrdinal
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:NO
             withGeoBuilding:self.currentBuilding];
  }
}


- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  MXMIndoorMapInfo *info = [self electIndoorSceneWithCurrentBuilding:self.currentBuilding
                                                         inBuildings:buildings
                                                       floorFeatures:floors];
  if (info == nil) { return; }
  [self specifyTheBuilding:info.building.identifier
                 floorCode:info.floor.code
                   ordinal:info.floor.ordinal
                  zoomMode:MXMZoomDisable
               edgePadding:UIEdgeInsetsZero
  shouldChangeTrackingMode:YES
           withGeoBuilding:info.building];
}

- (nullable MXMIndoorMapInfo *)decideWithUserLocationLevel:(NSInteger)level
                                        atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                      atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList
{
  for (MXMLevelModel *model in levelInfoList) {
    if ([model.ordinal isEqualToNumber:@(level)]) {
      NSString *buildingId = model.refBuildingId;
      NSString *floorName = model.name;
      
      MXMGeoBuilding *building = [buildings objectForKey:buildingId];
      
      MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
      ordinal.level = level;
      
      MXMFloor *floor = [[MXMFloor alloc] init];
      floor.floorId = model.levelId;
      floor.code = model.name;
      floor.ordinal = ordinal;
      
      [self specifyTheBuilding:buildingId
                     floorCode:floorName
                       ordinal:ordinal
                      zoomMode:MXMZoomDisable
                   edgePadding:UIEdgeInsetsZero
      shouldChangeTrackingMode:NO
               withGeoBuilding:building];
      return [[MXMIndoorMapInfo alloc] initWithBuilding:building floor:floor];
    }
  }
  return nil;
}


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

// 取出有效的值building与ordinal，如果取不了，置为building与ordinal应该都为nil
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)geo
                 orNetBuilding:(nullable MXMBuilding *)net
                  setFloorCode:(nullable NSString *)setFloorCode
                    setOrdinal:(nullable MXMOrdinal *)setOrdinal
      shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
  MXMGeoBuilding *geoBuilding;
  MXMOrdinal *theEndFloorOrdinal;
  
  geoBuilding = geo ? : [self exchangeFrom:net];
  
  if (geoBuilding) {
    MXMOrdinal *floorOrdinal;
    // 判断是否包含ordinal
    if (setOrdinal) {
      for (MXMFloor *iFloor in geoBuilding.floors) {
        if (iFloor.ordinal && iFloor.ordinal.level == setOrdinal.level) {
          floorOrdinal = iFloor.ordinal;
          break;
        }
      }
    }
    // 通过name找ordinal
    if (setFloorCode && !setOrdinal) {
      for (MXMFloor *iFloor in geoBuilding.floors) {
        if ([iFloor.code isEqualToString:setFloorCode]) {
          floorOrdinal = iFloor.ordinal;
          break;
        }
      }
    }
    // 如果没有设置，通过历史找或者最接近地面的层
    if (self.floorSwitchMode == MXMSwitchingByVenue) {
      theEndFloorOrdinal = floorOrdinal ? : [self electDefaultFloorWithHistory:self.venueSelectFloorDic
                                                                    inBuilding:geoBuilding];
    } else {
      NSString *defaultFloorId = [self electDefaultFloorIdWithHistory:self.buildingSelectFloorIdDic
                                                           inBuilding:geoBuilding];
      MXMOrdinal *defaultOrdinal;
      for (MXMFloor *iFloor in geoBuilding.floors) {
        if ([defaultFloorId isEqualToString:iFloor.floorId]) {
          defaultOrdinal = iFloor.ordinal;
          break;
        }
      }
      theEndFloorOrdinal = floorOrdinal ? : defaultOrdinal;
    }
    // 如果找不到有效楼层，建筑也设置为空
    if (theEndFloorOrdinal == nil) {
      geoBuilding = nil;
    }
  }
  
  [self selectBuilding:geoBuilding floorOrdinal:theEndFloorOrdinal shouldChangeTrackingMode:changeTrackingMode];
}

// 拿到有效唯一值信息，且保证building与floorOrdinal同时为nil或不同时为nil，如果为nil，则清除选中
- (void)selectBuilding:(nullable MXMGeoBuilding *)building
    floorOrdinal:(nullable MXMOrdinal *)floorOrdinal
    shouldChangeTrackingMode:(BOOL)changeTrackingMode {
  
  // 转换成building上的code
  MXMFloor *theFloor;
  if (floorOrdinal) {
    NSArray *floors = building.floors;
    for (MXMFloor *floor in floors) {
      if (floor.ordinal.level == floorOrdinal.level) {
        theFloor = floor;
        break;
      }
    }
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:inBuilding:floor:)]) {
    BOOL show = building ? YES : NO;
    [self.delegate decideMapViewShowFloorBar:show inBuilding:building floor:theFloor];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:floor:shouldChangeTrackingMode:)]) {
    [self.delegate decideMapViewShouldChangeBuilding:building
                                               floor:theFloor
                            shouldChangeTrackingMode:changeTrackingMode];
  }
  
  BOOL hasChangedBuildingOrOrdinal = [self hasChangedWithBuilding:building
                                                     floorOrdinal:floorOrdinal
                                                  currentBuilding:self.currentBuilding
                                              currentFloorOrdinal:self.currentFloorOrdinal
                                                     andMapReload:self.isMapReload];
  
  if (hasChangedBuildingOrOrdinal) {
    self.currentBuilding = building;
    self.currentFloorOrdinal = floorOrdinal;
    if (building) {
      // 保存id到选中队列，并取100条数据
      [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
      if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
      }
      
      // 保持建筑的选择楼层，下次作为默认选中楼层
      [self.venueSelectFloorDic setObject:floorOrdinal forKey:building.venueId];
      [self.buildingSelectFloorIdDic setObject:theFloor.floorId forKey:building.identifier];
    }
  }
  
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeBuilding:floor:trackingMode:shouldCallBack:)]) {
    [self.delegate decideMapViewChangeBuilding:building
                                         floor:theFloor
                                  trackingMode:changeTrackingMode
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

// 选举默认选中建筑，参考历史最近选中
- (nullable MXMIndoorMapInfo *)electIndoorSceneRecentlyWithHistory:(NSArray<NSString *> *)historyList
                                                       inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
  MXMGeoBuilding *selectedBuilding;
  MXMFloor *selectedFloor;
  
  for (NSString *buildingId in self.historicalBuildingIds) {
    MXMGeoBuilding *building = buildings[buildingId];
    if (building) {
      if (self.floorSwitchMode == MXMSwitchingByVenue) {
        if ([building.venueId isEqualToString:self.currentBuilding.venueId]) {
          selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:self.currentFloorOrdinal];
          if (selectedFloor) {
            selectedBuilding = building;
            break;
          }
        } else {
          MXMOrdinal *historyOrdinal = self.venueSelectFloorDic[building.venueId];
          selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:historyOrdinal];
          if (selectedFloor) {
            selectedBuilding = building;
            break;
          }
        }
      } else {
        selectedBuilding = building;
        NSString *floorId = self.buildingSelectFloorIdDic[building.identifier];
        for (MXMFloor *iFloor in building.floors) {
          if ([floorId isEqualToString:iFloor.floorId]) {
            selectedFloor = iFloor;
            break;
          }
        }
        break;
      }
    }
  }
  
  if (selectedBuilding == nil) {
    selectedBuilding = [buildings allValues].firstObject;
    if (selectedBuilding.floors) {
      selectedFloor = [self absMin:selectedBuilding.floors];
    }
  }
  
  MXMIndoorMapInfo *info;
  if (selectedBuilding && selectedFloor) {
    info = [[MXMIndoorMapInfo alloc] initWithBuilding:selectedBuilding floor:selectedFloor];
  }
  return info;
}

- (nullable MXMIndoorMapInfo *)electIndoorSceneWithCurrentBuilding:(nullable MXMGeoBuilding *)building
                                                       inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                                     floorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  if (floors.count <= 0) {
    return nil;
  } else {
    // 查找该点上的其他建筑信息
    MXMGeoBuilding *selectedBuilding;
    MXMFloor *selectedFloor;
    
    if (building == nil) {
      // 当前没有选中建筑
      MXMLevelModel *theFloor = floors.firstObject;
      MXMGeoBuilding *refBuilding = buildings[theFloor.refBuildingId];
      selectedBuilding = refBuilding;
      for (MXMFloor *floor in refBuilding.floors) {
        if ([floor.floorId isEqualToString:theFloor.levelId]) {
          selectedFloor = floor;
          break;
        }
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
          selectedBuilding = refBuilding;
          for (MXMFloor *floor in refBuilding.floors) {
            if ([floor.floorId isEqualToString:theFloor.levelId]) {
              selectedFloor = floor;
              break;
            }
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
          selectedBuilding = refBuilding;
          for (MXMFloor *floor in refBuilding.floors) {
            if ([floor.floorId isEqualToString:theFloor.levelId]) {
              selectedFloor = floor;
              break;
            }
          }
        }
          break;
      }
    }
    
    MXMIndoorMapInfo *info;
    if (selectedBuilding && selectedFloor) {
      info = [[MXMIndoorMapInfo alloc] initWithBuilding:selectedBuilding floor:selectedFloor];
    }
    return info;
  }
}


// 选举默认选中楼层，参考历史最近选中
- (nullable MXMOrdinal *)electDefaultFloorWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building
{
  MXMOrdinal *defaultElectFloorOrdinal = historyDic[building.venueId];
  if (defaultElectFloorOrdinal == nil) {
    NSMutableArray *floors = [NSMutableArray array];
    // 去除没有ordinal的楼层
    for (MXMFloor *floor in building.floors) {
      if (floor.ordinal) {
        [floors addObject:floor];
      }
    }
    MXMFloor *minFloor = [self absMin:floors];
    defaultElectFloorOrdinal = minFloor.ordinal;
  }
  return defaultElectFloorOrdinal;
}

- (nullable NSString *)electDefaultFloorIdWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building
{
  NSString *defaultElectFloorId = historyDic[building.identifier];
  if (defaultElectFloorId == nil) {
    NSMutableArray *floors = [NSMutableArray array];
    // 去除没有ordinal的楼层
    for (MXMFloor *floor in building.floors) {
      if (floor.ordinal) {
        [floors addObject:floor];
      }
    }
    MXMFloor *minFloor = [self absMin:floors];
    defaultElectFloorId = minFloor.floorId;
  }
  return defaultElectFloorId;
}

// nil表明传入了空的floors数组
- (nullable MXMFloor *)absMin:(NSArray<MXMFloor *> *)floors
{
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

- (float)decideLocationViewAlphaWithCurrentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andLocalFloor:(nullable CLFloor *)floor
{
  if (floor) {
    MXMFloor *m = nil;
    for (MXMFloor *f in curBuilding.floors) {
      if ([f.code isEqualToString:curFloor]) {
        m = f;
        break;
      }
    }
    if (m && m.ordinal && m.ordinal.level == floor.level) {
      return 1.0f;
    } else {
      return 0.5f;
    }
  } else {
    return 1.0f;
  }
}


#pragma mark - access

- (NSMutableDictionary *)venueSelectFloorDic
{
  if (!_venueSelectFloorDic) {
    _venueSelectFloorDic = [NSMutableDictionary dictionary];
  }
  return _venueSelectFloorDic;
}

- (NSMutableDictionary *)buildingSelectFloorIdDic {
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

- (MXMSearchBuildingOperation2 *)operation
{
  if (!_operation) {
    _operation = [[MXMSearchBuildingOperation2 alloc] init];
  }
  return _operation;
}

@end
