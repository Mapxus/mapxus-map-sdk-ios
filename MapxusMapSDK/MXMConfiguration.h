//
//  MXMConfiguration.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMDefine.h"

/**
 MapxusMap初始化配置
 */
@interface MXMConfiguration : NSObject

/// 初始化地图样式，与其他条件可同时配置
@property (nonatomic) MXMStyle defaultStyle;

/// 通过buildingId初始化地图，使开始显示位置为building所在位置，与poiId不能同时设置
@property (nonatomic, copy) NSString *buildingId;

/// 通过buildingId和floor初始化地图，使开始显示位置为building所在位置，开始显示的楼层为floor，如果floor不设置，默认展示建筑的地面层；与poiId不能同时设置
@property (nonatomic, copy) NSString *floor;

/// 通过poiId初始化地图，使地图开始显示位置中心设为poi经纬度，并切换到对应的建筑与楼层，与buildingId和floor不能同时设置，如果设置了，则设置buildingId无效
@property (nonatomic, copy) NSString *poiId;

@end
