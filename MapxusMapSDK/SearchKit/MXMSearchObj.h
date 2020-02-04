//
//  MXMSearchObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

/**
 建筑搜索请求配置类
 
 共有四种搜索模式：
 1.全球搜索，参数组合为 keywords(可选)，offset，page；
 2.指定方形区域内关键字搜索，参数组合为 keywords(可选)，bbox，offset，page；
 3.指定圆形区域内关键字搜索，参数组合为 keywords(可选)，center，distance，offset，page；
 4.指定建筑ID搜索，参数为 buildingIds。
 */
@interface MXMBuildingSearchRequest : NSObject
/// 关键字。目前只支持单个关键字查询
@property (nonatomic, strong, nullable) NSString *keywords;
/// 方形搜索区域。bbox与center 二选一进行搜索
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// 圆形区域搜索中心。bbox与center 二选一进行搜索
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为km，必须配合center使用
@property (nonatomic, assign) double distance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
/// 查询的建筑id列表。与其他的参数互斥
@property (nonatomic, strong, nullable) NSArray<NSString *> *buildingIds;
@end




/**
 建筑搜索结果
 */
@interface MXMBuildingSearchResponse : NSObject
/// 返回结果个数
@property (nonatomic, assign) NSInteger total;
/// 返回的`MXMBuilding`队列
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
@end




/**
 POI分类搜索请求配置类
 
 搜索指定建筑和楼层内所有的POI分类名，floor可不传，不传将搜索整栋建筑。
 */
@interface MXMPOICategorySearchRequest : NSObject
/// 指定搜索建筑id
@property (nonatomic, strong, nullable) NSString *buildingId;
/// 指定搜索楼层
@property (nonatomic, strong, nullable) NSString *floor;
@end




/**
 POI分类搜索结果
 */
@interface MXMPOICategorySearchResponse : NSObject
/// 分类名列表
@property (nonatomic, strong) NSArray<NSString *> *category;
@end




/**
 POI搜索请求配置类
 
 共有四种搜索模式：
 1.指定建筑与楼层内关键字搜索，参数组合为 keywords(可选)，buildingId，floor(可选)，offset，page，category(可选)；
 2.指定方形区域内关键字搜索，参数组合为 keywords(可选)，bbox，offset，page，category(可选)；
 3.指定圆形区域内关键字搜索，按二维空间距离排序，参数组合为 keywords(可选)，center，meterDistance(或distance)，offset，page，category(可选)；
 4.指定圆形区域内关键字搜索，按路线距离排序，参数组合为 keywords(可选)，center，ordinal，buildingId，sort，meterDistance(或distance)，offset，page，category(可选)；
 5.指定建筑ID搜索，参数为 POIIds；
 */
@interface MXMPOISearchRequest : NSObject
/// 关键字。目前只支持单个关键字
@property (nonatomic, strong, nullable) NSString *keywords;
/// 建筑id。buildingId，bbox, center 三选一
@property (nonatomic, strong, nullable) NSString *buildingId;
/// 搜索楼层。必须配合buildingId使用
@property (nonatomic, strong, nullable) NSString *floor;
/// 方形搜索区域。buildingId，bbox, center 三选一
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// 圆形区域搜索中心。buildingId，bbox, center 三选一
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为km，必须配合center使用
@property (nonatomic, assign) double distance DEPRECATED_ATTRIBUTE;
/// 圆形区域搜索半径。单位为m，必须配合center使用
@property (nonatomic, assign) NSUInteger meterDistance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
/// 要过滤的类别
@property (nonatomic, strong, nullable) NSString *category;
/// 排序方式。AbsoluteDistance: 按二维空间距离排序[默认值]；ActualDistance: 按路线距离排序
@property (nonatomic, strong, nullable) NSString *sort;
/// 搜索地点的实际楼高，取CLFloor的level值，当sort值为ActualDistance时，需要传入值
@property (nonatomic, assign) NSInteger ordinal;
/// 查询的POI id列表。与上面的参数互斥
@property (nonatomic, strong, nullable) NSArray<NSString *> *POIIds;
@end




/**
 POI搜索结果
 */
@interface MXMPOISearchResponse : NSObject
/// 返回结果个数
@property (nonatomic, assign) NSInteger total;
/// 返回的`MXMPOI`队列
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 给定地图偏转角度，搜索附近POI点并得出POI点相对手机方向的方位
 */
@interface MXMOrientationPOISearchRequest : NSObject
/// 地图正北方向到手机指向的顺时针夹角，取值范围：[0,359]
@property (nonatomic, assign) NSUInteger angle;
/// 距离搜索类型（默认：Point）。Point：查找以center为圆心，distance为半径的圆包含的POI点；Polygon：查找以center为圆心，distance为半径的圆相交房间的POI信息
@property (nonatomic, strong, nullable) NSString *distanceSearchType;
/// 建筑ID
@property (nonatomic, strong, nullable) NSString *buildingId;
/// 搜索楼层
@property (nonatomic, strong, nullable) NSString *floor;
/// 中心点位置
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为m
@property (nonatomic, assign) NSUInteger distance;
@end




/**
 中心点附近POI搜索结果
 */
@interface MXMOrientationPOISearchResponse : NSObject
/// 返回的`MXMPOI`队列
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 路线搜索请求配置
 */
@interface MXMRouteSearchRequest : NSObject
/// 始点建筑
@property (nonatomic, strong, nullable) NSString *fromBuilding;
/// 始点建筑楼层
@property (nonatomic, strong, nullable) NSString *fromFloor;
/// 始点经度
@property (nonatomic, assign) double fromLon;
/// 始点纬度
@property (nonatomic, assign) double fromLat;
/// 终点建筑
@property (nonatomic, strong, nullable) NSString *toBuilding;
/// 终点建筑楼层
@property (nonatomic, strong, nullable) NSString *toFloor;
/// 终点经度
@property (nonatomic, assign) double toLon;
/// 终点纬度
@property (nonatomic, assign) double toLat;
/// 导航方式。可选值为foot, wheelchair。默认foot
@property (nonatomic, strong, nullable) NSString *vehicle;
/// 返回结果语言版本。可选值为en，zh-Hans，zh-Hant，ja，ko。默认en
@property (nonatomic, strong, nullable) NSString *locale;
/// 终点设置在门前。设置为YES则终点只到POI店门终止
@property (nonatomic, assign) BOOL toDoor;
@end




/**
 路线搜索结果
 */
@interface MXMRouteSearchResponse : NSObject
/// 途经点列表
@property (nonatomic, strong) NSArray<MXMIndoorPoint *> *wayPointList;
/// 路线`MXMPath`的队列，不同的路线为不同的规划方案
@property (nonatomic, strong) NSArray<MXMPath *> *paths;
@end


NS_ASSUME_NONNULL_END
