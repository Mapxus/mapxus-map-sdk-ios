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

#import "MXMGetTokenOperation.h"
#import "MXMSearchBuildingOperation.h"
#import "MXMSearchPOIOperation.h"
#import "MXMLoadMapOperation.h"
#import "MXMZoomToOperation.h"

NS_ASSUME_NONNULL_BEGIN

@import Mapbox;

@interface MapxusMap () <MXMFloorSelectorBarDelegate, UIGestureRecognizerDelegate, MXMSearchDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) UIButton *buildingSelectBtn;
@property (nonatomic, strong) MXMFloorSelectorBar *floorBar;
@property (nonatomic, strong) UIButton *MXMLogo;
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
@property (nonatomic, readwrite) NSDictionary<NSString *, MXMGeoBuilding *> *innerbuildings;

@property (nonatomic, strong) NSOperationQueue *initializeQueue;
@property (nonatomic, weak) MXMLoadMapOperation *externalLoadOperation;

// 移动地图时自动选择建筑
- (void)automaticAnalyseOfIndoorData;
// 刷新定位点透明度
- (void)updageLocationView;
// 查找点坐标的建筑信息
- (NSArray<MXMGeoBuilding *> *)findOutBuildingAtPoint:(CGPoint)point;
// 选择建筑，在buildings里则不请求接口，不在则请求接口
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldZoomTo:(BOOL)zoomTo shouldChangeUserTrackingMode:(BOOL)changeUserTrackingMode;

@end

NS_ASSUME_NONNULL_END
