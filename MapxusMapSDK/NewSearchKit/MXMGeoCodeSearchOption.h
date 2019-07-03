//
//  MXMGeoCodeSearchOption.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 反地理编码参数信息类
 */
@interface MXMReverseGeoCodeSearchOption : NSObject
/// 待解析的经纬度坐标（必选）
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// 所在楼数，对应 CLLocation 中的 floor.level
@property (nonatomic, strong) NSNumber *ordinalFloor;
@end

NS_ASSUME_NONNULL_END
