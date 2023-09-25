//
//  MXMFilterModel.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/9/21.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>
#import <MapxusMapSDK/MXMGeoBuilding.h>
#import <MapxusMapSDK/MXMGeoVenue.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMFilterModel : NSObject

// TODO: 删除，只为兼容旧版本
@property (nonatomic, strong, nullable) MXMGeoBuilding *selectedBuilding;
@property (nonatomic, strong, nullable) MXMGeoVenue *selectedVenue;
// TODO: 删除，只为兼容旧版本

@property (nonatomic, strong, nullable) MXMFloor *selectedFloor;
@property (nonatomic, strong, nullable) NSString *selectedBuildingId;
@property (nonatomic, strong, nullable) NSString *selectedVenueId;
// YES表示需要重置选中floor, building, venue并调用回调函数通知选中变化
@property (nonatomic, assign) BOOL shouldCallBack;
// 前景需要过滤显示的floorId队列。nil表示不需要再重新进行过滤，count == 0表示清除所有数据
@property (nonatomic, strong, nullable) NSArray *foreFloorIds;
// 后景需要过滤显示的floorId队列。nil表示不需要再重新进行过滤，count == 0表示清除所有数据
@property (nonatomic, strong, nullable) NSArray *rearFloorIds;
@property (nonatomic, strong, nullable) NSArray *allFloorIds;
// 除外POI id队列，表示被上覆盖的POI，应该不显示出来。nil表示不需要再重新进行过滤，count == 0表示清除所有数据
@property (nonatomic, strong, nullable) NSArray *exceptPoiIds;
// 对于MXMSwitchedByVenue与MXMSwitchedByBuilding模式，使用不同的方式过滤。YES表示数组
// 中的buildingId显示覆盖层；NO表示数组中的buildingId不显示覆盖层
@property (nonatomic, assign) BOOL maskBuildingIdNotInList;
// 覆盖buildingId数组
@property (nonatomic, strong, nullable) NSArray *maskBuildingIds;

@end

NS_ASSUME_NONNULL_END
