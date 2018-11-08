//
//  MXMGeoBuilding.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 瓦片中的建筑数据
 */
@interface MXMGeoBuilding : NSObject <NSCopying>

/// 建筑ID
@property (nonatomic, strong) NSString *identifier;
/// 建筑类型，表示该建筑的分类，如cathedral,car_park,hospital,office,retail等
@property (nonatomic, strong) NSString *building;
/// 建筑默认名
@property (nonatomic, strong) NSString *name;
/// 建筑英文名
@property (nonatomic, strong) NSString *name_en;
/// 建筑简体中文名
@property (nonatomic, strong) NSString *name_cn;
/// 建筑繁体中文名
@property (nonatomic, strong) NSString *name_zh;
/// 建筑楼层名称队列
@property (nonatomic, strong) NSArray *floors;
/// 建筑地面层
@property (nonatomic, strong) NSString *ground_floor;
/// 地图渲染类型，如multipolygon等
@property (nonatomic, strong) NSString *type;
/// 是否在地下
@property (nonatomic, assign) BOOL underground;
/// 描述多栋建筑的垂直的空间关系。详 细参考[Key:layer](https://wiki.openstreetmap.org/wiki/Key:layer)介绍
@property (nonatomic, assign) int layer;

@end
