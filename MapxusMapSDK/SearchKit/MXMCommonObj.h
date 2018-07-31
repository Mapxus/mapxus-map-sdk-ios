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
@property (nonatomic, assign) CGFloat latitude;
///经度（水平方向）
@property (nonatomic, assign) CGFloat longitude;

@end


/**
 两点间的矩形区域
 */
@interface MXMBoundingBox : NSObject

/// 左下角纬度
@property (nonatomic, assign) CGFloat min_latitude;
/// 左下角经度
@property (nonatomic, assign) CGFloat min_longitude;
/// 右上角纬度
@property (nonatomic, assign) CGFloat max_latitude;
/// 右上角经度
@property (nonatomic, assign) CGFloat max_longitude;

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
/// 建筑类型
@property (nonatomic, strong) NSString *type;
/// 建筑所在外接矩形区域
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 标签经纬度
@property (nonatomic, strong) MXMGeoPoint *labelCenter;
/// 建筑所有楼层
@property (nonatomic, strong) NSArray *floors;

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
 路径节点
 */
@interface MXMStep : NSObject

/// 节点纬度
@property (nonatomic, assign) CGFloat lat;
/// 节点经度
@property (nonatomic, assign) CGFloat lon;
/// 节点所在建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// 节点所在楼层
@property (nonatomic, strong) NSString *floor;

@end

/**
 路径类
 */
@interface MXMPath : NSObject

/// 距离
@property (nonatomic, assign) CGFloat distance;
/// 耗时
@property (nonatomic, assign) CGFloat duration;
/// 路径
@property (nonatomic, strong) NSArray<MXMStep *> *coordinates;

@end


