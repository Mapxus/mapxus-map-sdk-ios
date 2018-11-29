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

// 海拔高度
@property (nonatomic, assign) double elevation;

/**
 MXMGeoPoint工厂方法
 
 @param lat 纬度（垂直方向）
 @param lng 经度（水平方向）
 @return MXMGeoPoint对象
 */
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng;

+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng elevation:(double)ele;

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

/**
 MXMBoundingBox工厂方法
 
 @param min_lat 左下角纬度
 @param min_lng 左下角经度
 @param max_lat 右上角纬度
 @param max_lng 右上角经度
 @return MXMBoundingBox对象
 */
+ (MXMBoundingBox *)boundingBoxWithMinLatitude:(double)min_lat minLongitude:(double)min_lng maxLatitude:(double)max_lat maxLongitude:(double)max_lng;

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
 指令
 */
@interface MXMInstruction : NSObject

@property (nonatomic, strong) NSString *buildingId;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double heading;
@property (nonatomic, assign) NSInteger sign;
@property (nonatomic, strong) NSArray<NSNumber *> *interval;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *streetName;

@end


/**
 路径的几何图形
 */
@interface MXMGeometry : NSObject

/// 路径几何图形的类型
@property (nonatomic, strong) NSString *type;

/// 路线的坐标数组
@property (nonatomic, strong) NSArray<MXMGeoPoint *> *coordinates;

@end


/**
 路线方案
 */
@interface MXMPath : NSObject

@property (nonatomic, assign) double distance;

@property (nonatomic, assign) double weight;

@property (nonatomic, assign) NSUInteger time;

@property (nonatomic, assign) BOOL pointsEncoded;

@property (nonatomic, strong) MXMBoundingBox *bbox;

@property (nonatomic, strong) MXMGeometry *points;

@property (nonatomic, strong) NSArray<MXMInstruction *> *instructions;

@property (nonatomic, assign) double ascend;

@property (nonatomic, assign) double descend;

@end

