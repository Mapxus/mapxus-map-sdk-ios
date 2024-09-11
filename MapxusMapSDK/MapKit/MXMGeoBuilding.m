//
//  MXMGeoBuilding.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoBuilding+Private.h"
#import <YYModel/YYModel.h>
#import "JXJsonFunctionDefine.h"

@implementation MXMGeoBuilding

- (id)copyWithZone:(NSZone *)zone
{
  MXMGeoBuilding * copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.identifier = self.identifier;
  copyedModel.category = self.category;
  copyedModel.venueId = self.venueId;
  copyedModel.nameMap = [self.nameMap copy];
  copyedModel.floors = [[NSArray alloc] initWithArray:self.floors copyItems:YES];
  copyedModel.bbox = [self.bbox copy];
  copyedModel.groundFloor = self.groundFloor;
  copyedModel.defaultDisplayedFloorId = self.defaultDisplayedFloorId;
  copyedModel.type = self.type;
  copyedModel.overlapBuildingIds = self.overlapBuildingIds;
  return copyedModel;
}

+ (NSArray *)modelPropertyBlacklist {
  return @[@"overlapBuildingIds"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier" : @[@"identifier", @"id"],
    @"category" : @[@"category", @"building"],
    @"venueId" : @[@"venueId", @"ref:venue"],
    @"defaultDisplayedFloorId": @[@"defaultDisplayedFloorId", @"default_displayed_floor"]
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  
  self.nameMap.Default = DecodeStringFromDic(dic, @"name");
  self.nameMap.en = DecodeStringFromDic(dic, @"name:en");
  self.nameMap.zh_Hans = DecodeStringFromDic(dic, @"name:zh-Hans");
  self.nameMap.zh_Hant = DecodeStringFromDic(dic, @"name:zh-Hant");
  self.nameMap.ja = DecodeStringFromDic(dic, @"name:ja");
  self.nameMap.ko = DecodeStringFromDic(dic, @"name:ko");
  self.nameMap.fil = DecodeStringFromDic(dic, @"name:fil");
  self.nameMap._id = DecodeStringFromDic(dic, @"name:id");
  self.nameMap.pt = DecodeStringFromDic(dic, @"name:pt");
  self.nameMap.th = DecodeStringFromDic(dic, @"name:th");
  self.nameMap.vi = DecodeStringFromDic(dic, @"name:vi");

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

- (NSString *)name {
  return self.nameMap.Default;
}

- (void)setName:(NSString *)name {
  self.nameMap.Default = name;
}

- (NSString *)name_en {
  return self.nameMap.en;
}

- (void)setName_en:(NSString *)name_en {
  self.nameMap.en = name_en;
}

- (NSString *)name_cn {
  return self.nameMap.zh_Hans;
}

- (void)setName_cn:(NSString *)name_cn {
  self.nameMap.zh_Hans = name_cn;
}

- (NSString *)name_zh {
  return self.nameMap.zh_Hant;
}

- (void)setName_zh:(NSString *)name_zh {
  self.nameMap.zh_Hant = name_zh;
}

- (NSString *)name_ja {
  return self.nameMap.ja;
}

- (void)setName_ja:(NSString *)name_ja {
  self.nameMap.ja = name_ja;
}

- (NSString *)name_ko {
  return self.nameMap.ko;
}

- (void)setName_ko:(NSString *)name_ko {
  self.nameMap.ko = name_ko;
}

- (MXMultilingualObject<NSString *> *)nameMap {
  if (!_nameMap) {
    _nameMap = [[MXMultilingualObject alloc] init];
  }
  return _nameMap;
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

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end
