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
  copyedModel.nameMap = [self.nameMap copy];
  copyedModel.addressMap = [self.addressMap copy];
  copyedModel.bbox = [self.bbox copy];
  copyedModel.buildingIds = self.buildingIds;
  copyedModel.defaultDisplayedBuildingId = self.defaultDisplayedBuildingId;
  copyedModel.defaultDisplayedOrdinal = [self.defaultDisplayedOrdinal copy];
  return copyedModel;
}

+ (NSArray *)modelPropertyBlacklist {
  return @[@"defaultDisplayedOrdinal"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier": @[@"identifier", @"id"],
    @"category": @[@"category", @"venue"],
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
  self.nameMap.ar = DecodeStringFromDic(dic, @"name:ar");

  // address_default
  NSString *street = DecodeStringFromDic(dic, @"addr:street");
  NSString *houseNumber = DecodeStringFromDic(dic, @"addr:housenumber");
  if (street || houseNumber) {
    self.addressMap.Default = [[MXMAddress alloc] init];
    self.addressMap.Default.street = street;
    self.addressMap.Default.housenumber = houseNumber;
  }
  
  // address_en
  street = DecodeStringFromDic(dic, @"addr:street:en");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:en");
  if (street || houseNumber) {
    self.addressMap.en = [[MXMAddress alloc] init];
    self.addressMap.en.street = street;
    self.addressMap.en.housenumber = houseNumber;
  }
  
  // address_cn
  street = DecodeStringFromDic(dic, @"addr:street:zh-Hans");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:zh-Hans");
  if (street || houseNumber) {
    self.addressMap.zh_Hans = [[MXMAddress alloc] init];
    self.addressMap.zh_Hans.street = street;
    self.addressMap.zh_Hans.housenumber = houseNumber;
  }
  
  // address_zh
  street = DecodeStringFromDic(dic, @"addr:street:zh-Hant");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:zh-Hant");
  if (street || houseNumber) {
    self.addressMap.zh_Hant = [[MXMAddress alloc] init];
    self.addressMap.zh_Hant.street = street;
    self.addressMap.zh_Hant.housenumber = houseNumber;
  }
  
  // address_ja
  street = DecodeStringFromDic(dic, @"addr:street:ja");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:ja");
  if (street || houseNumber) {
    self.addressMap.ja = [[MXMAddress alloc] init];
    self.addressMap.ja.street = street;
    self.addressMap.ja.housenumber = houseNumber;
  }
  
  // address_ko
  street = DecodeStringFromDic(dic, @"addr:street:ko");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:ko");
  if (street || houseNumber) {
    self.addressMap.ko = [[MXMAddress alloc] init];
    self.addressMap.ko.street = street;
    self.addressMap.ko.housenumber = houseNumber;
  }
  
  // address_fil
  street = DecodeStringFromDic(dic, @"addr:street:fil");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:fil");
  if (street || houseNumber) {
    self.addressMap.fil = [[MXMAddress alloc] init];
    self.addressMap.fil.street = street;
    self.addressMap.fil.housenumber = houseNumber;
  }

  // address_id
  street = DecodeStringFromDic(dic, @"addr:street:id");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:id");
  if (street || houseNumber) {
    self.addressMap._id = [[MXMAddress alloc] init];
    self.addressMap._id.street = street;
    self.addressMap._id.housenumber = houseNumber;
  }

  // address_pt
  street = DecodeStringFromDic(dic, @"addr:street:pt");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:pt");
  if (street || houseNumber) {
    self.addressMap.pt = [[MXMAddress alloc] init];
    self.addressMap.pt.street = street;
    self.addressMap.pt.housenumber = houseNumber;
  }

  // address_th
  street = DecodeStringFromDic(dic, @"addr:street:th");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:th");
  if (street || houseNumber) {
    self.addressMap.th = [[MXMAddress alloc] init];
    self.addressMap.th.street = street;
    self.addressMap.th.housenumber = houseNumber;
  }

  // address_vi
  street = DecodeStringFromDic(dic, @"addr:street:vi");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:vi");
  if (street || houseNumber) {
    self.addressMap.vi = [[MXMAddress alloc] init];
    self.addressMap.vi.street = street;
    self.addressMap.vi.housenumber = houseNumber;
  }
  
  // address_ar
  street = DecodeStringFromDic(dic, @"addr:street:ar");
  houseNumber = DecodeStringFromDic(dic, @"addr:housenumber:ar");
  if (street || houseNumber) {
    self.addressMap.ar = [[MXMAddress alloc] init];
    self.addressMap.ar.street = street;
    self.addressMap.ar.housenumber = houseNumber;
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

- (MXMAddress *)address {
  return self.addressMap.Default;
}

- (void)setAddress:(MXMAddress *)address {
  self.addressMap.Default = address;
}

- (MXMAddress *)address_en {
  return self.addressMap.en;
}

- (void)setAddress_en:(MXMAddress *)address_en {
  self.addressMap.en = address_en;
}

- (MXMAddress *)address_cn {
  return self.addressMap.zh_Hans;
}

- (void)setAddress_cn:(MXMAddress *)address_cn {
  self.addressMap.zh_Hans = address_cn;
}

- (MXMAddress *)address_zh {
  return self.addressMap.zh_Hant;
}

- (void)setAddress_zh:(MXMAddress *)address_zh {
  self.addressMap.zh_Hant = address_zh;
}

- (MXMAddress *)address_ja {
  return self.addressMap.ja;
}

- (void)setAddress_ja:(MXMAddress *)address_ja {
  self.addressMap.ja = address_ja;
}

- (MXMAddress *)address_ko {
  return self.addressMap.ko;
}

- (void)setAddress_ko:(MXMAddress *)address_ko {
  self.addressMap.ko = address_ko;
}

- (MXMultilingualObject<NSString *> *)nameMap {
  if (!_nameMap) {
    _nameMap = [[MXMultilingualObject alloc] init];
  }
  return _nameMap;
}

- (MXMultilingualObject<MXMAddress *> *)addressMap {
  if (!_addressMap) {
    _addressMap = [[MXMultilingualObject alloc] init];
  }
  return _addressMap;
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
