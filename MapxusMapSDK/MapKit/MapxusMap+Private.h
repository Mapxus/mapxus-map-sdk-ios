//
//  MapxusMap+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MapxusMap.h"
#import "MXMFloorSelectorBar+Private.h"
#import "KxMenu.h"
#import "MapxusMapSDK.h"

#import "MXMSearchPOIOperation.h"

#import "MXMDecider.h"
#import "MXMDataQuerier.h"
#import "MXMAnnotationsHolder.h"

NS_ASSUME_NONNULL_BEGIN

@import Mapbox;

@interface MapxusMap () <MXMFloorSelectorBarDelegate, UIGestureRecognizerDelegate, MXMSearchDelegate, MXMDeciderDelegate> {
    BOOL _isFristLoad;
    NSOperationQueue *_initializeQueue;
    MXMConfiguration *_configuration;
}

@property (nonatomic, strong) MXMDecider *decider;
@property (nonatomic, strong) MXMDataQuerier *dataQueryer;
@property (nonatomic, strong) MXMAnnotationsHolder *annHolder;

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong, readwrite) UIButton *buildingSelectButton;
@property (nonatomic, strong, readwrite) MXMFloorSelectorBar *floorBar;
@property (nonatomic, strong) UIButton *MXMLogo;
@property (nonatomic, strong) UIButton *openStreetSourceBtn;

@property (nonatomic, assign) BOOL isIndoor;
@property (nonatomic, assign) BOOL mapViewDidFinishLoadingMap; // 地图加载完地图
@property (nonatomic, assign) BOOL regionBecomeIdle; //
@property (nonatomic, assign) BOOL flying; // 是否在飞行切换 camera ，YES 时忽略自动过滤建筑

@property (nonatomic, copy, readwrite) NSString *floor;
@property (nonatomic, copy, readwrite) MXMGeoBuilding *building;
@property (nonatomic, copy, readwrite, nullable) NSString *userLocationFloor;
@property (nonatomic, copy, readwrite, nullable) MXMGeoBuilding *userLocationBuilding;
@property (nonatomic, copy, readwrite) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;
@property (nonatomic, copy, readwrite) NSDictionary<NSString *, MXMGeoBuilding *> *innerbuildings;

// 移动地图时自动选择建筑
- (void)automaticAnalyseOfIndoorData;
- (void)idleAutomaticAnalyseOfIndoorData;
// 刷新定位点透明度
- (void)updageLocationView;
- (void)searchConfigurationInfo;
- (void)walkAroundOutdoor;
- (void)cleanMapSelected;

@end

NS_ASSUME_NONNULL_END
