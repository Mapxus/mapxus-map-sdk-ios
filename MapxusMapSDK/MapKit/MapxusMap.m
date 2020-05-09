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
#import "MGLStyle+MXMFilter.h"
#import "MGLStyleLayer+MXMFilter.h"
#import "JXJsonFunctionDefine.h"


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
        
        self.decider = [[MXMDecider alloc] initWithDelegate:self];
        self.dataQueryer = [[MXMDataQuerier alloc] initWithMapView:mapView];
        self.annHolder = [[MXMAnnotationsHolder alloc] initWithMapView:mapView];
        
        self.gestureSwitchingBuilding = YES;
        self.autoChangeBuilding = YES;
        self.indoorControllerAlwaysHidden = NO;
        self.mapView.attributionButton.hidden = YES;
        self.mapView.logoView.hidden = YES;
        _isFristLoad = YES;
        _initializeQueue = [[NSOperationQueue alloc] init];
        
        [self commonInit];

        _configuration = configuration;
        _outdoorHidden = configuration.outdoorHidden;
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
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.mapView setCenterCoordinate:centerPoint zoomLevel:strongSelf->_configuration.zoomLevel animated:NO];
            [strongSelf.decider specifyTheBuilding:buildingId
                                           floor:floor
                                        zoomMode:MXMZoomDisable
                                     edgePadding:UIEdgeInsetsZero
                        shouldChangeTrackingMode:YES
                             withRectBuildingDic:strongSelf.buildings];
        };
        [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
    } else if (_configuration.buildingId) {
        [self.decider specifyTheBuilding:_configuration.buildingId
                                   floor:_configuration.floor
                                zoomMode:MXMZoomDirect
                             edgePadding:_configuration.zoomInsets
                shouldChangeTrackingMode:YES
                     withRectBuildingDic:self.buildings];
    }
}

- (void)setIndoorControllerAlwaysHidden:(BOOL)indoorControllerAlwaysHidden
{
    _indoorControllerAlwaysHidden = indoorControllerAlwaysHidden;
    BOOL show = self.building.identifier ? YES : NO;
    [self decideMapViewShowFloorBar:show onBuilding:self.building.identifier floor:self.floor];
}

- (void)setSelectorPosition:(MXMSelectorPosition)selectorPosition
{
    _selectorPosition = selectorPosition;

    [self _constraintWithIndientifer:@"floorBarXLc" InView:self.mapView].active = NO;
    [self _constraintWithIndientifer:@"floorBarYLc" InView:self.mapView].active = NO;

    NSLayoutConstraint *floorBarXLc;
    NSLayoutConstraint *floorBarYLc;
    
    switch (selectorPosition) {
        case MXMSelectorPositionCenterLeft:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.leftAnchor constant:31];
            floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:self.mapView.centerYAnchor constant:30];
        }
            break;
        case MXMSelectorPositionCenterRight:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.rightAnchor constant:-31];
            floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:self.mapView.centerYAnchor constant:30];
        }
            break;
        case MXMSelectorPositionTopLeft:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.leftAnchor constant:31];
            floorBarYLc = [self.floorBar.topAnchor constraintEqualToAnchor:self.mapView.topAnchor constant:100];
        }
            break;
        case MXMSelectorPositionTopRight:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.rightAnchor constant:-31];
            floorBarYLc = [self.floorBar.topAnchor constraintEqualToAnchor:self.mapView.topAnchor constant:100];
        }
            break;
        case MXMSelectorPositionBottomLeft:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.leftAnchor constant:31];
            floorBarYLc = [self.floorBar.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-50];
        }
            break;
        case MXMSelectorPositionBottomRight:
        {
            floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.rightAnchor constant:-31];
            floorBarYLc = [self.floorBar.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-50];
        }
            break;

        default:
            break;
    }
    
    floorBarXLc.identifier = @"floorBarXLc";
    floorBarYLc.identifier = @"floorBarYLc";

    [NSLayoutConstraint activateConstraints:@[floorBarXLc, floorBarYLc]];
    
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

- (void)setOutdoorHidden:(BOOL)outdoorHidden
{
    _outdoorHidden = outdoorHidden;
    [self walkAroundOutdoor];
}

- (void)walkAroundOutdoor
{
    NSArray *arr = self.mapView.style.layers;
    for (MGLStyleLayer *k in arr) {
        if ([k isOutdoorLayer]) {
            k.visible = !_outdoorHidden;
        }
    }
}

- (void)setMapSytle:(MXMStyle)style
{
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        switch (style) {
            case MXMStyleCOMMON:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/brm/api/v3/style/common_mims2_v1", MXMAPIHOSTURL]];
                break;
            case MXMStyleCHRISTMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/brm/api/v3/style/christmas_mims2_v1", MXMAPIHOSTURL]];
                break;
            case MXMStyleHALLOWMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/brm/api/v3/style/halloween_mims2_v1", MXMAPIHOSTURL]];
                break;
            case MXMStyleMAPPYBEE:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/brm/api/v3/style/mappybee_mims2_v1", MXMAPIHOSTURL]];
                break;
            case MXMStyleMAPXUS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/brm/api/v3/style/mapxus_mims2_v1", MXMAPIHOSTURL]];
                break;
            default:
                break;
        }
    }];
}

- (void)setMapLanguage:(NSString *)language
{
    [self.mapView.style MXMlocalizeLabelsIntoLocale:language];
}

#pragma mark - 手势响应

- (void)automaticAnalyseOfIndoorData
{
    self.regionBecomeIdle = NO;
    [self idleAutomaticAnalyseOfIndoorData];
}

- (void)idleAutomaticAnalyseOfIndoorData
{
    self.venues = [self.dataQueryer findOutVenueInTheRect:self.mapView.bounds];
    // 整屏可见建筑列表，无论是否需要自动选择建筑功能，buildings 都需要对外放出值
    self.buildings = [self.dataQueryer findOutBuildingInTheRect:self.mapView.bounds];
    
    // 正在赶路，不用分析沿路建筑
    if (self.flying) {
        return;
    }
    
    CGSize mapSize = self.mapView.bounds.size;
    CGRect rect = CGRectMake(mapSize.width/4, mapSize.height/4, mapSize.width/2, mapSize.height/2);
    // 自动选择使用列表，如果不需要自动选择建筑功能，innerbuildings 就不需要有值，
    self.innerbuildings = [self.dataQueryer findOutBuildingInTheRect:rect];
    
    if (!self.autoChangeBuilding) {
        BOOL show = self.building.identifier ? YES : NO;
        [self decideMapViewShowFloorBar:show onBuilding:self.building.identifier floor:self.floor];
        return;
    }

    [self.decider decideInRectBuildingDic:self.innerbuildings];
}

// 单击手势响应
- (void)singleTapToDo:(id)sender
{
    // 转换坐标
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    // 查找点击楼层
    /////////////////////////////////////////////////////
    NSArray<id <MGLFeature>> *theFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
    id<MGLFeature> feature = theFeatures.firstObject;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:onFloor:inBuilding:)]) {
        NSString *floor = [feature attributeForKey:@"name"];
        NSString *buildingId = [feature attributeForKey:@"ref:building"];
        MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor];
    }
    /////////////////////////////////////////////////////
    if (self.gestureSwitchingBuilding) {
        // 切换建筑
        NSDictionary *poiBuildings = [self.dataQueryer findOutBuildingAtPoint:point];
        [self.decider decideAtPointBuildingDic:poiBuildings];
    }
    // 查找点击的POI
    NSString *floor = [feature attributeForKey:@"name"];
    NSString *floorId = [feature attributeForKey:@"id"];
    NSNumber *floorOrdinal = DecodeNumberFromDic(feature.attributes, @"ordinal");
    [self findOutPOIAtPoint:point floor:floor floorId:floorId ordinal:floorOrdinal coordinate:coor];
}

// 长按手势响应
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 转换坐标
        CGPoint point = [gesture locationInView:self.mapView];
        CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        // 查找长按楼层
        /////////////////////////////////////////////////////
        if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:onFloor:inBuilding:)]) {
            NSArray<id <MGLFeature>> *theFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
            id<MGLFeature> feature = theFeatures.firstObject;
            NSString *floor = [feature attributeForKey:@"name"];
            NSString *buildingId = [feature attributeForKey:@"ref:building"];
            MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
            [self.delegate mapView:self didLongPressedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:)]) {
            [self.delegate mapView:self didLongPressedAtCoordinate:coor];
        }
        /////////////////////////////////////////////////////
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - MXMDeciderDelegate
- (void)cleanMapSelected {
    MXMGeoBuilding *building = self.building;
    NSString *floor = self.floor;
    if (building && floor) {
        // 配置过滤条件
        NSUInteger index = [building.floors indexOfObject:floor];
        NSString *levelId = building.floorIds[index];
        [self.mapView.style filerBuildingId:building.identifier floor:floor levelId:levelId];
        [self.mapView.style updateBuildingFillOpacityWith:building.identifier indoorState:self.isIndoor];
    } else {
        [self.mapView.style filerBuildingId:@"" floor:@"" levelId:@""];
    }
}

- (void)decideMapViewShowFloorBar:(BOOL)show onBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    // 设置建筑选择按钮和楼层选择按钮是否显示
    self.buildingSelectButton.hidden = self.indoorControllerAlwaysHidden || !((self.innerbuildings.count>=2)&&(self.mapView.zoomLevel>15.7));
    self.floorBar.hidden = self.indoorControllerAlwaysHidden || !(show&&(self.mapView.zoomLevel>15.7));
    self.isIndoor = show && (self.mapView.zoomLevel>15.7);
    [self.mapView.style updateBuildingFillOpacityWith:buildingId indoorState:self.isIndoor];
    if (self.delegate && [self.delegate respondsToSelector: @selector(mapView:indoorMapWithIn:building:floor:)]) {
        [self.delegate mapView:self indoorMapWithIn:self.isIndoor building:buildingId floor:floor];
    }
}

- (void)decideMapViewShouldChangeBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
    if (changeTrackingMode && (self.mapView.userTrackingMode != MGLUserTrackingModeNone)) {
        // 设为定位非追踪模式
        [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
    }
    // 重新过滤标注点
#warning 放在这里目的是在缩放地图到室外时及时显示所有Marker，但会造成Marker不能callout的Bug
    [self.annHolder filterMXMAnnotationsWithBuilding:building.identifier floor:floor indoorState:self.isIndoor];
}

- (void)decideMapViewChangeBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor trackingMode:(BOOL)changeTrackingMode
{
    self.building = building;
    self.floor = floor;
    // 数据中的楼层都是从小到大，需要颠倒顺序显示
    NSArray *reversalFloors = [[building.floors reverseObjectEnumerator] allObjects];
    [self.floorBar resetItems:reversalFloors defaultSelectRow:floor];
    self.decider.isMapReload = NO;

    // 配置过滤条件
    NSUInteger index = [building.floors indexOfObject:floor];
    NSString *levelId = building.floorIds[index];
    [self.mapView.style filerBuildingId:building.identifier floor:floor levelId:levelId];
    // 回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
        [self.delegate mapView:self didChangeFloor:floor atBuilding:building];
    }
    [self updageLocationView];
}

- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox zoomMode:(MXMZoomMode)zoomMode withEdgePadding:(UIEdgeInsets)insets
{
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(bbox.min_latitude, bbox.min_longitude), CLLocationCoordinate2DMake(bbox.max_latitude, bbox.max_longitude));
    __weak typeof(self) weakSelf = self;

    switch (zoomMode) {
            case MXMZoomAnimated:
        {
            self.flying = YES;
            MGLMapCamera *ca = [self.mapView cameraThatFitsCoordinateBounds:bounds edgePadding:insets];
            
            [self.mapView flyToCamera:ca withDuration:1.8 completionHandler:^{
                weakSelf.flying = NO;
                // 多调用一次保证显示出选中建筑
                [weakSelf automaticAnalyseOfIndoorData];
            }];
            break;
        }
            case MXMZoomDirect:
        {
            self.flying = NO;
            [self.mapView setVisibleCoordinateBounds:bounds edgePadding:insets animated:NO completionHandler:nil];
            break;
        }
        default:
            break;
    }
    
}

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
    [KxMenu showMenuInView:sender.superview fromRect:sender.frame menuItems:arr];
}

- (void)chooseItem:(KxMenuItem *)sender
{
    MXMGeoBuilding *b = [self.innerbuildings objectForKey:sender.identifier];
    [self selectBuilding:b.identifier zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName
{
    [self selectBuilding:self.building.identifier floor:floorName zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

#pragma mark - 建筑筛选

- (void)selectFloor:(NSString *)floor
{
    [self.decider specifyTheBuilding:self.building.identifier
                               floor:floor
                            zoomMode:MXMZoomAnimated
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectFloor:(NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:self.building.identifier
                               floor:floor
                            zoomMode:zoomTo ? MXMZoomAnimated : MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectFloor:(NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets
{
    [self.decider specifyTheBuilding:self.building.identifier
                               floor:floor
                            zoomMode:zoomMode
                         edgePadding:insets
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId
{
    [self.decider specifyTheBuilding:buildingId
                               floor:nil
                            zoomMode:MXMZoomAnimated
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:buildingId
                               floor:nil
                            zoomMode:zoomTo ? MXMZoomAnimated : MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets
{
    [self.decider specifyTheBuilding:buildingId
                               floor:nil
                            zoomMode:zoomMode
                         edgePadding:insets
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    [self.decider specifyTheBuilding:buildingId
                               floor:floor
                            zoomMode:MXMZoomAnimated
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:buildingId
                               floor:floor
                            zoomMode:zoomTo ? MXMZoomAnimated : MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId floor:(NSString *)floor zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets
{
    [self.decider specifyTheBuilding:buildingId
                               floor:floor
                            zoomMode:zoomMode
                         edgePadding:insets
            shouldChangeTrackingMode:YES
                 withRectBuildingDic:self.buildings];
}


#pragma mark - private

// 查找指定点的POI信息
- (void)findOutPOIAtPoint:(CGPoint)point floor:(NSString *)floorName floorId:(NSString *)floorId ordinal:(NSNumber *)ordinal coordinate:(CLLocationCoordinate2D)coor
{
    NSDictionary *poiDic = [self.dataQueryer findOutPOIAtPoint:point];
    NSArray *poiList = [poiDic allValues];
    MXMGeoPOI *poi = poiList.firstObject;
    poi.floor = floorName;
    poi.floorId = floorId;
    poi.ordinal = ordinal;
    if (poi) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(mapView:didTappedOnPOI:)]) {
            [self.delegate mapView:self didTappedOnPOI:poi];
        }
    } else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(mapView:didTappedOnMapBlank:)]) {
            [self.delegate mapView:self didTappedOnMapBlank:coor];
        }
    }
}

// 定位标注的显示状态
- (void)updageLocationView
{
    // 切换楼层时
    if (!self.mapView.showsUserLocation) {
        return;
    }
    CLFloor *localFloor = self.mapView.userLocation.location.floor;
    UIView *locationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
    locationView.alpha = [self.decider decideLocationViewAlphaWithCurrentBuilding:self.building
                                                                     currentFloor:self.floor
                                                                    andLocalFloor:localFloor];
}

- (NSArray<MXMPointAnnotation *> *)MXMAnnotations
{
    return [self.annHolder.mxmPointAnnotations copy];
}

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
    for (MXMPointAnnotation *ann in annotations) {
        __weak typeof(self) weakSelf = self;
        ann.sceneRefreshBlock = ^(NSString *buildingId, NSString *floor) {
            [weakSelf filterMXMAnnotation];
        };
    }
    [self.annHolder addMXMPointAnnotations:annotations];
    [self.annHolder filterMXMAnnotationsWithBuilding:self.building.identifier floor:self.floor indoorState:self.isIndoor];
}

- (void)filterMXMAnnotation
{
    [self.annHolder filterMXMAnnotationsWithBuilding:self.building.identifier floor:self.floor indoorState:self.isIndoor];
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
    for (MXMPointAnnotation *ann in annotations) {
        ann.sceneRefreshBlock = nil;
    }
    [self.annHolder removeMXMPointAnnotaions:annotations];
}




#pragma mark - access

- (void)commonInit
{
    [self.mapView addSubview:self.openStreetSourceBtn];
    [self.mapView addSubview:self.MXMLogo];
    [self.mapView addSubview:self.buildingSelectButton];
    [self.mapView addSubview:self.floorBar];
    // 添加楼层选择栏与约束
    NSLayoutConstraint *floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.leftAnchor constant:31.0f];
    floorBarXLc.identifier = @"floorBarXLc";
    NSLayoutConstraint * floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:self.mapView.centerYAnchor constant:30];
    floorBarYLc.identifier = @"floorBarYLc";
    
    NSArray *layouts = @[[self.openStreetSourceBtn.widthAnchor constraintEqualToConstant:190.0f],
      [self.openStreetSourceBtn.heightAnchor constraintEqualToConstant:13.0f],
      [self.openStreetSourceBtn.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor constant:-10.0f],
      [self.openStreetSourceBtn.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-10.0f],
      [self.MXMLogo.widthAnchor constraintEqualToConstant:78.0f],
      [self.MXMLogo.heightAnchor constraintEqualToConstant:14.0f],
      [self.MXMLogo.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor constant:10.0f],
      [self.MXMLogo.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-10.0f],
      [self.buildingSelectButton.widthAnchor constraintEqualToConstant:50.0f],
      [self.buildingSelectButton.heightAnchor constraintEqualToConstant:50.0f],
      [self.buildingSelectButton.centerXAnchor constraintLessThanOrEqualToAnchor:self.floorBar.centerXAnchor],
      [self.buildingSelectButton.bottomAnchor constraintEqualToAnchor:self.floorBar.topAnchor constant:-4],
      [self.floorBar.widthAnchor constraintEqualToConstant:42],
      [self.floorBar.heightAnchor constraintEqualToConstant:200.0f],
      floorBarXLc,
      floorBarYLc];
    
    [NSLayoutConstraint activateConstraints:layouts];
    
    
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
    for (UIGestureRecognizer *gestureRecognizer in self.mapView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *gest = (UITapGestureRecognizer *)gestureRecognizer;
            if (gest.numberOfTapsRequired == 2) {
                [tap requireGestureRecognizerToFail:gest];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.floorBar]) {
        return NO;
    }
    return YES;
}

- (UIButton *)buildingSelectButton
{
    if (!_buildingSelectButton) {
        _buildingSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buildingSelectButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSBundle *bundle = [NSBundle bundleForClass:[MapxusMap class]];
        UIImage *image = [UIImage imageNamed:@"selectBuilding" inBundle:bundle compatibleWithTraitCollection:nil];
        [_buildingSelectButton setImage:image forState:UIControlStateNormal];
        [_buildingSelectButton addTarget:self action:@selector(selectBuildingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buildingSelectButton.hidden = YES;
    }
    return _buildingSelectButton;
}

- (MXMFloorSelectorBar *)floorBar
{
    if (!_floorBar) {
        _floorBar = [[MXMFloorSelectorBar alloc] init];
        _floorBar.translatesAutoresizingMaskIntoConstraints = NO;
        _floorBar.delegate = self;
        _floorBar.hidden = YES;
    }
    return _floorBar;
}

- (NSDictionary<NSString *,MXMGeoBuilding *> *)buildings {
    if (!_buildings) {
        _buildings = [NSDictionary dictionary];
    }
    return _buildings;
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
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Mapxus Maps SDK for iOS" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *fristAction = [UIAlertAction actionWithTitle:@"© Mapxus" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mapxus.com"]];
    }];
    [alertCtrl addAction:fristAction];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"© OpenStreeMap" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/about/"]];
    }];
    [alertCtrl addAction:secondAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [viewController presentViewController:alertCtrl animated:YES completion:nil];
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

- (void)dealloc
{
    // 清除mapView对self的引用
    _mapView.mxmMap = nil;
    _mapView = nil;
}


@end







