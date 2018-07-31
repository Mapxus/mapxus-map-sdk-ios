//
//  MapxusMap+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MapxusMap.h"
#import "MXMFloorSelectorBar.h"
#import "KxMenu.h"
#import "MapxusMapSDK.h"

NS_ASSUME_NONNULL_BEGIN

@import Mapbox;

@interface MapxusMap () <MXMFloorSelectorBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) UIButton *buildingSelectBtn;
@property (nonatomic, strong) MXMFloorSelectorBar *floorBar;
@property (nonatomic, strong) UIImageView *MXMLogo;
@property (nonatomic, strong) UIButton *openStreetSourceBtn;

@property (nonatomic, strong) NSMutableDictionary *buildingSelectFloorDic; // 保存运行期间看过大厦最后选中的对应楼层
@property (nonatomic, strong) NSMutableArray<NSString *> *historicalBuildingIds; // 保存运行期间看过的大厦Id，防止同一地点两栋大厦间互相切换
@property (nonatomic, strong) NSMutableArray *mxmPointAnnotations;

@property (nonatomic, assign) BOOL isIndoor;
@property (nonatomic, assign) BOOL isMapReload;
@property (nonatomic, assign) BOOL mapViewDidFinishLoadingMap; // 地图加载完地图

@property (nonatomic, readwrite) NSString *floor;
@property (nonatomic, readwrite) MXMGeoBuilding *building;
@property (nonatomic, readwrite) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

- (void)automaticAnalyseOfIndoorData;
- (void)updageLocationView;
- (NSArray<MXMGeoBuilding *> *)findOutBuildingAtPoint:(CGPoint)point;
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldChangeUserTrackingMode:(BOOL)changeUserTrackingMode;

@end

NS_ASSUME_NONNULL_END
