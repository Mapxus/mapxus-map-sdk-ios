//
//  MXMGeoPOI.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXMGeoPOI : NSObject

/// POI的ID
@property (nonatomic, strong) NSString *identifier;
/// POI所在建筑的建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// POI默认名字
@property (nonatomic, strong) NSString *name;
/// POI英文名字
@property (nonatomic, strong) NSString *name_en;
/// POI简体中文名字
@property (nonatomic, strong) NSString *name_cn;
/// POI繁体中文名字
@property (nonatomic, strong) NSString *name_zh;
/// POI所在楼层
@property (nonatomic, strong) NSString *floor;

@end
