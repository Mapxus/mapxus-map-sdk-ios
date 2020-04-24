//
//  MXMGeoPOI.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 瓦片中的POI数据
 */
@interface MXMGeoPOI : NSObject

/// POI的ID
@property (nonatomic, strong) NSString *identifier;
/// POI所在建筑的建筑ID
@property (nonatomic, strong, nullable) NSString *buildingId;
/// POI所在楼层
@property (nonatomic, strong, nullable) NSString *floor;
/// POI所在楼层的id
@property (nonatomic, strong, nullable) NSString *floorId;
/// POI所在楼层的定位高度值
@property (nonatomic, strong, nullable) NSNumber *ordinal;
/// POI所在经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/// POI默认名字
@property (nonatomic, strong, nullable) NSString *name;
/// POI英文名字
@property (nonatomic, strong, nullable) NSString *name_en;
/// POI简体中文名字
@property (nonatomic, strong, nullable) NSString *name_cn;
/// POI繁体中文名字
@property (nonatomic, strong, nullable) NSString *name_zh;
/// POI日语名字
@property (nonatomic, strong, nullable) NSString *name_ja;
/// POI韩语名字
@property (nonatomic, strong, nullable) NSString *name_ko;
/// 无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail;
/// 英文无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_en;
/// 简体中文无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_cn;
/// 繁体中文无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_zh;
/// 日语无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ja;
/// 韩语无障碍资讯
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ko;
/// POI分类
@property (nonatomic, strong) NSArray<NSString*> *category;

@end

NS_ASSUME_NONNULL_END
