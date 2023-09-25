//
//  MapxusMap+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MapxusMap.h"
#import "MXMFloorSelectorBar+Private.h"
#import "MXMLogoButton.h"

#import "MXMSearchAPI.h"

#import "MXMDecider.h"
#import "MXMDataQuerier.h"
#import "MXMAnnotationsHolder.h"
#import "MXMCacheManager.h"

@import Mapbox;

NS_ASSUME_NONNULL_BEGIN


@interface MapxusMap () <MXMFloorSelectorBarDelegate, UIGestureRecognizerDelegate, MXMSearchDelegate, MXMDeciderDelegate> {
  BOOL _isFristLoad;
  BOOL _isIndoor;
  
  NSOperationQueue *_initializeQueue;
  MXMConfiguration *_configuration;
  
  NSDictionary<NSString *, MXMGeoVenue *> *_venues;
  NSDictionary<NSString *, MXMGeoBuilding *> *_buildings;
  NSDictionary<NSString *, MXMGeoBuilding *> *_innerbuildings;
  
  MGLMapView *_mapView;
  MXMLogoButton *_MXMLogo;
  UIButton *_openStreetSourceBtn;
  // TODO: 修复弹出UI
  UIButton *_buildingSelectButton;
  // TODO: 添加floorBar协议，以方便用户替换floorBar
  MXMFloorSelectorBar *_floorBar;
}


@property (nonatomic, strong, readonly) MXMDecider *decider;
@property (nonatomic, strong, readonly) MXMDataQuerier *dataQueryer;
@property (nonatomic, strong, readonly) MXMAnnotationsHolder *annHolder;
@property (nonatomic, strong, readonly) MXMCacheManager *cacheManager;

@property (nonatomic, assign) BOOL regionBecomeIdle; //
@property (nonatomic, assign) BOOL flying; // 是否在飞行切换 camera ，YES 时忽略自动过滤建筑

// TODO: 修改为MXMFloor
- (void)updateUserLocationFloor:(nullable NSString *)floor;
- (void)updateUserLocationBuilding:(nullable MXMGeoBuilding *)building;
- (void)updateUserLocationVenue:(nullable MXMGeoVenue *)venue;

// 移动地图时自动选择建筑
- (void)automaticAnalyseOfIndoorData;
- (void)idleAutomaticAnalyseOfIndoorData;
// 刷新定位点透明度
- (void)updateLocationView;
- (void)searchConfigurationInfo;
- (void)walkAroundOutdoor;
- (void)cleanMapSelected;

@end

NS_ASSUME_NONNULL_END
