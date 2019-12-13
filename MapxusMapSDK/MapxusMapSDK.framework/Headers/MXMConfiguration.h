//
//  MXMConfiguration.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXMDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 MapxusMap初始化配置
 */
@interface MXMConfiguration : NSObject

/// 设置是否显示室外地图，默认值为 NO
@property (nonatomic) BOOL outdoorHidden;

/// 初始化地图样式，与其他条件可同时配置，默认值为 MXMStyleMAPXUS
@property (nonatomic) MXMStyle defaultStyle;


/// 通过 buildingId 初始化地图，使开始显示位置为 building 所在位置，与 poiId 不能同时设置
@property (nonatomic, copy, nullable) NSString *buildingId;

/// 通过 buildingId 和 floor 初始化地图，使开始显示位置为 building 所在位置，开始显示的楼层为 floor，如果 floor 不设置，默认展示建筑的地面层；与 poiId 不能同时设置
@property (nonatomic, copy, nullable) NSString *floor;

/// 通过 buildingId 初始化地图时的自适应边距，默认值为 UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets zoomInsets;


/// 通过 poiId 初始化地图，使地图开始显示位置中心设为poi经纬度，并切换到对应的建筑与楼层，与buildingId和floor不能同时设置，如果设置了，则设置buildingId无效
@property (nonatomic, copy, nullable) NSString *poiId;

/// 通过 poiId 初始化地图的初始缩放等级，默认值为 19
@property (nonatomic, assign) double zoomLevel;

@end

NS_ASSUME_NONNULL_END
