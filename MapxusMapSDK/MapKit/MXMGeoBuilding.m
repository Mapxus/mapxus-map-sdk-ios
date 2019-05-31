//
//  MXMGeoBuilding.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoBuilding.h"
#import <YYModel/YYModel.h>

@implementation MXMGeoBuilding

- (id)copyWithZone:(NSZone *)zone
{
    MXMGeoBuilding * copyedModel = [[self.class allocWithZone:zone] init];
    copyedModel.identifier = self.identifier;
    copyedModel.building = self.building;
    copyedModel.name = self.name;
    copyedModel.name_en = self.name_en;
    copyedModel.name_cn = self.name_cn;
    copyedModel.name_zh = self.name_zh;
    copyedModel.floors = [self.floors copy];
    copyedModel.ground_floor = self.ground_floor;
    copyedModel.type = self.type;
    copyedModel.underground = self.underground;
    copyedModel.layer = self.layer;
    return copyedModel;
}

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

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
