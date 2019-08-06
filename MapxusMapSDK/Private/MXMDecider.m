//
//  MXMDecider.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/13.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMDecider.h"
#import "MXMSearchBuildingOperation2.h"
#import "MXMGeoBuilding.h"
#import "MXMCommonObj.h"
#import <YYModel/YYModel.h>
#import "NSString+Compare.h"



@interface MXMDecider ()

@property (nonatomic, copy, readwrite) NSString *currentFloor;
@property (nonatomic, copy, readwrite) MXMGeoBuilding *currentBuilding;
@property (nonatomic, strong) NSMutableDictionary *buildingSelectFloorDic; // 保存运行期间看过大厦最后选中的对应楼层
@property (nonatomic, strong) NSMutableArray<NSString *> *historicalBuildingIds; // 保存运行期间看过的大厦Id，防止同一地点两栋大厦间互相切换
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
{
    // 默认选中building，规则为优先选中之前选过的
    MXMGeoBuilding *defaultBuilding = [self electDefaultBuildingRecentlyWithHistory:self.historicalBuildingIds
                                                                        inBuildings:[buildings allValues]];
    NSString *defaultFloor = [self electDefaultFloorWithHistory:self.buildingSelectFloorDic
                                                     inBuilding:defaultBuilding];

    [self specifyTheBuilding:defaultBuilding.identifier
                       floor:defaultFloor
                    zoomMode:MXMZoomDisable
                 edgePadding:UIEdgeInsetsZero
    shouldChangeTrackingMode:NO
         withRectBuildingDic:buildings];
}


- (void)decideAtPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
    // 防止重叠建筑在点击已选中图层时切换到另一栋
    NSArray *buildingList = [buildings allValues];
    BOOL shouldChange = [self shouldChangeWithList:buildingList currentBuildingId:self.currentBuilding.identifier];
    MXMGeoBuilding *geoBuilding = buildingList.firstObject;
    if (shouldChange && geoBuilding) {
        NSString *defaultFloor = [self electDefaultFloorWithHistory:self.buildingSelectFloorDic inBuilding:geoBuilding];
        [self specifyTheBuilding:geoBuilding.identifier
                           floor:defaultFloor
                        zoomMode:MXMZoomDisable
                     edgePadding:UIEdgeInsetsZero
        shouldChangeTrackingMode:YES
             withRectBuildingDic:buildings];
    }
}


- (BOOL)shouldChangeWithList:(NSArray *)buildings currentBuildingId:(NSString *)curBuilding
{
    for (MXMGeoBuilding *inB in buildings) {
        if ([curBuilding isEqualToString:inB.identifier]) {
            return NO;
        }
    }
    return YES;
}


- (nullable MXMIndoorMapInfo *)decideWithUserLocationLevel:(NSInteger)level atPointBuildingDic:(NSDictionary<NSString *, MXMGeoBuilding *> *)buildings
{
    NSArray *buildingList = [buildings allValues];
    for (MXMGeoBuilding *b in buildingList) {
        NSString *localFloor = [self calculateFloorWithLevel:level andBuilding:b];
        if (localFloor) {
            [self specifyTheBuilding:b.identifier
                               floor:localFloor
                            zoomMode:MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:NO
                 withRectBuildingDic:buildings];
            return [[MXMIndoorMapInfo alloc] initWithBuilding:b floor:localFloor];
        }
    }
    return nil;
}


- (NSString *)calculateFloorWithLevel:(NSInteger)level andBuilding:(MXMGeoBuilding *)building
{
    NSString *localFloor = nil;
    NSUInteger gf = [building.floors indexOfObject:building.ground_floor];
    NSInteger cf = gf - level;
    if (cf>=0 && cf<building.floors.count) {
        localFloor = [building.floors objectAtIndex:cf];
    }
    return localFloor;
}


- (void)specifyTheBuilding:(NSString *)buildingId
                     floor:(NSString *)floor
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets
  shouldChangeTrackingMode:(BOOL)changeTrackingMode
       withRectBuildingDic:(NSDictionary<NSString *,MXMGeoBuilding *> *)buildings
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShowFloorBar:onBuilding:floor:)]) {
        BOOL show = buildingId ? YES : NO;
        [self.delegate decideMapViewShowFloorBar:show onBuilding:buildingId floor:floor];
    }
    // 建筑ID没有指定则直接跳过
    if (buildingId == nil) {
        return;
    }
    // 从地图瓦片获取建筑数据
    MXMGeoBuilding *theBuilding = [buildings objectForKey:buildingId];
    BOOL state = [self shouldBeQueryWithBuilding:theBuilding shouldZoomTo:(zoomMode != MXMZoomDisable)];
    if (state) {
        __weak typeof(self) weakSelf = self;
        self.operation.complateBlock = ^(MXMBuilding * _Nullable building) {
            // 调用zoom map
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(decideMapViewZoomTo:zoomMode:withEdgePadding:)]) {
                [weakSelf.delegate decideMapViewZoomTo:building.bbox zoomMode:zoomMode withEdgePadding:insets];
            }
            // 显示建筑
            [weakSelf displayWihtGeoBuilding:theBuilding orNetBuilding:building setFloor:floor shouldChangeTrackingMode:changeTrackingMode];
        };
        [self.operation searchWithBuildingId:buildingId];
    } else { // 不用zoom也不用网络查询的情况
        // 显示建筑
        [self displayWihtGeoBuilding:theBuilding orNetBuilding:nil setFloor:floor shouldChangeTrackingMode:changeTrackingMode];
    }
}

// 选择正确的建筑与楼层
- (void)displayWihtGeoBuilding:(nullable MXMGeoBuilding *)geo
                 orNetBuilding:(nullable MXMBuilding *)net
                      setFloor:(nullable NSString *)setFloor
      shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
    // 显示建筑
    MXMGeoBuilding *geoBuilding = geo ? : [self exchangeFrom:net];
    NSString *theEndFloor = setFloor ? : [self electDefaultFloorWithHistory:self.buildingSelectFloorDic inBuilding:geoBuilding];
    [self selectBuilding:geoBuilding floor:theEndFloor shouldChangeTrackingMode:changeTrackingMode];
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
    geoBuilding.building = netBuilding.type;
    geoBuilding.name = netBuilding.name_default;
    geoBuilding.name_cn = netBuilding.name_cn;
    geoBuilding.name_en = netBuilding.name_en;
    geoBuilding.name_zh = netBuilding.name_zh;
    NSMutableArray *floorStrs = [NSMutableArray array];
    for (MXMFloor *f in netBuilding.floors) {
        f.code ? [floorStrs addObject:f.code] : nil;
    }
    geoBuilding.floors = [[floorStrs reverseObjectEnumerator] allObjects];
    geoBuilding.ground_floor = netBuilding.groundFloor?:floorStrs.firstObject;
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
- (nullable NSString *)electDefaultFloorWithHistory:(NSDictionary *)historyDic inBuilding:(MXMGeoBuilding *)building
{
    NSAssert(building != nil, @"To query the history, you must pass in building");
    
    NSString *defaultElectFloor = historyDic[building.identifier];
    if (defaultElectFloor == nil) {
        defaultElectFloor = building.ground_floor;
    }
    return defaultElectFloor;
}


// 主要作用是过滤空输入及保存历史
- (void)selectBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
    // 无论是否
    if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewShouldChangeBuilding:floor:shouldChangeTrackingMode:)]) {
        [self.delegate decideMapViewShouldChangeBuilding:building floor:floor shouldChangeTrackingMode:changeTrackingMode];
    }
    
    if (![self canGoOnFilterWithBuilding:building floor:floor currentBuilding:self.currentBuilding currentFloor:self.currentFloor andMapReload:self.isMapReload]) {
        return;
    }

    self.currentBuilding = building;
    self.currentFloor = floor;
    // 保存id到选中队列，并取100条数据
    [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
    if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
    }

    // 保持建筑的选择楼层，下次作为默认选中楼层
    [self.buildingSelectFloorDic setObject:floor forKey:building.identifier];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(decideMapViewChangeBuilding:floor:trackingMode:)]) {
        [self.delegate decideMapViewChangeBuilding:building floor:floor trackingMode:changeTrackingMode];
    }
}


- (BOOL)canGoOnFilterWithBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor currentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andMapReload:(BOOL)isMapReload
{
    if (building == nil || floor == nil) {
        return NO;
    }
    // 判断楼层名是否正确
    if (![building.floors containsObject:floor]) {
        return NO;
    }
    // 已选中则不进行后续操作，提高应用性能
    if ([curBuilding.identifier isEqualToString:building.identifier] &&
        [curFloor isEqualToString:floor] &&
        !isMapReload) {
        return NO;
    }
    return YES;
}

- (float)decideLocationViewAlphaWithCurrentBuilding:(MXMGeoBuilding *)curBuilding currentFloor:(NSString *)curFloor andLocalFloor:(nullable CLFloor *)floor
{
    if (floor) {
        NSUInteger gf = [curBuilding.floors indexOfObject:curBuilding.ground_floor];
        NSUInteger cf = [curBuilding.floors indexOfObject:curFloor];
        if (floor.level == (gf-cf)) {
            return 1.0f;
        } else {
            return 0.5f;
        }
    } else {
        return 1.0f;
    }
}


#pragma mark - access

- (NSMutableDictionary *)buildingSelectFloorDic
{
    if (!_buildingSelectFloorDic) {
        _buildingSelectFloorDic = [NSMutableDictionary dictionary];
    }
    return _buildingSelectFloorDic;
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
