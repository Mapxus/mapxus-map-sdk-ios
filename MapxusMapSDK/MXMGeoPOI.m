//
//  MXMGeoPOI.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoPOI.h"

@implementation MXMGeoPOI

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"identifier" : @"osm:ref",
             @"buildingId" : @"ref:building",
             @"name_cn" : @"name:cn",
             @"name_en" : @"name:en",
             @"name_zh" : @"name:zh"};
}

@end
