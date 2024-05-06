//
//  MXMGeoPOI.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoPOI+Private.h"
#import <YYModel/YYModel.h>
#import "JXJsonFunctionDefine.h"

@implementation MXMGeoPOI

- (id)copyWithZone:(NSZone *)zone
{
  MXMGeoPOI * copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.identifier = self.identifier;
  copyedModel.buildingId = self.buildingId;
  copyedModel.floor = [self.floor copy];
  copyedModel.coordinate = self.coordinate;
  copyedModel.nameMap = [self.nameMap copy];
  copyedModel.accessibilityDetailMap = [self.accessibilityDetailMap copy];
  copyedModel.category = self.category;
  copyedModel.overlapFloorIds = self.overlapFloorIds;
  return copyedModel;
}

+ (NSArray *)modelPropertyBlacklist {
  return @[@"overlapFloorIds"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier" : @[@"identifier", @"properties.osm:ref"],
    @"buildingId" : @[@"buildingId", @"properties.ref:building"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  
  NSDictionary *geometry = DecodeDicFromDic(dic, @"geometry");
  NSArray *coordList = DecodeArrayFromDic(geometry, @"coordinates");
  NSNumber *lon = coordList.firstObject;
  NSNumber *lat = coordList.lastObject;
  self.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
  
  NSDictionary *properties = DecodeDicFromDic(dic, @"properties");
  
  self.nameMap.Default = DecodeStringFromDic(properties, @"name");
  self.nameMap.en = DecodeStringFromDic(properties, @"name:en");
  self.nameMap.zh_Hans = DecodeStringFromDic(properties, @"name:zh-Hans");
  self.nameMap.zh_Hant = DecodeStringFromDic(properties, @"name:zh-Hant");
  self.nameMap.ja = DecodeStringFromDic(properties, @"name:ja");
  self.nameMap.ko = DecodeStringFromDic(properties, @"name:ko");
  
  self.accessibilityDetailMap.Default = DecodeStringFromDic(properties, @"accessibility_detail");
  self.accessibilityDetailMap.en = DecodeStringFromDic(properties, @"accessibility_detail:en");
  self.accessibilityDetailMap.zh_Hans = DecodeStringFromDic(properties, @"accessibility_detail:zh-Hans");
  self.accessibilityDetailMap.zh_Hant = DecodeStringFromDic(properties, @"accessibility_detail:zh-Hant");
  self.accessibilityDetailMap.ja = DecodeStringFromDic(properties, @"accessibility_detail:ja");
  self.accessibilityDetailMap.ko = DecodeStringFromDic(properties, @"accessibility_detail:ko");
  
  NSString *categoryStr = DecodeStringFromDic(properties, @"place");
  if (categoryStr) {
    _category = [categoryStr componentsSeparatedByString:@","];
  }
  
  NSString *floorId = DecodeStringFromDic(properties, @"ref:level");
  if (floorId) {
    _floor = [[MXMFloor alloc] init];
    _floor.floorId = floorId;
    _floor.code = @"";
  }
  
  NSString *overlap = DecodeStringFromDic(properties, @"overlap");
  if (overlap) {
    _overlapFloorIds = [overlap componentsSeparatedByString:@","];
  }
  
  return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
  NSDictionary *coorDic = @{
    @"latitude": @(self.coordinate.latitude),
    @"longitude": @(self.coordinate.longitude)
  };
  dic[@"coordinate"] = coorDic;
  return YES;
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

- (NSString *)accessibilityDetail {
  return self.accessibilityDetailMap.Default;
}

- (void)setAccessibilityDetail:(NSString *)accessibilityDetail {
  self.accessibilityDetailMap.Default = accessibilityDetail;
}

- (NSString *)accessibilityDetail_en {
  return self.accessibilityDetailMap.en;
}

- (void)setAccessibilityDetail_en:(NSString *)accessibilityDetail_en {
  self.accessibilityDetailMap.en = accessibilityDetail_en;
}

- (NSString *)accessibilityDetail_cn {
  return self.accessibilityDetailMap.zh_Hans;
}

- (void)setAccessibilityDetail_cn:(NSString *)accessibilityDetail_cn {
  self.accessibilityDetailMap.zh_Hans = accessibilityDetail_cn;
}

- (NSString *)accessibilityDetail_zh {
  return self.accessibilityDetailMap.zh_Hant;
}

- (void)setAccessibilityDetail_zh:(NSString *)accessibilityDetail_zh {
  self.accessibilityDetailMap.zh_Hant = accessibilityDetail_zh;
}

- (NSString *)accessibilityDetail_ja {
  return self.accessibilityDetailMap.ja;
}

- (void)setAccessibilityDetail_ja:(NSString *)accessibilityDetail_ja {
  self.accessibilityDetailMap.ja = accessibilityDetail_ja;
}

- (NSString *)accessibilityDetail_ko {
  return self.accessibilityDetailMap.ko;
}

- (void)setAccessibilityDetail_ko:(NSString *)accessibilityDetail_ko {
  self.accessibilityDetailMap.ko = accessibilityDetail_ko;
}

- (MXMultilingualObject<NSString *> *)accessibilityDetailMap {
  if (!_accessibilityDetailMap) {
    _accessibilityDetailMap = [[MXMultilingualObject alloc] init];
  }
  return _accessibilityDetailMap;
}

- (NSString *)identifier {
  if (!_identifier) {
    _identifier = @"";
  }
  return _identifier;
}

- (NSArray<NSString *> *)category {
  if (!_category) {
    _category = @[];
  }
  return _category;
}

- (NSString *)description {
  return [self yy_modelDescription];
}
@end
