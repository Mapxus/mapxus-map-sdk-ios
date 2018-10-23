//
//  MXMCommonObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

/**
 地球经纬度坐标
 */
@interface MXMGeoPoint : NSObject
///纬度（垂直方向）
@property (nonatomic, assign) double latitude;
///经度（水平方向）
@property (nonatomic, assign) double longitude;

+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng;

@end


/**
 两点的经纬线相交形成的矩形区域
 */
@interface MXMBoundingBox : NSObject
/// 左下角纬度
@property (nonatomic, assign) double min_latitude;
/// 左下角经度
@property (nonatomic, assign) double min_longitude;
/// 右上角纬度
@property (nonatomic, assign) double max_latitude;
/// 右上角经度
@property (nonatomic, assign) double max_longitude;
@end


/**
 建筑地址类
 */
@interface MXMAddress : NSObject
/// 房号
@property (nonatomic, strong) NSString *housenumber;
/// 街道名
@property (nonatomic, strong) NSString *street;

@end


/**
 建筑物楼层
 */
@interface MXMFloor : NSObject

/// 楼层名称
@property (nonatomic, strong) NSString *code;
/// 楼层Id
@property (nonatomic, strong) NSString *floorId;
/// 楼层序列号
@property (nonatomic, strong) NSString *sequence;

@end

/**
 建筑信息类
 */
@interface MXMBuilding : NSObject
/// 建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// 默认建筑名
@property (nonatomic, strong) NSString *name_default;
/// 英文建筑名
@property (nonatomic, strong) NSString *name_en;
/// 简体中文建筑名
@property (nonatomic, strong) NSString *name_cn;
/// 繁体中文建筑名
@property (nonatomic, strong) NSString *name_zh;
/// 默认建筑地址
@property (nonatomic, strong) MXMAddress *address_default;
/// 英文建筑地址
@property (nonatomic, strong) MXMAddress *address_en;
/// 简体中文建筑地址
@property (nonatomic, strong) MXMAddress *address_cn;
/// 繁体中文建筑地址
@property (nonatomic, strong) MXMAddress *address_zh;
/// 建筑类型，表示该建筑的分类，如cathedral,car_park,hospital,office,retail等
@property (nonatomic, strong) NSString *type;
/// 建筑所在外接矩形区域
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 标签经纬度
@property (nonatomic, strong) MXMGeoPoint *labelCenter;
/// 建筑所有楼层
@property (nonatomic, strong) NSArray<MXMFloor *> *floors;

@end


/**
 POI信息类
 */
@interface MXMPOI : NSObject
/// 所在建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// POI分类
@property (nonatomic, strong) NSString *category;
/// POI描述
@property (nonatomic, strong) NSString *introduction;
/// POI邮箱
@property (nonatomic, strong) NSString *email;
/// POI所在楼层
@property (nonatomic, strong) NSString *floor;
/// POI的ID
@property (nonatomic, strong) NSString *id;
/// POI的经纬度
@property (nonatomic, strong) MXMGeoPoint *location;
/// 默认POI名字
@property (nonatomic, strong) NSString *name_default;
/// POI英文名字
@property (nonatomic, strong) NSString *name_en;
/// POI简体中文名字
@property (nonatomic, strong) NSString *name_cn;
/// POI繁体中文名字
@property (nonatomic, strong) NSString *name_zh;
/// 开门时间
@property (nonatomic, strong) NSString *openingHours;
/// 店铺电话
@property (nonatomic, strong) NSString *phone;
/// POI的类型ID
@property (nonatomic, strong) NSString *poiId;
/// 店铺网址
@property (nonatomic, strong) NSString *website;
@end


/**
 <#Description#>
 */
@interface MXMManeuver :NSObject
///
@property (nonatomic, strong) MXMGeoPoint *location;
///
@property (nonatomic, strong) NSString *type;
///
@property (nonatomic, strong) NSString *modifier;
///
@property (nonatomic, strong) NSString *exit;
@end


/**
 <#Description#>
 */
@interface MXMCoordinate : NSObject
/// 节点经纬度
@property (nonatomic, strong) MXMGeoPoint *location;
///
@property (nonatomic, strong) NSString *buildingId;
///
@property (nonatomic, strong) NSString *floor;
///
@property (nonatomic, assign) NSInteger angle;
///
@property (nonatomic, strong) NSString *type;
@end


/**
 路径节点
 */
@interface MXMStep : NSObject
/// 距离
@property (nonatomic, assign) double distance;
/// 耗时
@property (nonatomic, assign) double duration;
///
@property (nonatomic, strong) NSString *name;
/// 行进方式
@property (nonatomic, strong) NSString *mode;
///
@property (nonatomic, strong) MXMManeuver *maneuver;
///
@property (nonatomic, strong) NSArray<MXMCoordinate *> *coordinates;
/// 节点所在建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// 节点所在楼层
@property (nonatomic, strong) NSString *floor;
@end


/**
 路径类
 */
@interface MXMLeg : NSObject
/// 距离
@property (nonatomic, assign) double distance;
/// 耗时
@property (nonatomic, assign) double duration;
/// 路线描述
@property (nonatomic, strong) NSString *summary;
/// 路径
@property (nonatomic, strong) NSArray<MXMStep *> *steps;
@end


/**
 <#Description#>
 */
@interface MXMRoute : NSObject
/// 距离
@property (nonatomic, assign) double distance;
/// 耗时
@property (nonatomic, assign) double duration;
/// 步行、骑行、驾车方案列表 AMapPath 数组
@property (nonatomic, strong) NSArray<MXMLeg *> *legs;
@end



/**
 <#Description#>
 */
@interface MXMWaypoint : NSObject
///
@property (nonatomic, strong) NSString *name;
///
@property (nonatomic, strong) MXMGeoPoint *location;
@end









