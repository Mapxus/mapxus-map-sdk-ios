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
#import "MGLMapView+MXMSwizzle.h"
#import "MXMPointAnnotation+Private.h"
#import "MGLStyle+MXMFilter.h"
#import "MGLStyleLayer+MXMFilter.h"
#import "JXJsonFunctionDefine.h"
#import "MXMAlertController.h"
#import "UIImage+MXMSdk.h"
#import "MXMFloorBarModel.h"
#import "MapxusMapDelegate.h"
#import "KxMenu.h"
#import "MXMSearchPOIOperation.h"
#import "NSObject+MXMThrottle.h"

@implementation MapxusMap

// 禁止通过KVO修改只读属性
+ (BOOL)accessInstanceVariablesDirectly {
  return NO;
}

#pragma mark - init

- (instancetype)initWithMapView:(MGLMapView *)mapView
{
  return [self initWithMapView:mapView configuration:nil];
}

- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration
{
  self = [super init];
  if (self) {
    _mapView = mapView;
    _mapView.mxmMap = self;
    _mapView.attributionButton.hidden = YES;
    _mapView.logoView.hidden = YES;
    
    [self initLayout];
    [self addGesture];
    
    // 属性初始化
    _isFristLoad = YES;
    self.indoorControllerAlwaysHidden = NO;
    self.selectorPosition = MXMSelectorPositionCenterLeft;
    self.logoBottomMargin = 10.0f;
    self.openStreetSourceBottomMargin = 10.0f;
    self.collapseCopyright = NO;
    self.selectedBuildingBorderStyle = nil;
    self.outdoorHidden = NO;
    self.gestureSwitchingBuilding = YES;
    self.autoChangeBuilding = YES;
    self.floorSwitchMode = MXMSwitchedByVenue;
    self.maskNonSelectedSite = NO;

    _decider = [[MXMDecider alloc] initWithDelegate:self];
    _dataQueryer = [[MXMDataQuerier alloc] initWithMapView:mapView];
    _annHolder = [[MXMAnnotationsHolder alloc] initWithMapView:mapView];
    _cacheManager = [[MXMCacheManager alloc] init];
    _initializeQueue = [[NSOperationQueue alloc] init];
    
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

- (void)initLayout
{
  [_mapView addSubview:self.openStreetSourceBtn];
  [_mapView addSubview:self.MXMLogo];
  [_mapView addSubview:self.buildingSelectButton];
  [_mapView addSubview:self.floorBar];
  
  // 添加楼层选择栏与约束
  NSLayoutConstraint *floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.leftAnchor constant:31.0f];
  floorBarXLc.identifier = @"floorBarXLc";
  NSLayoutConstraint * floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:_mapView.centerYAnchor constant:30];
  floorBarYLc.identifier = @"floorBarYLc";
  
  NSLayoutConstraint *btnSpaceLc = [self.openStreetSourceBtn.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.MXMLogo.trailingAnchor constant:10.0f];
  btnSpaceLc.priority = UILayoutPriorityDefaultHigh;
  [self.openStreetSourceBtn setContentCompressionResistancePriority:UILayoutPriorityDragThatCanResizeScene forAxis:UILayoutConstraintAxisHorizontal];
  
  NSLayoutConstraint *openStreetBottom = [self.openStreetSourceBtn.bottomAnchor constraintEqualToAnchor:_mapView.bottomAnchor constant:-_openStreetSourceBottomMargin];
  openStreetBottom.identifier = @"openStreetBottom";
  
  NSLayoutConstraint *logoBottom = [self.MXMLogo.bottomAnchor constraintEqualToAnchor:_mapView.bottomAnchor constant:-_logoBottomMargin];
  logoBottom.identifier = @"logoBottom";
  
  NSArray *layouts = @[
    btnSpaceLc,
    [self.openStreetSourceBtn.heightAnchor constraintEqualToConstant:13.0f],
    [self.openStreetSourceBtn.trailingAnchor constraintEqualToAnchor:_mapView.trailingAnchor constant:-10.0f],
    openStreetBottom,
    [self.MXMLogo.leadingAnchor constraintEqualToAnchor:_mapView.leadingAnchor constant:10.0f],
    logoBottom,
    [self.buildingSelectButton.widthAnchor constraintEqualToConstant:50.0f],
    [self.buildingSelectButton.heightAnchor constraintEqualToConstant:50.0f],
    [self.buildingSelectButton.centerXAnchor constraintEqualToAnchor:self.floorBar.centerXAnchor],
    [self.buildingSelectButton.bottomAnchor constraintEqualToAnchor:self.floorBar.topAnchor constant:-4],
    floorBarXLc,
    floorBarYLc,
  ];
  [NSLayoutConstraint activateConstraints:layouts];
}

- (void)addGesture {
  // 添加单击手势
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToDo:)];
  tap.delegate = self;
  [_mapView addGestureRecognizer:tap];
  // 添加长按手势
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
  longPress.minimumPressDuration = 0.8;
  longPress.delegate = self;
  [_mapView addGestureRecognizer:longPress];
  // 长按失败才检测单击事件
  [tap requireGestureRecognizerToFail:longPress];
  for (UIGestureRecognizer *gestureRecognizer in _mapView.gestureRecognizers) {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
      UITapGestureRecognizer *gest = (UITapGestureRecognizer *)gestureRecognizer;
      if (gest.numberOfTapsRequired == 2) {
        [tap requireGestureRecognizerToFail:gest];
      }
    }
  }
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
    searchPoiOp.complateBlock = ^(NSString * _Nonnull floorId, CLLocationCoordinate2D centerPoint) {
      __strong typeof(weakSelf) strongSelf = weakSelf;
      [strongSelf->_mapView setCenterCoordinate:centerPoint zoomLevel:strongSelf->_configuration.zoomLevel animated:NO];
      [strongSelf.decider specifyTheFloorId:floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero shouldChangeTrackingMode:YES];
    };
    [_initializeQueue addOperations:@[searchPoiOp] waitUntilFinished:NO];
  } else if (_configuration.floorId) {
    [self.decider specifyTheFloorId:_configuration.floorId zoomMode:MXMZoomDirect edgePadding:_configuration.zoomInsets shouldChangeTrackingMode:YES];
  } else if (_configuration.buildingId) {
    if (_configuration.floor) {
      // TODO: 删除
      MXMGeoBuilding *building;
      building = self.decider.visibleBuildings[_configuration.buildingId];
      [self.decider specifyTheBuilding:_configuration.buildingId
                             floorCode:_configuration.floor
                               ordinal:nil
                              zoomMode:MXMZoomDirect
                           edgePadding:_configuration.zoomInsets
              shouldChangeTrackingMode:YES
                       withGeoBuilding:building];
    } else {
      [self.decider specifyTheBuildingId:_configuration.buildingId zoomMode:MXMZoomDirect edgePadding:_configuration.zoomInsets shouldChangeTrackingMode:YES];
    }
  } else if (_configuration.venueId) {
    [self.decider specifyTheVenueId:_configuration.venueId zoomMode:MXMZoomDirect edgePadding:_configuration.zoomInsets shouldChangeTrackingMode:YES];
  }
}


#pragma mark - 手势响应

- (void)automaticAnalyseOfIndoorData
{
  if (_mapView.userTrackingMode != MGLUserTrackingModeFollowWithHeading) {
    [self _automaticAnalyseOfIndoorData];
  } else {
    [self mxm_performSelector:@selector(_automaticAnalyseOfIndoorData) withThrottle:0.5];
  }
}

- (void)_automaticAnalyseOfIndoorData {
  _regionBecomeIdle = NO;
  [self idleAutomaticAnalyseOfIndoorData];
}

- (void)idleAutomaticAnalyseOfIndoorData
{
  // visibleBuildings 在创建对象时需要用到 visibleVenues 的数据，所以需要先生成 venue 数据
  self.decider.visibleVenues = [self.dataQueryer findOutVenueInTheRect:_mapView.bounds];
  self.decider.visibleBuildings = [self.dataQueryer findOutBuildingInTheRect:_mapView.bounds];
  //  self.decider.visibleFloors = [self.dataQueryer findOutFloorInTheRect:_mapView.bounds];
  
  // 整屏可见建筑列表，无论是否需要自动选择建筑功能，buildings 都需要对外放出值
  _buildings = [self.decider.visibleBuildings mutableCopy];
  _venues = [self.decider.visibleVenues mutableCopy];
  
  // 正在赶路，不用分析沿路建筑
  if (self.flying) {
    return;
  }
    
  if (!self.autoChangeBuilding) {
    // TODO: 因为找不到选中建筑也需要重置一次，如果已选中floor在屏外，会导致无用的floorId search building接口调用，需要进行优化。使用新接口
    //    [self.decider specifyTheFloorId:self.decider.selectedFloor.floorId zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero shouldChangeTrackingMode:NO];
    [self.decider specifyTheBuilding:self.selectedBuildingId
                           floorCode:self.selectedFloor.code
                             ordinal:self.selectedFloor.ordinal
                            zoomMode:MXMZoomDisable
                         edgePadding:UIEdgeInsetsZero
            shouldChangeTrackingMode:NO
                     withGeoBuilding:self.building];
    return;
  }
  
  CGSize mapSize = _mapView.bounds.size;
  CGRect rect = CGRectMake(mapSize.width/4, mapSize.height/4, mapSize.width/2, mapSize.height/2);
  // 自动选择使用列表，如果不需要自动选择建筑功能，innerbuildings 就不需要有值，
  _innerbuildings = [self.dataQueryer findOutBuildingInTheRect:rect];
  [self.decider decideInRectWithBuildingDic:_innerbuildings];
}

// 单击手势响应
- (void)singleTapToDo:(id)sender
{
  // 转换坐标
  CGPoint point = [sender locationInView:_mapView];
  CLLocationCoordinate2D coor = [_mapView convertPoint:point toCoordinateFromView:_mapView];
  
  // 获取点击位置的楼层信息
  NSArray<MXMLevelModel *> *floorFeatures = nil;
  
  BOOL hasSiteRetureMethods = self.delegate && (
                                                [self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:)] ||
                                                [self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:)] ||
                                                [self.delegate respondsToSelector:@selector(map:didSingleTapOnPOI:atCoordinate:atSite:)] ||
                                                [self.delegate respondsToSelector:@selector(map:didSingleTapOnBlank:atSite:)]
                                                );
  if (self.gestureSwitchingBuilding || hasSiteRetureMethods) {
    floorFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point pointCoordinate:coor];
  }
  
  /////////////////////////////////////////////////////
  if (self.gestureSwitchingBuilding) {
    // 切换建筑
    /// 点上找到的building信息
    NSDictionary *pointBuildings = [self.dataQueryer findOutBuildingAtPoint:point];
    /// 通过相关逻辑判断建筑的切换结果
    [self.decider decideAtPointWithBuildingDic:pointBuildings
                              andFloorFeatures:floorFeatures];
  }
  // 查找点击楼层
  /////////////////////////////////////////////////////
  if (hasSiteRetureMethods) {
    MXMLevelModel *firstFloor = floorFeatures.firstObject;
    MXMSite *site = [self createSiteUsingLevelModel:firstFloor];
    
    NSDictionary *poiDic = [self.dataQueryer findOutPOIAtPoint:point];
    NSArray *poiList = [poiDic allValues];
    MXMGeoPOI *poi = [poiList.firstObject copy];
    if (poi) {
      // 确保拿到正确的关联site
      site.building = [self.decider.visibleBuildings[poi.buildingId] copy];
      site.venue = [self.decider.visibleVenues[site.building.venueId] copy];
      for (MXMFloor *floorItem in site.building.floors) {
        if ([poi.floor.floorId isEqualToString:floorItem.floorId]) {
          site.floor = [floorItem copy];
          poi.floor = site.floor;
          break;
        }
      }
      if ([self.delegate respondsToSelector:@selector(map:didSingleTapOnPOI:atCoordinate:atSite:)]) {
        [self.delegate map:self didSingleTapOnPOI:poi atCoordinate:coor atSite:site];
      } else if ([self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedOnPOI:poi atCoordinate:coor onFloor:site.floor.code inBuilding:site.building];
      }
    } else {
      if ([self.delegate respondsToSelector:@selector(map:didSingleTapOnBlank:atSite:)]) {
        [self.delegate map:self didSingleTapOnBlank:coor atSite:site];
      } else if ([self.delegate respondsToSelector:@selector(mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:)]) {
        [self.delegate mapView:self didSingleTappedOnMapBlank:coor onFloor:site.floor.code inBuilding:site.building];
      }
    }
    
  } else if (self.delegate && [self.delegate respondsToSelector:@selector(map:didSingleTapAtCoordinate:)]) {
    [self.delegate map:self didSingleTapAtCoordinate:coor];
  } else if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
    [self.delegate mapView:self didSingleTappedAtCoordinate:coor];
  }
}

// 长按手势响应
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
  if (gesture.state == UIGestureRecognizerStateBegan) {
    // 转换坐标
    CGPoint point = [gesture locationInView:_mapView];
    CLLocationCoordinate2D coor = [_mapView convertPoint:point toCoordinateFromView:_mapView];
    // 查找长按楼层
    /////////////////////////////////////////////////////
    if (self.delegate) {
      
      if ([self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:onFloor:inBuilding:)] ||
          [self.delegate respondsToSelector:@selector(map:didLongPressAtCoordinate:atSite:)]) {
        
        NSArray<MXMLevelModel *> *floorFeatures = [self.dataQueryer findOutFloorFeaturesAtPoint:point pointCoordinate:coor];
        MXMLevelModel *firstFloor = floorFeatures.firstObject;
        MXMSite *site = [self createSiteUsingLevelModel:firstFloor];
        
        if ([self.delegate respondsToSelector:@selector(map:didLongPressAtCoordinate:atSite:)]) {
          [self.delegate map:self didLongPressAtCoordinate:coor atSite:site];
        } else if ([self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:onFloor:inBuilding:)]) {
          [self.delegate mapView:self didLongPressedAtCoordinate:coor onFloor:site.floor.code inBuilding:site.building];
        }
        
      } else if ([self.delegate respondsToSelector:@selector(map:didLongPressAtCoordinate:)]) {
        [self.delegate map:self didLongPressAtCoordinate:coor];
      } else if ([self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:)]) {
        [self.delegate mapView:self didLongPressedAtCoordinate:coor];
      }
    }
    /////////////////////////////////////////////////////
  }
}

- (MXMSite *)createSiteUsingLevelModel:(MXMLevelModel *)levelModel {
  MXMFloor *refFloor = nil;
  if (levelModel) {
    refFloor = [[MXMFloor alloc] init];
    refFloor.floorId = levelModel.levelId;
    refFloor.code = levelModel.name;
    refFloor.ordinal = levelModel.ordinal;
  }
  
  NSString *refBuildingId = levelModel.refBuildingId;
  MXMGeoBuilding *refBuilding = [self.decider.visibleBuildings[refBuildingId] copy];
  MXMGeoVenue *refVenue = [self.decider.visibleVenues[refBuilding.venueId] copy];
  
  MXMSite *site = [[MXMSite alloc] init];
  site.floor = refFloor;
  site.building = refBuilding;
  site.venue = refVenue;
  
  return site;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isDescendantOfView:self.floorBar]) {
    return NO;
  }
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return YES;
}
#pragma mark end


#pragma mark - MXMDeciderDelegate
- (void)decideMapViewShowFloorBar:(BOOL)show
                          atVenue:(nullable MXMGeoVenue *)venue
                       inBuilding:(nullable MXMGeoBuilding *)building
                            floor:(nullable MXMFloor *)floor
{
  // 设置建筑选择按钮和楼层选择按钮是否显示
  _isIndoor = show && (_mapView.zoomLevel>15.7) && self.decider.visibleBuildings[building.identifier];
  self.buildingSelectButton.hidden = self.indoorControllerAlwaysHidden || !((self.decider.visibleBuildings.count>=2)&&(_mapView.zoomLevel>15.7));
  self.floorBar.hidden = self.indoorControllerAlwaysHidden || !_isIndoor;
  if (self.delegate) {
    if ([self.delegate respondsToSelector:@selector(map:didChangeSelectedFloorVisualizationStatus:withSelectedFloor:selectedBuildingId:selectedVenueId:)]) {
      [self.delegate map:self
didChangeSelectedFloorVisualizationStatus:_isIndoor
       withSelectedFloor:[floor copy]
      selectedBuildingId:building.identifier
         selectedVenueId:building.venueId];
    } else if ([self.delegate respondsToSelector:@selector(map:didChangeIndoorSiteAccess:selectedFloor:selectedBuilding:selectedVenue:)]) {
      [self.delegate map:self
didChangeIndoorSiteAccess:_isIndoor
           selectedFloor:[floor copy]
        selectedBuilding:[building copy]
           selectedVenue:[venue copy]];
    } else if ([self.delegate respondsToSelector:@selector(mapView:indoorMapWithIn:building:floor:)]) {
      [self.delegate mapView:self
             indoorMapWithIn:_isIndoor
                    building:building.identifier
                       floor:floor.code];
    }
  }
}

- (void)decideMapViewShouldChangeBuilding:(nullable MXMGeoBuilding *)building
                                  atVenue:(nullable MXMGeoVenue *)venue
                                    floor:(nullable MXMFloor *)floor
                 shouldChangeTrackingMode:(BOOL)changeTrackingMode
{
  if (changeTrackingMode && (_mapView.userTrackingMode != MGLUserTrackingModeNone)) {
    // 设为定位非追踪模式
    [_mapView setUserTrackingMode:MGLUserTrackingModeNone];
  }
  // 重新过滤标注点
  [self.annHolder filterMXMAnnotationsWithBuilding:building.identifier
                                             floor:floor.code
                                           floorId:floor.floorId
                                       indoorState:_isIndoor];
}

- (void)decideMapViewChangeWithFilterModel:(MXMFilterModel *)filter {
  if (filter.shouldCallBack) {
    _floor = filter.selectedFloor.code;
    _building = filter.selectedBuilding;
    _selectedFloor = filter.selectedFloor;
    _selectedBuildingId = filter.selectedBuildingId;
    _selectedVenueId = filter.selectedVenueId;
    // 绘制选中边框
    [_mapView.style outLineLevel:filter.selectedFloor.floorId];
  }
  // 每过滤一次都要刷新一次floorBar，因为从网络请求的楼层可能不全。数据中的楼层都是从小到大，需要颠倒顺序显示
  MXMGeoBuilding *geoBuilding = filter.selectedBuildingId ? self.decider.visibleBuildings[filter.selectedBuildingId] : nil;
  if (geoBuilding && filter.selectedFloor) {
    NSArray *reversalFloors = [[geoBuilding.floors reverseObjectEnumerator] allObjects];
    if (![self.floorBar.refBuildingId isEqualToString:geoBuilding.identifier]) {
      NSMutableArray *list = [NSMutableArray array];
      for (MXMFloor *iFloor in reversalFloors) {
        MXMFloorBarModel *model = [[MXMFloorBarModel alloc] init];
        model.floor = iFloor;
        if ([filter.selectedFloor.floorId isEqualToString:iFloor.floorId]) {
          model.selected = YES;
        }
        [list addObject:model];
      }
      [self.floorBar refershList:list refBuildingId:geoBuilding.identifier];
    } else {
      int i = 0;
      for (MXMFloor *iFloor in reversalFloors) {
        if ([filter.selectedFloor.floorId isEqualToString:iFloor.floorId]) {
          [self.floorBar selectFloorIndex:i];
          break;
        }
        i++;
      }
    }
  }
  
  // 过滤前景
  if (filter.foreFloorIds) {
    [_mapView.style filerLevelIds:filter.foreFloorIds];
  }
  // 过滤后景
  if (filter.rearFloorIds) {
    [_mapView.style filerRearLevelIds:filter.rearFloorIds];
  }
  // 过滤poi
  if (filter.allFloorIds && filter.exceptPoiIds) {
    [_mapView.style filerPoisOnLevelIds:filter.allFloorIds exceptPoiIds:filter.exceptPoiIds];
  }
  
  // 添加building遮罩层
  if (self.maskNonSelectedSite) {
    if (filter.maskBuildingIds) {
      [_mapView.style updateSelectedBuildingFillOpacityWithIds:filter.maskBuildingIds
                                                         notIn:filter.maskBuildingIdNotInList];
    }
  } else {
    // 在不显示覆盖层时，只有重新加载室内地图时才重置style filter，提高点性能
    if (self.decider.isMapReload) {
      [_mapView.style unMaskBuildingFill];
    }
  }
  
  self.decider.isMapReload = NO;
  // 回调
  if (filter.shouldCallBack) {
    [self updateLocationView];
    if (self.delegate) {
      if ([self.delegate respondsToSelector:@selector(map:didChangeSelectedFloor:inSelectedBuildingId:atSelectedVenueId:)]) {
        [self.delegate map:self didChangeSelectedFloor:[filter.selectedFloor copy] inSelectedBuildingId:filter.selectedBuildingId atSelectedVenueId:filter.selectedVenueId];
      } else if ([self.delegate respondsToSelector:@selector(map:didChangeSelectedFloor:inSelectedBuilding:atSelectedVenue:)]) {
        [self.delegate map:self didChangeSelectedFloor:[filter.selectedFloor copy] inSelectedBuilding:[filter.selectedBuilding copy] atSelectedVenue:[filter.selectedVenue copy]];
      } else if ([self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
        [self.delegate mapView:self didChangeFloor:filter.selectedFloor.code atBuilding:[filter.selectedBuilding copy]];
      }
    }
  }
}

- (NSArray<MXMGeoPOI *> *)poisOnRearFloorIds:(NSArray<NSString *> *)floorIds {
  return  [[self.dataQueryer findOutPOIOnLevelIds:floorIds] allValues];
}

- (void)decideMapViewZoomTo:(MXMBoundingBox *)bbox zoomMode:(MXMZoomMode)zoomMode withEdgePadding:(UIEdgeInsets)insets
{
  MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(
                                                       CLLocationCoordinate2DMake(bbox.min_latitude, bbox.min_longitude),
                                                       CLLocationCoordinate2DMake(bbox.max_latitude, bbox.max_longitude)
                                                       );
  __weak typeof(self) weakSelf = self;
  
  switch (zoomMode) {
    case MXMZoomAnimated:
    {
      self.flying = YES;
      MGLMapCamera *ca = [_mapView cameraThatFitsCoordinateBounds:bounds edgePadding:insets];
      
      [_mapView flyToCamera:ca withDuration:1.8 completionHandler:^{
        weakSelf.flying = NO;
        // 多调用一次保证显示出选中建筑
        [weakSelf automaticAnalyseOfIndoorData];
      }];
      break;
    }
    case MXMZoomDirect:
    {
      self.flying = NO;
      [_mapView setVisibleCoordinateBounds:bounds edgePadding:insets animated:NO completionHandler:nil];
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
  
  NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.decider.visibleBuildings.count];
  for (MXMGeoBuilding *b in [self.decider.visibleBuildings allValues]) {
    KxMenuItem *item = [KxMenuItem menuItem:b.name
                                 identifier:b.identifier
                                      image:nil
                                     target:self
                                     action:@selector(chooseItem:)];
    item.alignment = alig;
    [arr addObject:item];
  }
  [KxMenu setDefaultItemIdentifier:self.decider.selectedBuildingId];
  [KxMenu showMenuInView:sender.superview fromRect:sender.frame menuItems:arr];
}

- (void)chooseItem:(KxMenuItem *)sender
{
  [self selectBuildingById:sender.identifier zoomMode:MXMZoomDisable edgePadding:UIEdgeInsetsZero];
}

#pragma mark - MXMFloorSelectorBarDelegate
- (void)floorSelectorBarDidSelectFloor:(MXMFloor *)floor
{
  [self.decider specifyTheFloorId:floor.floorId
                         zoomMode:MXMZoomDisable
                      edgePadding:UIEdgeInsetsZero
         shouldChangeTrackingMode:YES];
}

#pragma mark - 建筑筛选
- (void)selectFloorById:(NSString *)floorId {
  [self.decider specifyTheFloorId:floorId zoomMode:MXMZoomAnimated edgePadding:UIEdgeInsetsZero shouldChangeTrackingMode:YES];
}

- (void)selectFloorById:(NSString *)floorId zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets {
  [self.decider specifyTheFloorId:floorId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:YES];
}

- (void)selectBuildingById:(NSString *)buildingId {
  [self.decider specifyTheBuildingId:buildingId zoomMode:MXMZoomAnimated edgePadding:UIEdgeInsetsZero shouldChangeTrackingMode:YES];
}

- (void)selectBuildingById:(NSString *)buildingId zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets {
  [self.decider specifyTheBuildingId:buildingId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:YES];
}

- (void)selectVenueById:(NSString *)venueId {
  [self.decider specifyTheVenueId:venueId zoomMode:MXMZoomAnimated edgePadding:UIEdgeInsetsZero shouldChangeTrackingMode:YES];
}

- (void)selectVenueById:(NSString *)venueId zoomMode:(MXMZoomMode)zoomMode edgePadding:(UIEdgeInsets)insets {
  [self.decider specifyTheVenueId:venueId zoomMode:zoomMode edgePadding:insets shouldChangeTrackingMode:YES];
}

- (void)selectFloor:(NSString *)floor
{
  [self.decider specifyTheBuilding:self.building.identifier
                         floorCode:floor
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
                         floorCode:floor
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
                         floorCode:nil
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
                         floorCode:nil
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
                         floorCode:floor
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
                         floorCode:floor
                           ordinal:nil
                          zoomMode:zoomMode
                       edgePadding:insets
          shouldChangeTrackingMode:YES
                   withGeoBuilding:building];
}


#pragma mark - private

// 定位标注的显示状态
- (void)updateLocationView
{
  // 不显示定位时，就不需要再执行判断
  if (!_mapView.showsUserLocation) {
    return;
  }
  CLLocationCoordinate2D coordinate = _mapView.userLocation.location.coordinate;
  CGPoint locationPoint = [_mapView convertCoordinate:coordinate
                                        toPointToView:_mapView];
  NSArray<MXMLevelModel *> *floorFeatures = [self.dataQueryer findOutAssistantFloorFeaturesAtPoint:locationPoint pointCoordinate:coordinate];
  
  CLFloor *localFloor = _mapView.userLocation.location.floor;
  UIView *locationView = [_mapView viewForAnnotation:_mapView.userLocation];
  locationView.alpha = [self.decider decideLocationViewAlphaWithCurrentFloorId:self.selectedFloor.floorId
                                                                 andLocalFloor:localFloor
                                                          atPointLevelInfoList:floorFeatures];
}

- (NSArray<MXMPointAnnotation *> *)MXMAnnotations
{
  return [self.annHolder.mxmPointAnnotations copy];
}

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
  for (MXMPointAnnotation *ann in annotations) {
    __weak typeof(self) weakSelf = self;
    ann.sceneRefreshBlock = ^(NSString *buildingId, NSString *floor, NSString *floorId) {
      [weakSelf filterMXMAnnotation];
    };
  }
  [self.annHolder addMXMPointAnnotations:annotations];
  [self filterMXMAnnotation];
}

- (void)filterMXMAnnotation
{
  [self.annHolder filterMXMAnnotationsWithBuilding:self.selectedBuildingId
                                             floor:self.selectedFloor.code
                                           floorId:self.selectedFloor.floorId
                                       indoorState:_isIndoor];
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
  for (MXMPointAnnotation *ann in annotations) {
    ann.sceneRefreshBlock = nil;
  }
  [self.annHolder removeMXMPointAnnotaions:annotations];
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

- (void)walkAroundOutdoor
{
  NSArray *arr = _mapView.style.layers;
  for (MGLStyleLayer *k in arr) {
    if ([k isOutdoorLayer]) {
      k.visible = !_outdoorHidden;
    }
  }
}

// 重新过滤
- (void)cleanMapSelected {
  self.decider.isMapReload = YES;
  [self.decider cleanHistory];
  [self.decider specifyTheFloorId:self.decider.selectedFloor.floorId
                         zoomMode:MXMZoomDisable
                      edgePadding:UIEdgeInsetsZero
         shouldChangeTrackingMode:NO];
}

- (void)showOpenStreeSourceWeb
{
  if (@available(iOS 10.0, *)) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SOURCE_COPYRIGHT_URL] options:@{} completionHandler:nil];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SOURCE_COPYRIGHT_URL]];
  }
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

#pragma mark - access
- (UIButton *)buildingSelectButton
{
  if (!_buildingSelectButton) {
    _buildingSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buildingSelectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_buildingSelectButton setImage:[UIImage getMXMSdkImage:@"selectBuilding"] forState:UIControlStateNormal];
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

- (MXMLogoButton *)MXMLogo
{
  if (!_MXMLogo) {
    _MXMLogo = [[MXMLogoButton alloc] initWithCopyright:self.collapseCopyright];
    _MXMLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [_MXMLogo addTarget:self action:@selector(logoOnClickAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _MXMLogo;
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

- (void)setIndoorControllerAlwaysHidden:(BOOL)indoorControllerAlwaysHidden
{
  _indoorControllerAlwaysHidden = indoorControllerAlwaysHidden;
  BOOL show = self.selectedBuildingId ? YES : NO;
  [self decideMapViewShowFloorBar:show
                          atVenue:self.decider.selectedVenue
                       inBuilding:self.decider.selectedBuilding
                            floor:self.decider.selectedFloor];
}

- (void)setSelectorPosition:(MXMSelectorPosition)selectorPosition
{
  _selectorPosition = selectorPosition;
  
  [self _constraintWithIndientifer:@"floorBarXLc" InView:_mapView].active = NO;
  [self _constraintWithIndientifer:@"floorBarYLc" InView:_mapView].active = NO;
  
  NSLayoutConstraint *floorBarXLc;
  NSLayoutConstraint *floorBarYLc;
  
  switch (selectorPosition) {
    case MXMSelectorPositionCenterLeft:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.leftAnchor constant:31];
      floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:_mapView.centerYAnchor constant:30];
    }
      break;
    case MXMSelectorPositionCenterRight:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.rightAnchor constant:-31];
      floorBarYLc = [self.floorBar.centerYAnchor constraintEqualToAnchor:_mapView.centerYAnchor constant:30];
    }
      break;
    case MXMSelectorPositionTopLeft:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.leftAnchor constant:31];
      floorBarYLc = [self.floorBar.topAnchor constraintEqualToAnchor:_mapView.topAnchor constant:100];
    }
      break;
    case MXMSelectorPositionTopRight:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.rightAnchor constant:-31];
      floorBarYLc = [self.floorBar.topAnchor constraintEqualToAnchor:_mapView.topAnchor constant:100];
    }
      break;
    case MXMSelectorPositionBottomLeft:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.leftAnchor constant:31];
      floorBarYLc = [self.floorBar.bottomAnchor constraintEqualToAnchor:_mapView.bottomAnchor constant:-50];
    }
      break;
    case MXMSelectorPositionBottomRight:
    {
      floorBarXLc = [self.floorBar.centerXAnchor constraintEqualToAnchor:_mapView.rightAnchor constant:-31];
      floorBarYLc = [self.floorBar.bottomAnchor constraintEqualToAnchor:_mapView.bottomAnchor constant:-50];
    }
      break;
      
    default:
      break;
  }
  
  floorBarXLc.identifier = @"floorBarXLc";
  floorBarYLc.identifier = @"floorBarYLc";
  
  [NSLayoutConstraint activateConstraints:@[floorBarXLc, floorBarYLc]];
  
  [_mapView layoutIfNeeded];
}

- (void)setOutdoorHidden:(BOOL)outdoorHidden
{
  _outdoorHidden = outdoorHidden;
  [self walkAroundOutdoor];
}

- (void)setMapSytle:(MXMStyle)style
{
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
      [self setMapStyleWithName:@"mapxus_mims2_v5"];
      break;
    default:
      break;
  }
}

- (void)setMapStyleWithName:(NSString *)styleName {
  _mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/bms/api/v3/tiles/styles/%@", MXMAPIHOSTURL, styleName]];
}

- (void)setMapLanguage:(NSString *)language
{
  [_mapView.style MXMlocalizeLabelsIntoLocale:language];
}

- (void)setLogoBottomMargin:(CGFloat)logoBottomMargin {
  _logoBottomMargin = fmaxf(logoBottomMargin, 0);
  NSLayoutConstraint *t = [self _constraintWithIndientifer:@"logoBottom" InView:_mapView];
  t.constant = -_logoBottomMargin;
  [_mapView layoutIfNeeded];
}

- (void)setOpenStreetSourceBottomMargin:(CGFloat)openStreetSourceBottomMargin {
  _openStreetSourceBottomMargin = fmaxf(openStreetSourceBottomMargin, 0);
  NSLayoutConstraint *t = [self _constraintWithIndientifer:@"openStreetBottom" InView:_mapView];
  t.constant = -_openStreetSourceBottomMargin;
  [_mapView layoutIfNeeded];
}

- (void)setCollapseCopyright:(BOOL)collapseCopyright {
  _collapseCopyright = collapseCopyright;
  self.MXMLogo.collapseCopyright = collapseCopyright;
  self.openStreetSourceBtn.hidden = collapseCopyright;
}

- (void)setFloorSwitchMode:(MXMFloorSwitchMode)floorSwitchMode {
  _floorSwitchMode = floorSwitchMode;
  self.decider.floorSwitchMode = floorSwitchMode;
  [self cleanMapSelected];
}

- (void)setMaskNonSelectedSite:(BOOL)maskNonSelectedSite {
  _maskNonSelectedSite = maskNonSelectedSite;
  self.decider.maskNonSelectedSite = maskNonSelectedSite;
  [self cleanMapSelected];
}

- (void)setSelectedBuildingBorderStyle:(MXMBorderStyle *)selectedBuildingBorderStyle {
  if (selectedBuildingBorderStyle == nil) {
    _selectedBuildingBorderStyle = [MXMBorderStyle defaultSelectedBuildingBorderStyle];
  } else {
    _selectedBuildingBorderStyle = selectedBuildingBorderStyle;
  }
  [_mapView.style outLineLevelBorderStyle:_selectedBuildingBorderStyle];
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

- (void)updateUserLocationFloor:(NSString *)floor {
  _userLocationFloor = floor;
}

- (void)updateUserLocationBuilding:(MXMGeoBuilding *)building {
  _userLocationBuilding = building;
}

- (void)updateUserLocationVenue:(MXMGeoVenue *)venue {
  _userLocationVenue = venue;
}

- (void)dealloc
{
  // 清除mapView对self的引用
  _mapView.mxmMap = nil;
  _mapView = nil;
}


@end







