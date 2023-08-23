//
//  MXMGeoVenue.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2022/12/14.
//

#import "MXMGeoVenue+Private.h"
#import <YYModel/YYModel.h>
#import "JXJsonFunctionDefine.h"

@implementation MXMGeoVenue

- (id)copyWithZone:(NSZone *)zone
{
  MXMGeoVenue * copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.identifier = self.identifier;
  copyedModel.category = self.category;
  copyedModel.name = self.name;
  copyedModel.name_en = self.name_en;
  copyedModel.name_cn = self.name_cn;
  copyedModel.name_zh = self.name_zh;
  copyedModel.name_ja = self.name_ja;
  copyedModel.name_ko = self.name_ko;
  copyedModel.address = [self.address copy];
  copyedModel.address_en = [self.address_en copy];
  copyedModel.address_cn = [self.address_cn copy];
  copyedModel.address_zh = [self.address_zh copy];
  copyedModel.address_ja = [self.address_ja copy];
  copyedModel.address_ko = [self.address_ko copy];
  copyedModel.bbox = [self.bbox copy];
  copyedModel.buildingIds = self.buildingIds;
  copyedModel.defaultDisplayedBuildingId = self.defaultDisplayedBuildingId;
  copyedModel.defaultDisplayedOrdinal = [self.defaultDisplayedOrdinal copy];
  return copyedModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier": @[@"identifier", @"id"],
    @"category": @[@"category", @"venue"],
    @"name_cn": @[@"name_cn", @"name:zh-Hans"],
    @"name_en": @[@"name_en", @"name:en"],
    @"name_zh": @[@"name_zh", @"name:zh-Hant"],
    @"name_ja": @[@"name_ja", @"name:ja"],
    @"name_ko": @[@"name_ko", @"name:ko"],
    @"defaultDisplayedBuildingId": @[@"defaultDisplayedBuildingId", @"default_displayed_building"]
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  if ([dic[@"building_ids"] isKindOfClass:[NSString class]]) {
    _buildingIds = [dic[@"building_ids"] componentsSeparatedByString:@","];
  }
  
  NSNumber *ordinalNum = DecodeNumberFromDic(dic, @"default_displayed_ordinal");
  if (ordinalNum) {
    _defaultDisplayedOrdinal = [[MXMOrdinal alloc] init];
    _defaultDisplayedOrdinal.level = [ordinalNum integerValue];
  }
  
  // address_default
  if (dic[@"addr:street"]) {
    if (self.address == nil) {
      self.address = [[MXMAddress alloc] init];
    }
    self.address.street = [NSString stringWithFormat:@"%@", dic[@"addr:street"]];
  }
  
  if (dic[@"addr:housenumber"]) {
    if (self.address == nil) {
      self.address = [[MXMAddress alloc] init];
    }
    self.address.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber"]];
  }
  
  // address_en
  if (dic[@"addr:street:en"]) {
    if (self.address_en == nil) {
      self.address_en = [[MXMAddress alloc] init];
    }
    self.address_en.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:en"]];
  }
  
  if (dic[@"addr:housenumber:en"]) {
    if (self.address_en == nil) {
      self.address_en = [[MXMAddress alloc] init];
    }
    self.address_en.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:en"]];
  }
  
  // address_cn
  if (dic[@"addr:street:zh-Hans"]) {
    if (self.address_cn == nil) {
      self.address_cn = [[MXMAddress alloc] init];
    }
    self.address_cn.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:zh-Hans"]];
  }
  
  if (dic[@"addr:housenumber:zh-Hans"]) {
    if (self.address_cn == nil) {
      self.address_cn = [[MXMAddress alloc] init];
    }
    self.address_cn.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:zh-Hans"]];
  }
  
  // address_zh
  if (dic[@"addr:street:zh-Hant"]) {
    if (self.address_zh == nil) {
      self.address_zh = [[MXMAddress alloc] init];
    }
    self.address_zh.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:zh-Hant"]];
  }
  
  if (dic[@"addr:housenumber:zh-Hant"]) {
    if (self.address_zh == nil) {
      self.address_zh = [[MXMAddress alloc] init];
    }
    self.address_zh.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:zh-Hant"]];
  }
  
  // address_ja
  if (dic[@"addr:street:ja"]) {
    if (self.address_ja == nil) {
      self.address_ja = [[MXMAddress alloc] init];
    }
    self.address_ja.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:ja"]];
  }
  
  if (dic[@"addr:housenumber:ja"]) {
    if (self.address_ja == nil) {
      self.address_ja = [[MXMAddress alloc] init];
    }
    self.address_ja.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:ja"]];
  }
  
  // address_ko
  if (dic[@"addr:street:ko"]) {
    if (self.address_ko == nil) {
      self.address_ko = [[MXMAddress alloc] init];
    }
    self.address_ko.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:ko"]];
  }
  
  if (dic[@"addr:housenumber:ko"]) {
    if (self.address_ko == nil) {
      self.address_ko = [[MXMAddress alloc] init];
    }
    self.address_ko.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:ko"]];
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

- (NSString *)venueType {
  return self.category;
}

- (void)setVenueType:(NSString *)venueType {
  self.category = venueType;
}

- (NSArray<NSString *> *)buildingIds {
  if (!_buildingIds) {
    _buildingIds = @[];
  }
  return _buildingIds;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end
