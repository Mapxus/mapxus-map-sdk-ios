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
    copyedModel.category = self.category;
    copyedModel.venueId = self.venueId;
    copyedModel.name = self.name;
    copyedModel.name_en = self.name_en;
    copyedModel.name_cn = self.name_cn;
    copyedModel.name_zh = self.name_zh;
    copyedModel.name_ja = self.name_ja;
    copyedModel.name_ko = self.name_ko;
    copyedModel.floors = [[NSArray alloc] initWithArray:self.floors copyItems:YES];
    copyedModel.bbox = [self.bbox copy];
    copyedModel.groundFloor = self.groundFloor;
    copyedModel.defaultDisplayedFloorId = self.defaultDisplayedFloorId;
    copyedModel.type = self.type;

    return copyedModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_cn" : @[@"name_cn", @"name:zh-Hans"],
             @"name_en" : @[@"name_en", @"name:en"],
             @"name_zh" : @[@"name_zh", @"name:zh-Hant"],
             @"name_ja" : @[@"name_ja", @"name:ja"],
             @"name_ko" : @[@"name_ko", @"name:ko"],
             @"identifier" : @[@"identifier", @"id"],
             @"category" : @[@"category", @"building"],
             @"venueId" : @[@"venueId", @"ref:venue"],
             @"defaultDisplayedFloorId": @[@"defaultDisplayedFloorId", @"default_displayed_floor"]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *floorIds = nil;
    if ([dic[@"level_ids"] isKindOfClass:[NSString class]]) {
        floorIds = [dic[@"level_ids"] componentsSeparatedByString:@","];
    }
    
    NSArray *floorCodes = nil;
    if ([dic[@"level_names"] isKindOfClass:[NSString class]]) {
        floorCodes = [dic[@"level_names"] componentsSeparatedByString:@","];
    }
    
    NSArray *floorOrdinals = nil;
    if ([dic[@"ordinals"] isKindOfClass:[NSString class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSArray *ordStr = [dic[@"ordinals"] componentsSeparatedByString:@","];
        
        NSMutableArray *muArr = [NSMutableArray array];
        for (NSString *o in ordStr) {
            NSNumber *result = [formatter numberFromString:o];
            if (result) {
                MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
                ordinal.level = [result integerValue];
                [muArr addObject:ordinal];
                // Find the ground floor
                if (ordinal.level == 0) {
                    NSUInteger i = [ordStr indexOfObject:o];
                    if (floorCodes.count > i) {
                        _groundFloor = floorCodes[i];
                    }
                }
            } else {
                [muArr addObject:[NSNull null]];
            }
        }
        floorOrdinals = [muArr copy];
    }
    
    // 数组合并
    NSMutableArray *all = [[NSMutableArray alloc] init];
    for (int i=0; i<floorIds.count; i++) {
        MXMFloor *floor = [[MXMFloor alloc] init];
        floor.floorId = floorIds[i];
        floor.code = (floorCodes.count > i) ? floorCodes[i] : @"";
        if (floorOrdinals.count > i && [floorOrdinals[i] isKindOfClass:[MXMOrdinal class]]) {
            floor.ordinal = floorOrdinals[i];
        }
        [all addObject:floor];
    }
    
    _floors = [all copy];
  
    if ([dic[@"overlap"] isKindOfClass:[NSString class]]) {
      _overlapBuildingIds = [dic[@"overlap"] componentsSeparatedByString:@","];
    }

    return YES;
}


- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}

- (NSString *)category {
  if (!_category) {
    _category = @"";
  }
  return _category;
}

- (NSString *)building {
    return self.category;
}

- (void)setBuilding:(NSString *)building {
  self.category = building;
}

- (NSString *)venueId {
  if (!_venueId) {
    _venueId = @"";
  }
  return _venueId;
}

- (NSArray<MXMFloor *> *)floors {
    if (!_floors) {
        _floors = @[];
    }
    return _floors;
}

- (NSArray<NSString *> *)overlapBuildingIds {
  if (!_overlapBuildingIds) {
    _overlapBuildingIds = @[];
  }
  return _overlapBuildingIds;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
