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
    copyedModel.venueId = self.venueId;
    copyedModel.name = self.name;
    copyedModel.name_en = self.name_en;
    copyedModel.name_cn = self.name_cn;
    copyedModel.name_zh = self.name_zh;
    copyedModel.floors = [self.floors copy];
    copyedModel.floorIds = [self.floorIds copy];
    copyedModel.ordinals = [self.ordinals copy];
    copyedModel.ground_floor = self.ground_floor;
    copyedModel.type = self.type;
    return copyedModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_cn" : @"name:zh-Hans",
             @"name_en" : @"name:en",
             @"name_zh" : @"name:zh-Hant",
             @"identifier" : @"id",
             @"venueId" : @"ref:venue",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {    
    if ([dic[@"level_ids"] isKindOfClass:[NSString class]]) {
        _floorIds = [dic[@"level_ids"] componentsSeparatedByString:@","];
    }
    
    if ([dic[@"level_names"] isKindOfClass:[NSString class]]) {
        _floors = [dic[@"level_names"] componentsSeparatedByString:@","];
    }
    
    if ([dic[@"ordinals"] isKindOfClass:[NSString class]]) {
        NSArray *ordStr = [dic[@"ordinals"] componentsSeparatedByString:@","];
        NSMutableArray *muArr = [NSMutableArray array];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        int i = 0;
        for (NSString *o in ordStr) {
            NSNumber *result;
            result = [f numberFromString:o];
            if (result) {
                [muArr addObject:result];
                if ([result intValue] == 0) {
                    [self getGround:i];
                }
            }
            i++;
        }
        _ordinals = [muArr copy];
    }
    
    return YES;
}

- (void)getGround:(int)index
{
    if (_floors.count > index) {
        _ground_floor = _floors[index];
    }
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}

- (NSString *)building {
    if (!_building) {
        _building = @"";
    }
    return _building;
}

- (NSArray<NSString *> *)floors {
    if (!_floors) {
        _floors = @[];
    }
    return _floors;
}

- (NSArray<NSString *> *)floorIds {
    if (!_floorIds) {
        _floorIds = @[];
    }
    return _floorIds;
}

- (NSArray<NSNumber *> *)ordinals {
    if (!_ordinals) {
        _ordinals = @[];
    }
    return _ordinals;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
