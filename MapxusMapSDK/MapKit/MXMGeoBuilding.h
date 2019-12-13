//
//  MXMGeoBuilding.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 瓦片中的建筑数据
 */
@interface MXMGeoBuilding : NSObject <NSCopying>

/// 建筑ID
@property (nonatomic, strong) NSString *identifier;
/// 建筑类型，表示该建筑的分类，如cathedral,car_park,hospital,office,retail等
@property (nonatomic, strong) NSString *building;
/// 所属场所ID
@property (nonatomic, strong, nullable) NSString *venueId;
/// 建筑默认名
@property (nonatomic, strong, nullable) NSString *name;
/// 建筑英文名
@property (nonatomic, strong, nullable) NSString *name_en;
/// 建筑简体中文名
@property (nonatomic, strong, nullable) NSString *name_cn;
/// 建筑繁体中文名
@property (nonatomic, strong, nullable) NSString *name_zh;
/// 建筑楼层名称队列
@property (nonatomic, strong) NSArray<NSString*> *floors;
/// 楼层的ID
@property (nonatomic, strong) NSArray<NSString*> *floorIds;
/// 反映实际存在的楼层位置
@property (nonatomic, strong) NSArray<NSNumber*> *ordinals;
/// 建筑地面层
@property (nonatomic, strong, nullable) NSString *ground_floor;
/// 地图渲染类型，如multipolygon等
@property (nonatomic, strong, nullable) NSString *type;

@end

NS_ASSUME_NONNULL_END
