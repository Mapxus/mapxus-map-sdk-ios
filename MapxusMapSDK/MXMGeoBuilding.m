//
//  MXMGeoBuilding.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoBuilding.h"

@implementation MXMGeoBuilding

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_cn" : @"name:cn",
             @"name_en" : @"name:en",
             @"name_zh" : @"name:zh",
             @"identifier" : @"id",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *keys = [dic allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"floors"] && [dic[key] isKindOfClass:[NSString class]]) {
            if (_underground) {
                _floors = [dic[key] componentsSeparatedByString:@","];
            } else {
                _floors = [[[dic[key] componentsSeparatedByString:@","] reverseObjectEnumerator] allObjects];
            }
        }
    }
    
    return YES;
}

@end
