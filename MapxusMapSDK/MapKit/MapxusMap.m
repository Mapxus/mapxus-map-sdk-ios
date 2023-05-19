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
#import "MXMAlertController.h"

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
    
    self.floorIds = [NSSet set];
    self.decider = [[MXMDecider alloc] initWithDelegate:self];
    self.dataQueryer = [[MXMDataQuerier alloc] initWithMapView:mapView];
    self.annHolder = [[MXMAnnotationsHolder alloc] initWithMapView:mapView];
    self.cacheManager = [[MXMCacheManager alloc] init];
    
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
    if (configuration.defaultStyleName) {
      [self setMapStyleWithName:configuration.defaultStyleName];
    } else {
      [self setMapSytle:configuration.defaultStyle];
    }
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
      
      MXMGeoBuilding *building;
      MXMGeoVenue *venue;
      if (buildingId) {
        building = strongSelf.buildings[buildingId];
      }
      if (building) {
        venue = strongSelf.venues[building.venueId];
      }
      
      [strongSelf.decider specifyTheBuilding:buildingId
                                       floor:floor
                                     ordinal:nil
                                    zoomMode:MXMZoomDisable
                                 edgePadding:UIEdgeInsetsZero
                    shouldChangeTrackingMode:YES
                             withGeoBuilding:building];
      
    };
    [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
  } else if (_configuration.buildingId) {
    
    MXMGeoBuilding *building;
    MXMGeoVenue *venue;
    if (_configuration.buildingId) {
      building = self.buildings[_configuration.buildingId];
    }
    if (building) {
      venue = self.venues[building.venueId];
    }
    
    [self.decider specifyTheBuilding:_configuration.buildingId
                               floor:_configuration.floor
                             ordinal:nil
                            zoomMode:MXMZoomDirect
                         edgePadding:_configuration.zoomInsets
            shouldChangeTrackingMode:YES
                     withGeoBuilding:building];
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
        [self setMapStyleWithName:@"common_mims2_v1"];
        break;
      case MXMStyleCHRISTMAS:
        [self setMapStyleWithName:@"christmas_mims2_v1"];
        break;
      case MXMStyleHALLOWMAS:
        [self setMapStyleWithName:@"halloween_mims2_v1"];
        break;
      case MXMStyleMAPPYBEE:
        [self setMapStyleWithName:@"mappybee_mims2_v2"];
        break;
      case MXMStyleMAPXUS:
        [self setMapStyleWithName:@"mapxus_mims2_v4"];
        break;
      default:
        break;
    }
  }];
}

- (void)setMapStyleWithName:(NSString *)styleName {
  self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/bms/api/v3/tiles/styles/%@", MXMAPIHOSTURL, styleName]];
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
    [self.decider specifyTheBuilding:self.building.identifier
                               floor:self.floor
                             ordinal:self.ordinal
                            zoomMode:MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:NO
                     withGeoBuilding:self.building];
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
  /////////////////////////////////////////////////////
  if (self.gestureSwitchingBuilding) {
    // 切换建筑
    /// 点上找到的level信息
    NSArray<MXMLevelModel *> *floorFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
    /// 点上找到的building信息
    NSDictionary *pointBuildings = [self.dataQueryer findOutBuildingAtPoint:point];
    /// 通过相关逻辑判断建筑的切换结果
    [self.decider decideAtPointWithBuildingDic:pointBuildings
                              andFloorFeatures:floorFeatures];
  }
  // 查找点击楼层
  /////////////////////////////////////////////////////
  if (self.delegate &&
      ([self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:)] ||
       [self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:)])) {
    // 非点击POI
    NSArray<MXMLevelModel *> *theFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
    MXMLevelModel *feature = theFeatures.firstObject;
    
    NSString *floor = feature.name;
    NSString *floorId = feature.levelId;
    NSNumber *floorOrdinal = feature.ordinal;
    NSString *buildingId = feature.refBuildingId;
    
    MXMGeoBuilding *pointBuilding = [self.buildings[buildingId] copy];
    
    // 点击了POI
    MXMFloor *floorModel = [[MXMFloor alloc] init];
    floorModel.floorId = floorId;
    floorModel.code = floor;
    if (floorOrdinal) {
      MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
      ordinal.level = [floorOrdinal integerValue];
      floorModel.ordinal = ordinal;
    }
    
    NSDictionary *poiDic = [self.dataQueryer findOutPOIAtPoint:point];
    NSArray *poiList = [poiDic allValues];
    MXMGeoPOI *poi = [poiList.firstObject copy];
    poi.floor = floorModel;
    if (poi) {
      if (self.delegate &&
          [self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedOnPOI:poi atCoordinate:coor onFloor:floor inBuilding:pointBuilding];
      }
    } else {
      if (self.delegate &&
          [self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedOnMapBlank:coor onFloor:floor inBuilding:pointBuilding];
      }
    }
    
  } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
    [self.delegate mapView:self didSingleTappedAtCoordinate:coor];
    
  }
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
      NSArray<MXMLevelModel *> *theFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point];
      MXMLevelModel *feature = theFeatures.firstObject;
      NSString *floor = feature.name;
      NSString *buildingId = feature.refBuildingId;
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
  [self.decider specifyTheBuilding:self.building.identifier
                             floor:self.floor
                           ordinal:self.ordinal
                          zoomMode:MXMZoomDisable
                       edgePadding:UIEdgeInsetsZero
          shouldChangeTrackingMode:NO
                   withGeoBuilding:self.building];
}

- (void)decideMapViewShowFloorBar:(BOOL)show onBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
  // 设置建筑选择按钮和楼层选择按钮是否显示
  self.isIndoor = show && (self.mapView.zoomLevel>15.7) && self.buildings[buildingId];
  self.buildingSelectButton.hidden = self.indoorControllerAlwaysHidden || !((self.buildings.count>=2)&&(self.mapView.zoomLevel>15.7));
  self.floorBar.hidden = self.indoorControllerAlwaysHidden || !self.isIndoor;
  if (self.delegate && [self.delegate respondsToSelector: @selector(mapView:indoorMapWithIn:building:floor:)]) {
    [self.delegate mapView:self indoorMapWithIn:self.isIndoor building:buildingId floor:floor];
  }
}

- (void)decideMapViewShouldChangeBuilding:(nullable MXMGeoBuilding *)building floor:(nullable NSString *)floor shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  [self.mapView.style updateBuildingFillOpacityWithIndoorState:self.isIndoor refVenue:building.venueId];
  if (changeTrackingMode && (self.mapView.userTrackingMode != MGLUserTrackingModeNone)) {
    // 设为定位非追踪模式
    [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
  }
  // 重新过滤标注点
  [self.annHolder filterMXMAnnotationsWithBuilding:building.identifier floor:floor indoorState:self.isIndoor];
}

- (void)decideMapViewChangeBuilding:(nullable MXMGeoBuilding *)building floorOrdinal:(nullable MXMOrdinal *)floorOrdinal trackingMode:(BOOL)changeTrackingMode shouldCallBack:(BOOL)shouldCallBack
{
  // 转换成building上的code
  MXMFloor *floor;
  if (floorOrdinal) {
    NSArray *floors = building.floors;
    for (MXMFloor *iFloor in floors) {
      if (iFloor.ordinal && iFloor.ordinal.level == floorOrdinal.level) {
        floor = iFloor;
        break;
      }
    }
  }
  
  if (shouldCallBack) {
    self.building = building;
    self.floor = floor.code;
    self.ordinal = floor.ordinal;
    // 绘制选中边框
    [self.mapView.style outLineLevel:floor.floorId];
    // 数据中的楼层都是从小到大，需要颠倒顺序显示
    if (building && floor) {
      NSArray *reversalFloors = [[building.floors reverseObjectEnumerator] allObjects];
      [self.floorBar resetItems:reversalFloors defaultSelectRow:floor];
    }
  }
  
  // 配置过滤条件
  NSMutableArray *levelIds = [NSMutableArray array];
//  NSMutableArray *sameVenueLevelIds = [NSMutableArray array];

  for (MXMGeoBuilding *buildingItem in self.buildings.allValues) {
    if ([buildingItem.venueId isEqualToString:building.venueId]) {
      // 已选中venue的建筑
      for (MXMFloor *floorItem in buildingItem.floors) {
        if (floorItem.ordinal && floorItem.ordinal.level == floorOrdinal.level) {
          [levelIds addObject:floorItem.floorId];
//          [sameVenueLevelIds addObject:floorItem.floorId];
          break;
        }
      }
      
    } else {
      // 未选中venue的建筑
      MXMOrdinal *ordianl = [self.decider electDefaultFloorWithHistory:self.decider.venueSelectFloorDic
                                                            inBuilding:buildingItem];
      for (MXMFloor *floorItem in buildingItem.floors) {
        if (floorItem.ordinal && floorItem.ordinal.level == ordianl.level) {
          [levelIds addObject:floorItem.floorId];
        }
      }
      
    }
  }
  NSSet *levelIdSet = [NSSet setWithArray:levelIds];
  if (levelIdSet.count == 0 || ![levelIdSet isSubsetOfSet:self.floorIds] || self.decider.isMapReload) {
    [self.mapView.style filerLevelIds:levelIds];
  }
//  [self.mapView.style setLevelIdsTransparent:sameVenueLevelIds];
  
  self.floorIds = levelIdSet;
  self.decider.isMapReload = NO;
  // 回调
  if (shouldCallBack) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
      [self.delegate mapView:self didChangeFloor:floor.code atBuilding:building];
    }
    [self updageLocationView];
  }
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
  for (MXMGeoBuilding *b in [self.buildings allValues]) {
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
  MXMGeoBuilding *b = [self.buildings objectForKey:sender.identifier];
  [self selectBuilding:b.identifier zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

- (void)floorSelectorBarDidSelectFloor:(MXMFloor *)floor
{
  [self.decider specifyTheBuilding:self.building.identifier
                             floor:floor.code
                           ordinal:floor.ordinal
                          zoomMode:MXMZoomDisable
                       edgePadding:UIEdgeInsetsZero
          shouldChangeTrackingMode:YES
                   withGeoBuilding:self.building];
}

#pragma mark - 建筑筛选

- (void)selectFloor:(NSString *)floor
{
  [self.decider specifyTheBuilding:self.building.identifier
                             floor:floor
                           ordinal:nil
                          zoomMode:MXMZoomAnimated
                       edgePadding:UIEdgeInsetsZero
          shouldChangeTrackingMode:YES
                   withGeoBuilding:self.building];
}

- (void)selectFloor:(NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets
{
  [self.decider specifyTheBuilding:self.building.identifier
                             floor:floor
                           ordinal:nil
                          zoomMode:zoomMode
                       edgePadding:insets
          shouldChangeTrackingMode:YES
                   withGeoBuilding:self.building];
}

- (void)selectBuilding:(NSString *)buildingId
{
  MXMGeoBuilding *building;
  if (buildingId) {
    building = self.buildings[buildingId];
  }
  [self.decider specifyTheBuilding:buildingId
                             floor:nil
                           ordinal:nil
                          zoomMode:MXMZoomAnimated
                       edgePadding:UIEdgeInsetsZero
          shouldChangeTrackingMode:YES
                   withGeoBuilding:building];
}

- (void)selectBuilding:(NSString *)buildingId zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets
{
  MXMGeoBuilding *building;
  if (buildingId) {
    building = self.buildings[buildingId];
  }
  [self.decider specifyTheBuilding:buildingId
                             floor:nil
                           ordinal:nil
                          zoomMode:zoomMode
                       edgePadding:insets
          shouldChangeTrackingMode:YES
                   withGeoBuilding:building];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
  MXMGeoBuilding *building;
  if (buildingId) {
    building = self.buildings[buildingId];
  }
  [self.decider specifyTheBuilding:buildingId
                             floor:floor
                           ordinal:nil
                          zoomMode:MXMZoomAnimated
                       edgePadding:UIEdgeInsetsZero
          shouldChangeTrackingMode:YES
                   withGeoBuilding:building];
}

- (void)selectBuilding:(NSString *)buildingId floor:(NSString *)floor zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets
{
  MXMGeoBuilding *building;
  if (buildingId) {
    building = self.buildings[buildingId];
  }
  [self.decider specifyTheBuilding:buildingId
                             floor:floor
                           ordinal:nil
                          zoomMode:zoomMode
                       edgePadding:insets
          shouldChangeTrackingMode:YES
                   withGeoBuilding:building];
}


#pragma mark - private

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
  _logoBottomMargin = 10.0f;
  _openStreetSourceBottomMargin = 10.0f;
  
  [self.mapView addSubview:self.openStreetSourceBtn];
  [self.mapView addSubview:self.MXMLogo];
  [self.mapView addSubview:self.buildingSelectButton];
  [self.mapView addSubview:self.floorBar];
  // 添加楼层选择栏与约束
  NSLayoutConstraint *floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:self.mapView.leftAnchor constant:31.0f];
  floorBarXLc.identifier = @"floorBarXLc";
  NSLayoutConstraint * floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:self.mapView.centerYAnchor constant:30];
  floorBarYLc.identifier = @"floorBarYLc";
  
  NSLayoutConstraint *btnSpaceLc = [self.openStreetSourceBtn.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.MXMLogo.trailingAnchor constant:10.0f];
  btnSpaceLc.priority = UILayoutPriorityDefaultHigh;
  [self.openStreetSourceBtn setContentCompressionResistancePriority:UILayoutPriorityDragThatCanResizeScene forAxis:UILayoutConstraintAxisHorizontal];
  
  NSLayoutConstraint *openStreetBottom = [self.openStreetSourceBtn.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-_openStreetSourceBottomMargin];
  openStreetBottom.identifier = @"openStreetBottom";
  
  NSLayoutConstraint *logoBottom = [self.MXMLogo.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-_logoBottomMargin];
  logoBottom.identifier = @"logoBottom";
  
  NSArray *layouts = @[btnSpaceLc,
                       [self.openStreetSourceBtn.heightAnchor constraintEqualToConstant:13.0f],
                       [self.openStreetSourceBtn.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor constant:-10.0f],
                       openStreetBottom,
//                       [self.MXMLogo.widthAnchor constraintEqualToConstant:76.0f],
//                       [self.MXMLogo.heightAnchor constraintEqualToConstant:20.0f],
                       [self.MXMLogo.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor constant:10.0f],
                       logoBottom,
                       [self.buildingSelectButton.widthAnchor constraintEqualToConstant:50.0f],
                       [self.buildingSelectButton.heightAnchor constraintEqualToConstant:50.0f],
                       [self.buildingSelectButton.centerXAnchor constraintEqualToAnchor:self.floorBar.centerXAnchor],
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

- (void)setLogoBottomMargin:(CGFloat)logoBottomMargin {
  _logoBottomMargin = fmaxf(logoBottomMargin, 0);
  NSLayoutConstraint *t = [self _constraintWithIndientifer:@"logoBottom" InView:self.mapView];
  t.constant = -_logoBottomMargin;
  [self.mapView layoutIfNeeded];
}

- (void)setOpenStreetSourceBottomMargin:(CGFloat)openStreetSourceBottomMargin {
  _openStreetSourceBottomMargin = fmaxf(openStreetSourceBottomMargin, 0);
  NSLayoutConstraint *t = [self _constraintWithIndientifer:@"openStreetBottom" InView:self.mapView];
  t.constant = -_openStreetSourceBottomMargin;
  [self.mapView layoutIfNeeded];
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

- (NSDictionary<NSString *,MXMGeoVenue *> *)venues {
  if (!_venues) {
    _venues = [NSDictionary dictionary];
  }
  return _venues;
}

- (MXMLogoButton *)MXMLogo
{
  if (!_MXMLogo) {
    _MXMLogo = [[MXMLogoButton alloc] initWithCopyright:self.collapseCopyright];
    _MXMLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [_MXMLogo addTarget:self action:@selector(logoOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _MXMLogo;
}

- (void)setCollapseCopyright:(BOOL)collapseCopyright {
  _collapseCopyright = collapseCopyright;
  self.MXMLogo.collapseCopyright = collapseCopyright;
  self.openStreetSourceBtn.hidden = collapseCopyright;
}

- (void)logoOnClickAction:(UIButton *)sender
{
  if (self.collapseCopyright) {
    [MXMAlertController presentAlert];
  } else {
    if (@available(iOS 10.0, *)) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MAPXUS_COPYRIGHT_URL] options:@{} completionHandler:nil];
    } else {
      // Fallback on earlier versions
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MAPXUS_COPYRIGHT_URL]];
    }
  }
}

- (UIButton *)openStreetSourceBtn
{
  if (!_openStreetSourceBtn) {
    _openStreetSourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _openStreetSourceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _openStreetSourceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _openStreetSourceBtn.backgroundColor = [UIColor clearColor];
    _openStreetSourceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_openStreetSourceBtn setTitleColor:[UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1] forState:UIControlStateNormal];
    [_openStreetSourceBtn setTitle:SOURCE_COPYRIGHT_TITLE forState:UIControlStateNormal];
    [_openStreetSourceBtn addTarget:self action:@selector(showOpenStreeSourceWeb) forControlEvents:UIControlEventTouchUpInside];
  }
  return _openStreetSourceBtn;
}

- (void)showOpenStreeSourceWeb
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SOURCE_COPYRIGHT_URL]];
}

- (void)dealloc
{
  // 清除mapView对self的引用
  _mapView.mxmMap = nil;
  _mapView = nil;
}


@end







