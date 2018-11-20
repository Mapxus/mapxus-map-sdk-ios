//
//  MapxusMap.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "MapxusMap+Private.h"
#import "MXMMapServices+Private.h"
#import "MGLMapView+MXMSwizzle.h"
#import "MXMPointAnnotation+Private.h"



@implementation MapxusMap



- (instancetype)initWithMapView:(MGLMapView *)mapView
{
    return [self initWithMapView:mapView configuration:nil];
}

- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration
{
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.mapView.mxmMap = self;
        [self commonInit];
        _isFristLoad = YES;
        _initializeQueue = [[NSOperationQueue alloc] init];
        _configuration = configuration;
        [self setMapSytle:configuration.defaultStyle];
    }
    return self;
}

- (void)searchConfigurationInfo
{
    if (!_isFristLoad) {
        _isFristLoad = NO;
        return;
    }
    if (_configuration.poiId) {
        __weak typeof(self) weakSelf = self;
        MXMSearchPOIOperation *searchPoiOp = [[MXMSearchPOIOperation alloc] initWithPoiId:_configuration.poiId];
        searchPoiOp.complateBlock = ^(NSString * _Nonnull buildingId, NSString * _Nonnull floor, CLLocationCoordinate2D centerPoint) {
            [weakSelf.mapView setCenterCoordinate:centerPoint zoomLevel:19 animated:YES];
            [weakSelf selectBuilding:buildingId floor:floor shouldZoomTo:NO shouldChangeUserTrackingMode:YES];
        };
        [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
    } else if (_configuration.buildingId) {
        [self selectBuilding:_configuration.buildingId floor:_configuration.floor shouldZoomTo:YES shouldChangeUserTrackingMode:YES];
    }
}

- (void)setIndoorControllerAlwaysHidden:(BOOL)indoorControllerAlwaysHidden
{
    _indoorControllerAlwaysHidden = indoorControllerAlwaysHidden;
    [self automaticAnalyseOfIndoorData];
}

- (void)setSelectorPosition:(MXMSelectorPosition)selectorPosition
{
    _selectorPosition = selectorPosition;

    NSLayoutConstraint *floorBarXLc = [self _constraintWithIndientifer:@"floorBarXLc" InView:self.mapView];
    if (floorBarXLc) [self.mapView removeConstraint:floorBarXLc];
    NSLayoutConstraint *floorBarYLc = [self _constraintWithIndientifer:@"floorBarYLc" InView:self.mapView];
    if (floorBarYLc) [self.mapView removeConstraint:floorBarYLc];
    NSLayoutConstraint *buildingBtnXLc = [self _constraintWithIndientifer:@"buildingBtnXLc" InView:self.mapView];
    if (buildingBtnXLc) [self.mapView removeConstraint:buildingBtnXLc];

    switch (selectorPosition) {
        case MXMSelectorPositionCenterLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionCenterRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionTopLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionTopRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionBottomLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-50];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionBottomRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-50];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;

        default:
            break;
    }
    [self.mapView layoutIfNeeded];
}

- (NSLayoutConstraint *)_constraintWithIndientifer:(NSString *)identifer InView:(UIView *)view {
    NSLayoutConstraint * constraintToFind = nil;
    for (NSLayoutConstraint * constraint in view.constraints ) {
        if([constraint.identifier isEqualToString:identifer]) {
            constraintToFind = constraint;
            break;
        }
    }
    return constraintToFind;
}

- (void)setMapSytle:(MXMStyle)style
{
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        switch (style) {
            case MXMStyleCOMMON:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/common_v3", MXMBRMHOSTURL]];
                break;
            case MXMStyleCHRISTMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/christmas_v3", MXMBRMHOSTURL]];
                break;
            case MXMStyleHALLOWMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/halloween_v3", MXMBRMHOSTURL]];
                break;
            case MXMStyleMAPPYBEE:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/mappy_bee_v3", MXMBRMHOSTURL]];
                break;
            case MXMStyleMAPXUS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/mapxus_v3", MXMBRMHOSTURL]];
                break;
            default:
                break;
        }
    }];
}


#pragma mark - 手势响应

// 单击手势响应
- (void)singleTapToDo:(id)sender
{
    CGPoint point = [sender locationInView:self.mapView];
    
    /////////////////////////////////////////////////////
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    NSSet *set = [[NSSet alloc] initWithObjects:@"maphive-floor-fill", nil];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:set predicate:nil];
    id<MGLFeature> feature = theFeatures.firstObject;
    NSString *floor = [feature attributeForKey:@"floor"];
    NSString *buildingId = [feature attributeForKey:@"ref:building"];
    MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor];
    }
    /////////////////////////////////////////////////////
    
    // 查找点击的POI
    [self findOutPOIAtPoint:point coordinate:coor];
    // 切换建筑
    NSArray *pointBuildingList = [self findOutBuildingAtPoint:point];
    MXMGeoBuilding *building = pointBuildingList.firstObject;
    if (building) {
        NSString *defaultFloor = [self electDefaultFloorWithBuildingId:building.identifier];
        [self selectBuilding:building.identifier floor:defaultFloor shouldZoomTo:NO shouldChangeUserTrackingMode:YES];
    }
}

// 长按手势响应
- (void)longPressAction:(id)sender
{
    CGPoint point = [sender locationInView:self.mapView];
    
    /////////////////////////////////////////////////////
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    NSSet *set = [[NSSet alloc] initWithObjects:@"maphive-floor-fill", nil];
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:set predicate:nil];
    id<MGLFeature> feature = theFeatures.firstObject;
    NSString *floor = [feature attributeForKey:@"floor"];
    NSString *buildingId = [feature attributeForKey:@"ref:building"];
    MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didLongPressedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:)]) {
        [self.delegate mapView:self didLongPressedAtCoordinate:coor];
    }
    /////////////////////////////////////////////////////

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 中心点室内数据筛选

// 自动选择默认选中建筑
- (void)automaticAnalyseOfIndoorData
{
    // 查找当前中心view坐标的Building队列
    // 获取中心矩形内的建筑信息
    CGSize mapSize = self.mapView.bounds.size;
    CGRect rect = CGRectMake(mapSize.width/4, mapSize.height/4, mapSize.width/2, mapSize.height/2);
    // 自动选择使用列表
    self.innerbuildings = [self findOutBuildingIntheRect:rect];
    // 整屏可见建筑列表
    self.buildings = [self findOutBuildingIntheRect:self.mapView.bounds];
    // 设置建筑选择按钮和楼层选择按钮是否显示
    self.buildingSelectBtn.hidden = self.indoorControllerAlwaysHidden || !((self.innerbuildings.count>=2)&&(self.mapView.zoomLevel>15));
    self.floorBar.hidden = self.indoorControllerAlwaysHidden || !((self.innerbuildings.count>=1)&&(self.mapView.zoomLevel>15));
    self.isIndoor = !self.floorBar.isHidden;
    // 默认选中building，规则为优先选中之前选过的
    MXMGeoBuilding *defaultBuilding = [self electDefaultBuildingRecently];
    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:defaultBuilding.identifier];
    [self selectBuilding:defaultBuilding.identifier floor:defaultFloor shouldZoomTo:NO shouldChangeUserTrackingMode:NO];
}

// 查找给定区域的所有建筑
- (NSDictionary *)findOutBuildingIntheRect:(CGRect)rect
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『mBuilding』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive-building-fill"]) {
            [identifiersSet addObject:identifier];
        }
    }
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:identifiersSet predicate:nil];
    // 建筑信息去重
    NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in theFeatures) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            [resultBuildings setObject:[MXMGeoBuilding yy_modelWithJSON:feature.attributes] forKey:theId];
        }
    }
    return [NSDictionary dictionaryWithDictionary:resultBuildings];
}


// 查找给定点的所有建筑
- (NSArray<MXMGeoBuilding *> *)findOutBuildingAtPoint:(CGPoint)point
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『mBuilding』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive-building-fill"]) {
            [identifiersSet addObject:identifier];
        }
    }
    // 获取中心点的建筑信息
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiersSet];
    // 建筑信息去重
    NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in theFeatures) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            [resultBuildings setObject:[MXMGeoBuilding yy_modelWithJSON:feature.attributes] forKey:theId];
        }
    }
    return [resultBuildings allValues];
}

// 查找指定点的POI信息
- (void)findOutPOIAtPoint:(CGPoint)point coordinate:(CLLocationCoordinate2D)coor
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『maphive』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive"] && [theLayer isKindOfClass:[MGLSymbolStyleLayer class]]){
            [identifiersSet addObject:identifier];
        }
    }
    // 获取中心点内的建筑信息
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiersSet predicate:nil];
    id<MGLFeature> fristM = theFeatures.firstObject;
    MXMGeoPOI *poi = [MXMGeoPOI yy_modelWithJSON:fristM.attributes];
    poi.coordinate = coor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didTappedOnPOI:)]) {
        [self.delegate mapView:self didTappedOnPOI:poi];
    }
}

#pragma mark end



#pragma mark - 控件筛选建筑

- (void)selectBuildingOnClick:(UIButton *)sender {
    NSTextAlignment alig = NSTextAlignmentLeft;
    switch (self.selectorPosition) {
        case MXMSelectorPositionTopRight:
        case MXMSelectorPositionCenterRight:
        case MXMSelectorPositionBottomRight:
            alig = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.buildings.count];
    for (MXMGeoBuilding *b in [self.innerbuildings allValues]) {
        KxMenuItem *item = [KxMenuItem menuItem:b.name
                                     identifier:b.identifier
                                          image:nil
                                         target:self
                                         action:@selector(chooseItem:)];
        item.alignment = alig;
        [arr addObject:item];
    }
    [KxMenu setDefaultItemIdentifier:self.building.identifier];
    [KxMenu showMenuInView:self.mapView fromRect:sender.frame menuItems:arr];
}

- (void)chooseItem:(KxMenuItem *)sender
{
    MXMGeoBuilding *b = [self.innerbuildings objectForKey:sender.identifier];
    [self selectBuilding:b.identifier shouldZoomTo:NO];
}

- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName
{
    [self selectBuilding:self.building.identifier floor:floorName shouldZoomTo:NO shouldChangeUserTrackingMode:YES];
}

#pragma mark - 建筑筛选

// 选举默认选中楼层，参考历史选中
- (nullable NSString *)electDefaultFloorWithBuildingId:(nullable NSString *)buildingId
{
    if (buildingId == nil) {
        return nil;
    }
    NSString *defaultElectFloor = self.buildingSelectFloorDic[buildingId];
    if (defaultElectFloor == nil) {
        MXMGeoBuilding *b = [self.buildings objectForKey:buildingId];
        defaultElectFloor = b.ground_floor;
    }
    return defaultElectFloor;
}

// 选举默认选中建筑，参考历史选中
- (nullable MXMGeoBuilding *)electDefaultBuildingRecently
{
    NSArray *values = [self.innerbuildings allValues];
    // 取出默认第一个
    MXMGeoBuilding *result = values.firstObject;
    // 与历史ID匹对
    for (NSString *buildingId in self.historicalBuildingIds) {
        for (MXMGeoBuilding *building in values) {
            if ([building.identifier isEqualToString:buildingId]) {
                result = building;
                return result;
            }
        }
    }
    return result;
}

- (void)selectFloor:(NSString *)floor
{
    [self.floorBar selectRow:floor];
    [self selectBuilding:self.building.identifier floor:floor];
}

- (void)selectFloor:(NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self.floorBar selectRow:floor];
    [self selectBuilding:self.building.identifier floor:floor shouldZoomTo:zoomTo];
}

- (void)selectBuilding:(NSString *)buildingId
{
    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:buildingId];
    [self selectBuilding:buildingId floor:defaultFloor];
}

- (void)selectBuilding:(NSString *)buildingId shouldZoomTo:(BOOL)zoomTo
{
    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:buildingId];
    [self selectBuilding:buildingId floor:defaultFloor shouldZoomTo:zoomTo];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    [self selectBuilding:buildingId floor:floor shouldZoomTo:YES shouldChangeUserTrackingMode:YES];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self selectBuilding:buildingId floor:floor shouldZoomTo:zoomTo shouldChangeUserTrackingMode:YES];
}


#pragma mark - private
// 保证buildingId不为空，floor不作限制
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo shouldChangeUserTrackingMode:(BOOL)changeUserTrackingMode
{
    if (buildingId == nil) {
        return;
    }
    MXMGeoBuilding *building = [self.buildings objectForKey:buildingId];
    if (building) { // 建筑在屏内
        if (zoomTo) {
            __weak typeof(self) weakSelf = self;
            MXMSearchBuildingOperation *searchBuildingOp = [[MXMSearchBuildingOperation alloc] initWithBuildingId:buildingId floor:floor];
            searchBuildingOp.complateBlock = ^(MXMBuilding * _Nonnull building, NSString * _Nonnull floor, MGLCoordinateBounds bounds) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.mapView.visibleCoordinateBounds = bounds;
                    MXMGeoBuilding *geoBuilding = [[MXMGeoBuilding alloc] init];
                    geoBuilding.identifier = building.buildingId;
                    geoBuilding.building = building.type;
                    geoBuilding.name = building.name_default;
                    geoBuilding.name_cn = building.name_cn;
                    geoBuilding.name_en = building.name_en;
                    geoBuilding.name_zh = building.name_zh;
                    NSMutableArray *floorStrs = [NSMutableArray array];
                    for (MXMFloor *f in building.floors) {
                        f.code ? [floorStrs addObject:f.code] : nil;
                    }
                    geoBuilding.floors = [[floorStrs reverseObjectEnumerator] allObjects];
                    geoBuilding.ground_floor = floorStrs.firstObject;
                    if (floor) {
                        [weakSelf selectBuilding:geoBuilding floor:floor shouldChangeUserTrackingMode:changeUserTrackingMode];
                    } else {
                        NSString *defaultFloor = [self electDefaultFloorWithBuildingId:buildingId]?:geoBuilding.ground_floor;
                        [weakSelf selectBuilding:geoBuilding floor:defaultFloor shouldChangeUserTrackingMode:changeUserTrackingMode];
                    }
                    weakSelf.floorBar.hidden = self.indoorControllerAlwaysHidden || !((self.building)&&(self.mapView.zoomLevel>15));

                });
            };
            [_initializeQueue addOperation:searchBuildingOp];
        } else {
            [self selectBuilding:building floor:floor shouldChangeUserTrackingMode:changeUserTrackingMode];
            
            self.floorBar.hidden = self.indoorControllerAlwaysHidden || !((self.building)&&(self.mapView.zoomLevel>15));
        }
    } else {
        __weak typeof(self) weakSelf = self;
        MXMSearchBuildingOperation *searchBuildingOp = [[MXMSearchBuildingOperation alloc] initWithBuildingId:buildingId floor:floor];
        searchBuildingOp.complateBlock = ^(MXMBuilding * _Nonnull building, NSString * _Nonnull floor, MGLCoordinateBounds bounds) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (zoomTo) {
                    weakSelf.mapView.visibleCoordinateBounds = bounds;
                }
                MXMGeoBuilding *geoBuilding = [[MXMGeoBuilding alloc] init];
                geoBuilding.identifier = building.buildingId;
                geoBuilding.building = building.type;
                geoBuilding.name = building.name_default;
                geoBuilding.name_cn = building.name_cn;
                geoBuilding.name_en = building.name_en;
                geoBuilding.name_zh = building.name_zh;
                NSMutableArray *floorStrs = [NSMutableArray array];
                for (MXMFloor *f in building.floors) {
                    f.code ? [floorStrs addObject:f.code] : nil;
                }
                geoBuilding.floors = [[floorStrs reverseObjectEnumerator] allObjects];
                geoBuilding.ground_floor = floorStrs.firstObject;
                if (floor) {
                    [weakSelf selectBuilding:geoBuilding floor:floor shouldChangeUserTrackingMode:changeUserTrackingMode];
                } else {
                    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:buildingId]?:geoBuilding.ground_floor;
                    [weakSelf selectBuilding:geoBuilding floor:defaultFloor shouldChangeUserTrackingMode:changeUserTrackingMode];
                }
                weakSelf.floorBar.hidden = self.indoorControllerAlwaysHidden || !((self.building)&&(self.mapView.zoomLevel>15));

            });
        };
        [_initializeQueue addOperation:searchBuildingOp];
    }
}

// 保证building和floor不能为空，数据要全
- (void)selectBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor shouldChangeUserTrackingMode:(BOOL)changeUserTrackingMode
{
    if (building == nil) {
        return;
    }
    // 判断楼层名是否正确
    if (![building.floors containsObject:floor]) {
        return;
    }
    // 已选中则不进行后续操作，提高应用性能
    if ([building.identifier isEqualToString:self.building.identifier] &&
        [floor isEqualToString:self.floor] &&
        !self.isMapReload) {
        return;
    }
    if (changeUserTrackingMode && (self.mapView.userTrackingMode != MGLUserTrackingModeNone)) {
        [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
    }
    // 设置FloorSelectorBar
    [self.floorBar resetItems:building.floors defaultSelectRow:floor];
    self.isMapReload = NO;
    // 保存当前选中
    self.building = building;
    // 保存id到选中队列，并取100条数据
    [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
    if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
    }
    // 保存当前选中楼层
    self.floor = floor;
    // 保持建筑的选择楼层，下次作为默认选中楼层
    [self.buildingSelectFloorDic setObject:floor forKey:building.identifier];
    // 配置对应的Filter
    [self filerBuildingId:building.identifier Floor:floor];
    // 回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
        [self.delegate mapView:self didChangeFloor:self.floor atBuilding:self.building];
    }
    [self updageLocationView];
    [self filterMXMAnnotations];
}

// 地图图层数据过滤，保证buildingId和floor不能为空
- (void)filerBuildingId:(NSString *)buildingId Floor:(NSString *)floor {
    NSArray *arr = self.mapView.style.layers;
    for (MGLStyleLayer *k in arr) {
        // 过滤不需要处理的layer
        if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
            continue;
        }
        MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
        NSString *ident = vk.identifier;
        if (![ident hasPrefix:@"maphive"] || [ident hasPrefix:@"maphive-building"]) {
            continue;
        }
        
        // 处理剩下需要添加filter的layer
        id originalPredicate = vk.predicate;
        NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
        if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
            NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
            for (NSCompoundPredicate *s in sub) {
                NSString *str = s.predicateFormat;
                if (![str containsString:@"floor =="] && ![str containsString:@"ref:building =="]) {
                    [mu addObject:s];
                }
            }
        } else {
            if (originalPredicate) {
                [mu addObject:originalPredicate];
            }
        }
        NSPredicate *f = [NSPredicate predicateWithFormat:@"floor == %@", floor];
        [mu addObject:f];
        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
        [mu addObject:b];
        NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
        // 重置过滤
        vk.predicate = reSetPredicate;
    }
}

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.mxmPointAnnotations addObjectsFromArray:annotations];
    [self.mapView addAnnotations:annotations];
    [self filterMXMAnnotations];
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.mxmPointAnnotations removeObjectsInArray:annotations];
    [self.mapView removeAnnotations:annotations];
}

// 定位标注的显示状态
- (void)updageLocationView
{
    // 切换楼层时
    if (!self.mapView.showsUserLocation) {
        return;
    }
    UIView *locationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
    if (self.mapView.userLocation.location.floor) {
        NSUInteger gf = [self.building.floors indexOfObject:self.building.ground_floor];
        NSUInteger cf = [self.building.floors indexOfObject:self.floor];
        if (self.mapView.userLocation.location.floor.level == (gf-cf)) {
            locationView.alpha = 1.0f;
        } else {
            locationView.alpha = 0.5f;
        }
    } else {
        locationView.alpha = 1.0f;
    }
}

// annotation过滤
- (void)filterMXMAnnotations
{
    NSMutableArray *MXMAnns = [NSMutableArray array];
    for (MXMPointAnnotation *ann in self.mxmPointAnnotations) {
        if (self.isIndoor) {
            if ([ann.buildingId isEqualToString:self.building.identifier]) {
                if ([ann.floor isEqualToString:self.floor]) {
                    ann.hidden = NO;
                    [MXMAnns addObject:ann];
                } else {
                    ann.hidden = YES;
                }
            } else {
                ann.hidden = NO;
                [MXMAnns addObject:ann];
            }
        } else {
            ann.hidden = NO;
            [MXMAnns addObject:ann];
        }
    }
    // 找交集
    NSMutableSet *all = [NSMutableSet setWithArray:self.mapView.annotations];
    NSMutableSet *mxms = [NSMutableSet setWithArray:self.mxmPointAnnotations];
    [all intersectSet:mxms];
    NSArray *intersection = all.allObjects;
    // 移除公共部分
    [self.mapView removeAnnotations:intersection];
    // 添加不隐藏的marker
    [self.mapView addAnnotations:MXMAnns];
}




#pragma mark - access

- (void)commonInit
{
    self.indoorControllerAlwaysHidden = NO;
    self.mapView.attributionButton.hidden = YES;
    self.mapView.logoView.hidden = YES;
    
    [self.mapView addSubview:self.openStreetSourceBtn];
    NSLayoutConstraint *openStreetRightLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:openStreetRightLc];
    NSLayoutConstraint *openStreetBottomLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:openStreetBottomLc];
    NSLayoutConstraint *openStreetWLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:190.0f];
    [self.openStreetSourceBtn addConstraint:openStreetWLc];
    NSLayoutConstraint *openStreetHLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:13.0f];
    [self.openStreetSourceBtn addConstraint:openStreetHLc];
    
    
    [self.mapView addSubview:self.MXMLogo];
    NSLayoutConstraint *logoLeftLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    [self.mapView addConstraint:logoLeftLc];
    NSLayoutConstraint *logoBottomLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:logoBottomLc];
    NSLayoutConstraint *logoWLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:78.0f];
    [self.MXMLogo addConstraint:logoWLc];
    NSLayoutConstraint *logoHLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:14.0f];
    [self.MXMLogo addConstraint:logoHLc];
    
    
    // 添加楼层选择栏与约束
    [self.mapView addSubview:self.floorBar];
    NSLayoutConstraint *floorBarLeftLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    floorBarLeftLc.identifier = @"floorBarXLc";
    [self.mapView addConstraint:floorBarLeftLc];
    NSLayoutConstraint *floorBarBottomLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
    floorBarBottomLc.identifier = @"floorBarYLc";
    [self.mapView addConstraint:floorBarBottomLc];
    NSLayoutConstraint *floorBarWLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:42];
    [self.floorBar addConstraint:floorBarWLc];
    NSLayoutConstraint *floorBarHLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:200.0f];
    [self.floorBar addConstraint:floorBarHLc];
    
    
    // 添加建筑选择按钮与约束
    [self.mapView addSubview:self.buildingSelectBtn];
    NSLayoutConstraint *buiSelLeftLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
    buiSelLeftLc.identifier = @"buildingBtnXLc";
    [self.mapView addConstraint:buiSelLeftLc];
    NSLayoutConstraint *buiSelBottomLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.floorBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:-4];
    [self.mapView addConstraint:buiSelBottomLc];
    NSLayoutConstraint *buiSelWLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectBtn addConstraint:buiSelWLc];
    NSLayoutConstraint *buiSelHLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectBtn addConstraint:buiSelHLc];
    
    
    // 添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToDo:)];
    tap.delegate = self;
    [self.mapView addGestureRecognizer:tap];
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.8;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
    // 长按失败才检测单击事件
    [tap requireGestureRecognizerToFail:longPress];
}

- (UIButton *)buildingSelectBtn
{
    if (!_buildingSelectBtn) {
        _buildingSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buildingSelectBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSBundle *bundle = [NSBundle bundleForClass:[MapxusMap class]];
        UIImage *image = [UIImage imageNamed:@"selectBuilding" inBundle:bundle compatibleWithTraitCollection:nil];
        [_buildingSelectBtn setImage:image forState:UIControlStateNormal];
        [_buildingSelectBtn addTarget:self action:@selector(selectBuildingOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buildingSelectBtn;
}

- (MXMFloorSelectorBar *)floorBar
{
    if (!_floorBar) {
        _floorBar = [[MXMFloorSelectorBar alloc] init];
        _floorBar.translatesAutoresizingMaskIntoConstraints = NO;
        _floorBar.delegate = self;
    }
    return _floorBar;
}

- (UIButton *)MXMLogo
{
    if (!_MXMLogo) {
        NSBundle *bundle = [NSBundle bundleForClass:[MapxusMap class]];
        UIImage *image = [UIImage imageNamed:@"mapxusLogo" inBundle:bundle compatibleWithTraitCollection:nil];
        _MXMLogo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MXMLogo setImage:image forState:UIControlStateNormal];
        _MXMLogo.translatesAutoresizingMaskIntoConstraints = NO;
        [_MXMLogo addTarget:self action:@selector(logoOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MXMLogo;
}

- (void)logoOnClickAction:(UIButton *)sender
{
    
    UIAlertController *attributionController = [UIAlertController alertControllerWithTitle:@"Mapxus Maps SDK for iOS"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *fristAction = [UIAlertAction actionWithTitle:@"© Mapxus"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mapxus.com"]];
                                                        }];
    [attributionController addAction:fristAction];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"© OpenStreeMap"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/about/"]];
                                                         }];
    [attributionController addAction:secondAction];
    
    NSString *cancelTitle = @"Cancel";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    [attributionController addAction:cancelAction];
    
    attributionController.popoverPresentationController.sourceView = sender;
    attributionController.popoverPresentationController.sourceRect = sender.frame;
    
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [viewController presentViewController:attributionController
                                 animated:YES
                               completion:NULL];
}

- (UIButton *)openStreetSourceBtn
{
    if (!_openStreetSourceBtn) {
        _openStreetSourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openStreetSourceBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _openStreetSourceBtn.backgroundColor = [UIColor clearColor];
        _openStreetSourceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_openStreetSourceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_openStreetSourceBtn setTitle:@"© OpenStreetMap contributors" forState:UIControlStateNormal];
        [_openStreetSourceBtn addTarget:self action:@selector(showOpenStreeSourceWeb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openStreetSourceBtn;
}

- (void)showOpenStreeSourceWeb
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/copyright"]];
}

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
        _historicalBuildingIds = [NSMutableArray arrayWithCapacity:100];
    }
    return _historicalBuildingIds;
}

- (NSMutableArray *)mxmPointAnnotations
{
    if (!_mxmPointAnnotations) {
        _mxmPointAnnotations = [NSMutableArray array];
    }
    return _mxmPointAnnotations;
}

- (void)dealloc
{
    // 清除mapView对self的引用
    _mapView.mxmMap = nil;
    _mapView = nil;
}


@end







