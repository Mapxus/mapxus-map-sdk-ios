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
            [weakSelf.mapView setCenterCoordinate:centerPoint zoomLevel:19 animated:NO];
            [weakSelf.decider specifyTheBuilding:buildingId floor:floor shouldZoomTo:NO shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
        };
        [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
    } else if (_configuration.buildingId) {
        [self.decider specifyTheBuilding:_configuration.buildingId floor:_configuration.floor shouldZoomTo:YES shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
    }
}

- (void)setIndoorControllerAlwaysHidden:(BOOL)indoorControllerAlwaysHidden
{
    _indoorControllerAlwaysHidden = indoorControllerAlwaysHidden;
    [self.decider decideInRectBuildingDic:self.buildings];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
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
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
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
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v3/style/mapxus_v4", MXMBRMHOSTURL]];
                break;
            default:
                break;
        }
    }];
}


#pragma mark - 手势响应

- (void)automaticAnalyseOfIndoorData
{
    self.regionBecomeIdle = NO;
    [self idleAutomaticAnalyseOfIndoorData];
}

- (void)idleAutomaticAnalyseOfIndoorData
{
    // 整屏可见建筑列表
    self.buildings = [self.dataQueryer findOutBuildingInTheRect:self.mapView.bounds];
    
    CGSize mapSize = self.mapView.bounds.size;
    CGRect rect = CGRectMake(mapSize.width/4, mapSize.height/4, mapSize.width/2, mapSize.height/2);
    // 自动选择使用列表
    self.innerbuildings = [self.dataQueryer findOutBuildingInTheRect:rect];
    
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
    NSString *floor = [feature attributeForKey:@"floor"];
    NSString *buildingId = [feature attributeForKey:@"ref:building"];
    MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
    }
    /////////////////////////////////////////////////////
    // 切换建筑
    NSDictionary *poiBuildings = [self.dataQueryer findOutBuildingAtPoint:point];
    [self.decider decideAtPointBuildingDic:poiBuildings];
    // 查找点击的POI
    [self findOutPOIAtPoint:point coordinate:coor];
}

// 长按手势响应
- (void)longPressAction:(id)sender
{
    // 转换坐标
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    // 查找长按楼层
    /////////////////////////////////////////////////////
    NSArray<id <MGLFeature>> *theFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
    id<MGLFeature> feature = theFeatures.firstObject;
    NSString *floor = [feature attributeForKey:@"floor"];
    NSString *buildingId = [feature attributeForKey:@"ref:building"];
    MXMGeoBuilding *pointBuilding = self.buildings[buildingId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didLongPressedAtCoordinate:coor onFloor:floor inBuilding:pointBuilding];
    }
    /////////////////////////////////////////////////////
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - MXMDeciderDelegate

- (void)decideMapViewChangeBuilding:(nonnull MXMGeoBuilding *)building floor:(nonnull NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
    if (changeTrackingMode && (self.mapView.userTrackingMode != MGLUserTrackingModeNone)) {
        [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
    } else {
        if (![self.userLocationFloor isEqualToString:floor]) {
            self.userLocationFloor = floor;
        }
        if (![self.userLocationBuilding.identifier isEqualToString:building.identifier]) {
            self.userLocationBuilding = building;
        }
    }
    self.building = building;
    self.floor = floor;
    [self.floorBar resetItems:building.floors defaultSelectRow:floor];
    self.decider.isMapReload = NO;

    // 配置过滤条件
    [self.mapView.style filerBuildingId:building.identifier Floor:floor];
    // 回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
        [self.delegate mapView:self didChangeFloor:floor atBuilding:building];
    }
    [self updageLocationView];
}

- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox
{
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(bbox.min_latitude, bbox.min_longitude), CLLocationCoordinate2DMake(bbox.max_latitude, bbox.max_longitude));
    [self.mapView setVisibleCoordinateBounds:bounds animated:NO];
}

- (void)decideMapViewShowFloorBar:(BOOL)show onBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    // 设置建筑选择按钮和楼层选择按钮是否显示
    self.buildingSelectButton.hidden = self.indoorControllerAlwaysHidden || !((self.innerbuildings.count>=2)&&(self.mapView.zoomLevel>15.7));
    self.floorBar.hidden = self.indoorControllerAlwaysHidden || !(show&&(self.mapView.zoomLevel>15.7));
    self.isIndoor = !self.floorBar.isHidden;
    [self.annHolder filterMXMAnnotationsWithBuilding:buildingId floor:floor indoorState:self.isIndoor];
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
    [self selectBuilding:b.identifier shouldZoomTo:NO];
}

- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName
{
    [self selectBuilding:self.building.identifier floor:floorName shouldZoomTo:NO];
}

#pragma mark - 建筑筛选

- (void)selectFloor:(NSString *)floor
{
    [self.decider specifyTheBuilding:self.building.identifier floor:floor shouldZoomTo:YES shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
}

- (void)selectFloor:(NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:self.building.identifier floor:floor shouldZoomTo:zoomTo shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId
{
    [self.decider specifyTheBuilding:buildingId floor:nil shouldZoomTo:YES shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(NSString *)buildingId shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:buildingId floor:nil shouldZoomTo:zoomTo shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    [self.decider specifyTheBuilding:buildingId floor:floor shouldZoomTo:YES shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo
{
    [self.decider specifyTheBuilding:buildingId floor:floor shouldZoomTo:zoomTo shouldChangeTrackingMode:YES withRectBuildingDic:self.buildings];

}


#pragma mark - private

// 查找指定点的POI信息
- (void)findOutPOIAtPoint:(CGPoint)point coordinate:(CLLocationCoordinate2D)coor
{
    NSDictionary *poiDic = [self.dataQueryer findOutPOIAtPoint:point coordinate:coor];
    NSArray *poiList = [poiDic allValues];
    MXMGeoPOI *poi = poiList.firstObject;
    if (poi && self.delegate && [self.delegate respondsToSelector:@selector(mapView:didTappedOnPOI:)]) {
        [self.delegate mapView:self didTappedOnPOI:poi];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"floor"]) {
        [self.annHolder filterMXMAnnotationsWithBuilding:self.building.identifier floor:self.floor indoorState:self.isIndoor];
    }
}

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.annHolder addMXMPointAnnotations:annotations];
    [self.annHolder filterMXMAnnotationsWithBuilding:self.building.identifier floor:self.floor indoorState:self.isIndoor];
    for (MXMPointAnnotation *a in annotations) {
        [a addObserver:self forKeyPath:@"floor" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.annHolder removeMXMPointAnnotaions:annotations];
    for (MXMPointAnnotation *a in annotations) {
        [a removeObserver:self forKeyPath:@"floor"];
    }
}




#pragma mark - access

- (void)commonInit
{
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
    [self.mapView addSubview:self.buildingSelectButton];
    NSLayoutConstraint *buiSelLeftLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
    buiSelLeftLc.identifier = @"buildingBtnXLc";
    [self.mapView addConstraint:buiSelLeftLc];
    NSLayoutConstraint *buiSelBottomLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.floorBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:-4];
    [self.mapView addConstraint:buiSelBottomLc];
    NSLayoutConstraint *buiSelWLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectButton addConstraint:buiSelWLc];
    NSLayoutConstraint *buiSelHLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectButton addConstraint:buiSelHLc];
    
    
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

- (void)dealloc
{
    // 清除mapView对self的引用
    _mapView.mxmMap = nil;
    _mapView = nil;
    // 清除监听
    for (MXMPointAnnotation *a in self.annHolder.mxmPointAnnotations) {
        [a removeObserver:self forKeyPath:@"floor"];
    }
}


@end







