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

@property (nonatomic, copy, readwrite) MXMOrdinal *currentFloorOrdinal;
@property (nonatomic, strong, readwrite) MXMGeoBuilding *currentBuilding;
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


// 自动选择默认选中建筑
- (void)decideInRectBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                       venueDic:(NSDictionary<NSString *, MXMGeoVenue *> *)venues

{
  // 默认选中building，规则为优先选中之前选过的
  MXMGeoBuilding *defaultBuilding = [self electDefaultBuildingRecentlyWithHistory:self.historicalBuildingIds
                                                                      inBuildings:[buildings allValues]];
  MXMGeoVenue *venue;
  if (defaultBuilding) {
    venue = venues[defaultBuilding.venueId];
  }
  
  [self specifyTheBuilding:defaultBuilding.identifier
                     floor:nil
                   ordinal:nil
     floorNameFromBuilding:(venue == nil)
                  zoomMode:MXMZoomDisable
               edgePadding:UIEdgeInsetsZero
  shouldChangeTrackingMode:NO
           withGeoBuilding:defaultBuilding
                  geoVenue:venue];
}


- (void)decideAtPointWithBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                            venueDic:(NSDictionary<NSString *, MXMGeoVenue *> *)venues
                    andFloorFeatures:(NSArray<MXMLevelModel *> *)floors
{
  BOOL isClickOnCurrentBuilding = [self hasBelongsCurrentBuilding:self.currentBuilding.identifier onFloorsList:floors];
  /// 不是点击在已选中的level上面时
  if (!isClickOnCurrentBuilding) {
    /// 查找该点上的其他建筑信息
    NSMutableDictionary *muBuildings = [NSMutableDictionary dictionaryWithDictionary:buildings];
    if (self.currentBuilding.identifier) {
      [muBuildings removeObjectForKey:self.currentBuilding.identifier];
    }
    NSArray *buildingList = [muBuildings allValues];
    MXMGeoBuilding *geoBuilding = buildingList.firstObject;
    MXMGeoVenue *venue;
    if (geoBuilding) {
      venue = venues[geoBuilding.venueId];
      [self specifyTheBuilding:geoBuilding.identifier
                         floor:nil
                       ordinal:nil
         floorNameFromBuilding:(venue == nil)
                      zoomMode:MXMZoomDisable
                   edgePadding:UIEdgeInsetsZero
      shouldChangeTrackingMode:YES
               withGeoBuilding:geoBuilding
                      geoVenue:venue];
    }
  }
}

- (BOOL)hasBelongsCurrentBuilding:(NSString *)curBuildingId onFloorsList:(NSArray<MXMLevelModel *> *)floors
{
  for (MXMLevelModel *feature in floors) {
    if ([feature.refBuildingId isEqualToString:curBuildingId]) {
      return YES;
    }
  }
  return NO;
}

- (nullable MXMIndoorMapInfo *)decideWithUserLocationLevel:(NSInteger)level
                                        atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
                                                  venueDic:(NSDictionary<NSString *, MXMGeoVenue *> *)venues
                                      atPointLevelInfoList:(NSArray<MXMLevelModel *> *)levelInfoList
{
  for (MXMLevelModel *model in levelInfoList) {
    if ([model.ordinal isEqualToNumber:@(level)]) {
      NSString *buildingId = model.refBuildingId;
      NSString *floorName = model.name;
      MXMGeoBuilding *building = [buildings objectForKey:buildingId];
      MXMGeoVenue *venue;
      if (building) {
        venue = venues[building.venueId];
      }
      MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
      ordinal.level = level;
      [self specifyTheBuilding:buildingId
                         floor:floorName
                       ordinal:ordinal
         floorNameFromBuilding:YES // 只能是YES,因为floorName是从level layer上获取的
                      zoomMode:MXMZoomDisable
                   edgePadding:UIEdgeInsetsZero
      shouldChangeTrackingMode:NO
               withGeoBuilding:building
                      geoVenue:venue];
      return [[MXMIndoorMapInfo alloc] initWithBuilding:building floor:floorName];
    }
  }
  return nil;
}


- (void)specifyTheBuilding:(NSString *)buildingId
                     floor:(nullable NSString *)floor
                   ordinal:(nullable MXMOrdinal *)ordinal
     floorNameFromBuilding:(BOOL)isBuilding
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
           withGeoBuilding:(nullable MXMGeoBuilding *)building
                  geoVenue:(nullable MXMGeoVenue *)venue
{
  // 建筑ID没有指定则直接跳过
  if (buildingId == nil) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:onBuilding:floor:)]) {
      [self.delegate decideMapViewShowFloorBar:NO onBuilding:nil floor:nil];
    }
    return;
  }
  // 从地图瓦片获取建筑数据
  BOOL state = [self shouldBeQueryWithBuilding:building shouldZoomTo:(zoomMode != MXMZoomDisable)];
  if (state) {
    __weak typeof(self) weakSelf = self;
    self.operation.complateBlock = ^(MXMBuilding * _Nullable netBuilding) {
      // 调用zoom map
      if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
        [weakSelf.delegate decideMapViewZoomTo:netBuilding.bbox zoomMode:zoomMode withEdgePadding:insets];
      }
      // 显示建筑
      [weakSelf displayWihtGeoBuilding:building orNetBuilding:netBuilding venue:venue setFloor:floor setOrdinal:ordinal floorNameFromBuilding:isBuilding shouldChangeTrackingMode:changeTrackingMode];
    };
    [self.operation searchWithBuildingId:buildingId];
  } else { // 不用zoom也不用网络查询的情况
    // 显示建筑
    [self displayWihtGeoBuilding:building orNetBuilding:nil venue:venue setFloor:floor setOrdinal:ordinal floorNameFromBuilding:isBuilding shouldChangeTrackingMode:changeTrackingMode];
  }
}

// 选择正确的建筑与楼层
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)geo
                 orNetBuilding:(nullable MXMBuilding *)net
                         venue:(nullable MXMGeoVenue *)venue
                      setFloor:(nullable NSString *)setFloor
                    setOrdinal:(nullable MXMOrdinal *)setOrdinal
         floorNameFromBuilding:(BOOL)isBuilding
      shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 显示建筑
  MXMGeoBuilding *geoBuilding = geo ? : [self exchangeFrom:net];
  
  MXMOrdinal *floorOrdinal = setOrdinal;
  if (setFloor && !setOrdinal) {
    if (isBuilding) {
      for (MXMFloor *iFloor in geoBuilding.floors) {
        if ([iFloor.code isEqualToString:setFloor]) {
          floorOrdinal = iFloor.ordinal;
          break;
        }
      }
    } else {
      for (MXMFloor *iFloor in venue.floors) {
        if ([iFloor.code isEqualToString:setFloor]) {
          floorOrdinal = iFloor.ordinal;
          break;
        }
      }
    }
  }
  
  MXMOrdinal *theEndFloorOrdinal = floorOrdinal ? : [self electDefaultFloorWithHistory:self.venueSelectFloorDic inBuilding:geoBuilding];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:onBuilding:floor:)]) {
    // 转换成building上的code
    MXMFloor *setFloor;
    if (theEndFloorOrdinal) {
      NSArray *floors = geoBuilding.floors;
      for (MXMFloor *floor in floors) {
        if (floor.ordinal && floor.ordinal.level == theEndFloorOrdinal.level) {
          setFloor = floor;
          break;
        }
      }
    }
    BOOL show = geo ? YES : NO;
    [self.delegate decideMapViewShowFloorBar:show onBuilding:geoBuilding.identifier floor:setFloor.code];
  }
  
  [self selectBuilding:geoBuilding venue:venue floorOrdinal:theEndFloorOrdinal shouldChangeTrackingMode:changeTrackingMode];
}

- (BOOL)shouldBeQueryWithBuilding:(nullable MXMGeoBuilding *)building shouldZoomTo:(BOOL)zoomTo
{
  if (building && !zoomTo) {
    return NO;
  } else {
    return YES;
  }
}

- (MXMGeoBuilding *)exchangeFrom:(MXMBuilding *)netBuilding
{
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



#pragma mark - private


// 选举默认选中建筑，参考历史最近选中
- (nullable MXMGeoBuilding *)electDefaultBuildingRecentlyWithHistory:(NSArray<NSString *> *)historyList inBuildings:(NSArray<MXMGeoBuilding *> *)buildings
{
  // 取出默认第一个
  MXMGeoBuilding *result = buildings.firstObject;
  // 与历史ID匹对
  for (NSString *buildingId in historyList) {
    for (MXMGeoBuilding *building in buildings) {
      if ([building.identifier isEqualToString:buildingId]) {
        result = building;
        // 用break只退出一层循环，所以用return
        return result;
      }
    }
  }
  return result;
}


// 选举默认选中楼层，参考历史最近选中
- (nullable MXMOrdinal *)electDefaultFloorWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building
{
  NSAssert(building != nil, @"To query the history, you must pass in building");
  
  MXMOrdinal *defaultElectFloorOrdinal = historyDic[building.venueId];
  if (defaultElectFloorOrdinal == nil) {
    for (MXMFloor *iFloor in building.floors) {
      if (iFloor.ordinal && iFloor.ordinal.level == 0) {
        defaultElectFloorOrdinal = iFloor.ordinal;
        break;
      }
    }
  }
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

// 主要作用是过滤空输入及保存历史
- (void)selectBuilding:(MXMGeoBuilding *)building
                 venue:(nullable MXMGeoVenue *)venue
          floorOrdinal:(MXMOrdinal *)floorOrdinal
shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  // 无论是否
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:floor:shouldChangeTrackingMode:)]) {
    // 转换成building上的code
    MXMFloor *setFloor;
    if (floorOrdinal) {
      NSArray *floors = building.floors;
      for (MXMFloor *floor in floors) {
        if (floor.ordinal && floor.ordinal.level == floorOrdinal.level) {
          setFloor = floor;
          break;
        }
      }
    }
    [self.delegate decideMapViewShouldChangeBuilding:building floor:setFloor.code shouldChangeTrackingMode:changeTrackingMode];
  }
  
  BOOL shouldCallBack = NO;
  if ([self canGoOnFilterWithBuilding:building venue:venue floorOrdinal:floorOrdinal currentBuilding:self.currentBuilding currentFloorOrdinal:self.currentFloorOrdinal andMapReload:self.isMapReload]) {
    shouldCallBack = YES;
    self.currentBuilding = building;
    self.currentFloorOrdinal = floorOrdinal;
    // 保存id到选中队列，并取100条数据
    [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
    if (self.historicalBuildingIds.count>100) {
      [self.historicalBuildingIds removeLastObject];
    }
    // 保存id到选中队列，并取100条数据
    [self.historicalVenueIds insertObject:building.venueId atIndex:0];
    if (self.historicalVenueIds.count>100) {
      [self.historicalVenueIds removeLastObject];
    }
    
    // 保持建筑的选择楼层，下次作为默认选中楼层
    if (floorOrdinal) {
      [self.venueSelectFloorDic setObject:floorOrdinal forKey:building.venueId];
    }
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeBuilding:venue:floorOrdinal:trackingMode:shouldCallBack:)]) {
    [self.delegate decideMapViewChangeBuilding:building venue:venue floorOrdinal:floorOrdinal trackingMode:changeTrackingMode shouldCallBack:shouldCallBack];
  }
}


- (BOOL)canGoOnFilterWithBuilding:(MXMGeoBuilding *)building
                            venue:(nullable MXMGeoVenue *)venue
                     floorOrdinal:(MXMOrdinal *)floorOrdinal
                  currentBuilding:(MXMGeoBuilding *)curBuilding
              currentFloorOrdinal:(MXMOrdinal *)curFloorOrdinal
                     andMapReload:(BOOL)isMapReload
{
  if (building == nil || floorOrdinal == nil) {
    return NO;
  }
  // 判断楼层名是否正确
  BOOL contains = NO;
  NSArray *floors = venue.floors;
  if (!floors.count) {
    floors = building.floors;
  }
  for (MXMFloor *f in floors) {
    if (f.ordinal && f.ordinal.level == floorOrdinal.level) {
      contains = YES;
      break;
    }
  }
  if (!contains) {
    return NO;
  }
  // 已选中则不进行后续操作，提高应用性能
  if ([curBuilding.identifier isEqualToString:building.identifier] &&
      curFloorOrdinal &&
      floorOrdinal &&
      curFloorOrdinal.level == floorOrdinal.level &&
      !isMapReload) {
    return NO;
  }
  return YES;
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

- (NSMutableArray<NSString *> *)historicalVenueIds {
  if (!_historicalVenueIds) {
    _historicalVenueIds = [NSMutableArray array];
  }
  return _historicalVenueIds;
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
