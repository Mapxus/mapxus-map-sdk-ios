//
//  MXMSearchObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

/**
 建筑搜索请求配置
 */
@interface MXMBuildingSearchRequest : NSObject

/// 关键字，目前只支持单个关键字
@property (nonatomic, strong) NSString *keywords;
/// 全球范围内搜索建筑，searchGlobal，bbox, center 三选一
@property (nonatomic, assign) BOOL searchGlobal;
/// bounding box，searchGlobal，bbox, center 三选一
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 中心点，searchGlobal，bbox, center 三选一
@property (nonatomic, strong) MXMGeoPoint *center;
/// 中心点范围内搜索距离，单位为km，必须配合center使用
@property (nonatomic, assign) double distance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
// 与上面的参数互斥
@property (nonatomic, strong) NSArray *buildingIds;

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
 POI搜索请求配置
 */
@interface MXMPOISearchRequest : NSObject

/// 关键字，目前只支持单个关键字
@property (nonatomic, strong) NSString *keywords;
/// 建筑id，buildingId，bbox, center 三选一
@property (nonatomic, strong) NSString *buildingId;
/// bounding box，buildingId，bbox, center 三选一
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 中心点，buildingId，bbox, center 三选一
@property (nonatomic, strong) MXMGeoPoint *center;
/// 中心点范围内搜索距离，单位为km，必须配合center使用
@property (nonatomic, assign) double distance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
// 与上面的参数互斥
@property (nonatomic, strong) NSArray *POIIds;

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
 路线搜索请求配置
 */
@interface MXMRouteSearchRequest : NSObject

/// 始点建筑
@property (nonatomic, strong) NSString *fromBuilding;
/// 始点建筑楼层
@property (nonatomic, strong) NSString *fromFloor;
/// 始点经度
@property (nonatomic, assign) CGFloat fromLon;
/// 始点纬度
@property (nonatomic, assign) CGFloat fromLat;
/// 终点建筑
@property (nonatomic, strong) NSString *toBuilding;
/// 终点建筑楼层
@property (nonatomic, strong) NSString *toFloor;
/// 终点经度
@property (nonatomic, assign) CGFloat toLon;
/// 终点纬度
@property (nonatomic, assign) CGFloat toLat;

@end

/**
 路线搜索结果
 */
@interface MXMRouteSearchResponse : NSObject

/// 路线`MXMPath`的队列
@property (nonatomic, strong) NSArray<MXMPath *> *routes;

@end

