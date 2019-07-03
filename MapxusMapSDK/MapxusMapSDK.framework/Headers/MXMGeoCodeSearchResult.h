//
//  MXMGeoCodeSearchResult.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

/**
 反地理编码结果类
 */
@interface MXMReverseGeoCodeSearchResult : NSObject
/// 查询定位所在建筑的信息，只返回 buildingId 与 name 信息
@property (nonatomic, strong) MXMBuilding *building;
/// 查询定位所在楼层的信息
@property (nonatomic, strong) MXMFloor *floor;
@end

NS_ASSUME_NONNULL_END
