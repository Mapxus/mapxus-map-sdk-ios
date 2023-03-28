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
                       floor:info.floor.code
                     ordinal:info.floor.ordinal
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:NO
             withGeoBuilding:info.building];
  } else {
    [self specifyTheBuilding:self.currentBuilding.identifier
                       floor:nil
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
  BOOL isClickOnCurrentBuilding = [self hasBelongsCurrentBuilding:self.currentBuilding.identifier onFloorsList:floors];
  // 不是点击在已选中的level上面时
  if (!isClickOnCurrentBuilding) {
    MXMIndoorMapInfo *info = [self electIndoorSceneWithCurrentVenue:self.currentBuilding.venueId
                                                        inBuildings:buildings
                                                      floorFeatures:floors];
    if (info == nil) { return; }
    [self specifyTheBuilding:info.building.identifier
                       floor:info.floor.code
                     ordinal:info.floor.ordinal
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:YES
             withGeoBuilding:info.building];
  }
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
                         floor:floorName
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
                     floor:(nullable NSString *)floor
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
      [self displayWihtGeoBuilding:nil orNetBuilding:nil setFloor:nil setOrdinal:nil shouldChangeTrackingMode:changeTrackingMode];
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
        [weakSelf displayWihtGeoBuilding:building orNetBuilding:netBuilding setFloor:floor setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
      }
    };
    [self.operation searchWithBuildingId:buildingId];
  } else { // 不用zoom也不用网络查询的情况
    // 显示建筑
    [self displayWihtGeoBuilding:building orNetBuilding:nil setFloor:floor setOrdinal:ordinal shouldChangeTrackingMode:changeTrackingMode];
  }
}

#pragma mark - private

// 取出有效的值building与ordinal，如果取不了，置为building与ordinal应该都为nil
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)geo
                 orNetBuilding:(nullable MXMBuilding *)net
                      setFloor:(nullable NSString *)setFloor
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
    if (setFloor && !setOrdinal) {
      for (MXMFloor *iFloor in geoBuilding.floors) {
        if ([iFloor.code isEqualToString:setFloor]) {
          floorOrdinal = iFloor.ordinal;
          break;
        }
      }
    }
    // 如果没有设置，通过历史找或者最接近地面的层
    theEndFloorOrdinal = floorOrdinal ? : [self electDefaultFloorWithHistory:self.venueSelectFloorDic inBuilding:geoBuilding];
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
  NSString *floorName;
  if (floorOrdinal) {
    NSArray *floors = building.floors;
    for (MXMFloor *floor in floors) {
      if (floor.ordinal.level == floorOrdinal.level) {
        floorName = floor.code;
        break;
      }
    }
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:onBuilding:floor:)]) {
    BOOL show = building ? YES : NO;
    [self.delegate decideMapViewShowFloorBar:show onBuilding:building.identifier floor:floorName];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:floor:shouldChangeTrackingMode:)]) {
    [self.delegate decideMapViewShouldChangeBuilding:building
                                               floor:floorName
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
    }
  }
  
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeBuilding:floorOrdinal:trackingMode:shouldCallBack:)]) {
    [self.delegate decideMapViewChangeBuilding:building
                                  floorOrdinal:floorOrdinal
                                  trackingMode:changeTrackingMode
                                shouldCallBack:hasChangedBuildingOrOrdinal];
  }
}

- (BOOL)hasBelongsCurrentBuilding:(nullable NSString *)curBuildingId onFloorsList:(NSArray<MXMLevelModel *> *)floors
{
  if (curBuildingId == nil) { return NO; }
  for (MXMLevelModel *feature in floors) {
    if ([feature.refBuildingId isEqualToString:curBuildingId]) {
      return YES;
    }
  }
  return NO;
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

- (nullable MXMIndoorMapInfo *)electIndoorSceneWithCurrentVenue:(nullable NSString *)venueId
                                                    inBuildings:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                                  floorFeatures:(NSArray<MXMLevelModel *> *)floors
{
//  // 查找该点上的其他建筑信息
  NSArray *buildingList = [buildings allValues];
//
  // 分成两列，一列是与已选中建筑同venue，一列不同venue
  NSMutableArray *sameVenueBuidlingList = [NSMutableArray array];
  NSMutableArray *notSameVenueBuidlingList = [NSMutableArray array];
  for (MXMGeoBuilding *building in buildingList) {
    if (venueId && [building.venueId isEqualToString:venueId]) {
      for (MXMLevelModel *level in floors) {
        if ([level.refBuildingId isEqualToString:building.identifier]) {
          [sameVenueBuidlingList addObject:building];
          break;
        }
      }
    } else {
      [notSameVenueBuidlingList addObject:building];
    }
  }
  
  MXMGeoBuilding *selectedBuilding;
  MXMFloor *selectedFloor;
  
  // 在同venue建筑里找
  for (MXMGeoBuilding *building in sameVenueBuidlingList) {
    selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:self.currentFloorOrdinal];
    if (selectedFloor) {
      selectedBuilding = building;
      break;
    }
  }

  // 在已选中venue中但没有相同ordinal的楼层，无动作
  if (sameVenueBuidlingList.count > 0 && selectedBuilding == nil) {
    return nil;
  }

  if (selectedBuilding == nil) {
    for (MXMGeoBuilding *building in notSameVenueBuidlingList) {
      MXMOrdinal *historyOrdinal = self.venueSelectFloorDic[building.venueId];
      selectedFloor = [self buildingFloors:building.floors whichHasSameOrdinal:historyOrdinal];
      if (selectedFloor) {
        selectedBuilding = building;
        break;
      }
    }
  }

  if (selectedBuilding == nil) {
    selectedBuilding = notSameVenueBuidlingList.firstObject;
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
