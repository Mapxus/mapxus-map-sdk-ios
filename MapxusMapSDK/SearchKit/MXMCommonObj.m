//
//  MXMCommonObj.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCommonObj.h"
#import "JXJsonFunctionDefine.h"
#import <YYModel/YYModel.h>

@implementation MXMCategory

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"categoryId" : @[@"categoryId", @"id"],
    @"categoryDescription" : @[@"categoryDescription", @"description"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  NSDictionary *titleDic = DecodeDicFromDic(dic, @"title");
  self.titleMap.Default = DecodeStringFromDic(titleDic, @"default");
  self.titleMap.en = DecodeStringFromDic(titleDic, @"en");
  self.titleMap.zh_Hans = DecodeStringFromDic(titleDic, @"zh-Hans");
  self.titleMap.zh_Hant = DecodeStringFromDic(titleDic, @"zh-Hant");
  self.titleMap.ja = DecodeStringFromDic(titleDic, @"ja");
  self.titleMap.ko = DecodeStringFromDic(titleDic, @"ko");
  return YES;
}

- (NSString *)title_en {
  return self.titleMap.en;
}

- (void)setTitle_en:(NSString *)title_en {
  self.titleMap.en = title_en;
}

- (NSString *)title_cn {
  return self.titleMap.zh_Hans;
}

- (void)setTitle_cn:(NSString *)title_cn {
  self.titleMap.zh_Hans = title_cn;
}

- (NSString *)title_zh {
  return self.titleMap.zh_Hant;
}

- (void)setTitle_zh:(NSString *)title_zh {
  self.titleMap.zh_Hant = title_zh;
}

- (NSString *)categoryId {
  if (!_categoryId) {
    _categoryId = @"";
  }
  return _categoryId;
}

- (NSString *)category {
  if (!_category) {
    _category = @"";
  }
  return _category;
}

- (MXMultilingualObject<NSString *> *)titleMap {
  if (!_titleMap) {
    _titleMap = [[MXMultilingualObject alloc] init];
  }
  return _titleMap;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMGeoPoint

//
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng
{
  MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
  point.latitude = lat;
  point.longitude = lng;
  return point;
}

+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng elevation:(double)ele
{
  MXMGeoPoint *point = [[MXMGeoPoint alloc] init];
  point.latitude = lat;
  point.longitude = lng;
  point.elevation = ele;
  return point;
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{@"latitude" : @[@"latitude", @"lat"],
           @"longitude" : @[@"longitude", @"lon"],
  };
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMIndoorPoint

+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                              buildingId:(nullable NSString *)buildingId
                                 floorId:(nullable NSString *)floorId {
  MXMIndoorPoint *point = [[MXMIndoorPoint alloc] init];
  point.latitude = lat;
  point.longitude = lng;
  point.buildingId = buildingId;
  point.floorId = floorId;
  return point;
}


+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                                building:(NSString *)buildingId
                                   floor:(NSString *)floor
{
  MXMIndoorPoint *point = [[MXMIndoorPoint alloc] init];
  point.latitude = lat;
  point.longitude = lng;
  point.buildingId = buildingId;
  point.floor = floor;
  return point;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end




//
@implementation MXMBoundingBox

- (id)copyWithZone:(NSZone *)zone {
  MXMBoundingBox *copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.min_latitude = self.min_latitude;
  copyedModel.min_longitude = self.min_longitude;
  copyedModel.max_latitude = self.max_latitude;
  copyedModel.max_longitude = self.max_longitude;
  return  copyedModel;
}

+ (MXMBoundingBox *)boundingBoxWithMinLatitude:(double)min_lat minLongitude:(double)min_lng maxLatitude:(double)max_lat maxLongitude:(double)max_lng
{
  MXMBoundingBox *box = [[MXMBoundingBox alloc] init];
  box.min_latitude = min_lat;
  box.min_longitude = min_lng;
  box.max_latitude = max_lat;
  box.max_longitude = max_lng;
  return box;
}

+ (nullable MXMBoundingBox *)boundingBoxWithPoints:(NSArray<MXMGeoPoint *> *)points {
  if (points.count == 0) {
    return nil;
  }
  
  MXMGeoPoint *firstPoint = points.firstObject;
  
  MXMBoundingBox *bbox = [[MXMBoundingBox alloc] init];
  bbox.min_latitude = firstPoint.latitude;
  bbox.max_latitude = firstPoint.latitude;
  bbox.min_longitude = firstPoint.longitude;
  bbox.max_longitude = firstPoint.longitude;
  
  for (MXMGeoPoint *point in points) {
    bbox.min_latitude = MIN(point.latitude, bbox.min_latitude);
    bbox.max_latitude = MAX(point.latitude, bbox.max_latitude);
    bbox.min_longitude = MIN(point.longitude, bbox.min_longitude);
    bbox.max_longitude = MAX(point.longitude, bbox.max_longitude);
  }
  return bbox;
}

- (BOOL)contains:(CLLocationCoordinate2D)coordinate ignoreBoundary:(BOOL)ignoreBoundary {
  if (ignoreBoundary) {
    return self.min_latitude < coordinate.latitude
    && self.max_latitude > coordinate.latitude
    && self.min_longitude < coordinate.longitude
    && self.max_longitude > coordinate.longitude;
  } else {
    return self.min_latitude <= coordinate.latitude
    && self.max_latitude >= coordinate.latitude
    && self.min_longitude <= coordinate.longitude
    && self.max_longitude >= coordinate.longitude;
  }
}


+ (NSDictionary *)modelCustomPropertyMapper {
  return @{@"min_latitude" : @[@"min_latitude", @"minLat"],
           @"min_longitude" : @[@"min_longitude", @"minLon"],
           @"max_latitude" : @[@"max_latitude", @"maxLat"],
           @"max_longitude" : @[@"max_longitude", @"maxLon"],
  };
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end


//
@implementation MXMAddress

- (id)copyWithZone:(NSZone *)zone {
  MXMAddress *copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.housenumber = self.housenumber;
  copyedModel.street = self.street;
  return  copyedModel;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end




@implementation MXMOrdinal
- (id)copyWithZone:(NSZone *)zone
{
  MXMOrdinal *copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.level = self.level;
  
  return copyedModel;
}
@end




@implementation MXMFloor

- (id)copyWithZone:(NSZone *)zone
{
  MXMFloor *copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.floorId = self.floorId;
  copyedModel.code = self.code;
  copyedModel.ordinal = [self.ordinal copy];
  
  return copyedModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{@"floorId" : @[@"floorId", @"id"],
  };
}

/// make sure return not null
- (NSString *)floorId {
  if (!_floorId) {
    _floorId = @"";
  }
  return _floorId;
}

/// make sure return not null
- (NSString *)code {
  if (!_code) {
    _code = @"";
  }
  return _code;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end


@implementation MXMFloorInfo

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"hasVisualMap" : @[@"hasVisualMap", @"visualMap"],
    @"hasSignalMap" : @[@"hasSignalMap", @"signalMap"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  _floor = [[MXMFloor alloc] init];
  _floor.floorId = DecodeStringFromDic(dic, @"id");
  _floor.code = DecodeStringFromDic(dic, @"code");
  
  NSNumber *result = DecodeNumberFromDic(dic, @"ordinal");
  if (result) {
    MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
    ordinal.level = [result integerValue];
    _floor.ordinal = ordinal;
  }
  
  return YES;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMBuilding

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"buildingId" : @[@"buildingId", @"id"],
    @"defaultDisplayedFloorId" : @[@"defaultDisplayedFloorId", @"defaultFloor"],
    @"category" : @[@"category", @"type"],
    @"hasVisualMap" : @[@"hasVisualMap", @"visualMap"],
    @"hasSignalMap" : @[@"hasSignalMap", @"signalMap"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  NSDictionary *buildingNameDic = DecodeDicFromDic(dic, @"buildingName");
  self.buildingNameMap.Default = DecodeStringFromDic(buildingNameDic, @"default");
  self.buildingNameMap.en = DecodeStringFromDic(buildingNameDic, @"en");
  self.buildingNameMap.zh_Hans = DecodeStringFromDic(buildingNameDic, @"zh-Hans");
  self.buildingNameMap.zh_Hant = DecodeStringFromDic(buildingNameDic, @"zh-Hant");
  self.buildingNameMap.ja = DecodeStringFromDic(buildingNameDic, @"ja");
  self.buildingNameMap.ko = DecodeStringFromDic(buildingNameDic, @"ko");
  
  NSDictionary *nameDic = DecodeDicFromDic(dic, @"name");
  self.nameMap.Default = DecodeStringFromDic(nameDic, @"default");
  self.nameMap.en = DecodeStringFromDic(nameDic, @"en");
  self.nameMap.zh_Hans = DecodeStringFromDic(nameDic, @"zh-Hans");
  self.nameMap.zh_Hant = DecodeStringFromDic(nameDic, @"zh-Hant");
  self.nameMap.ja = DecodeStringFromDic(nameDic, @"ja");
  self.nameMap.ko = DecodeStringFromDic(nameDic, @"ko");
  
  NSDictionary *venueNameDic = DecodeDicFromDic(dic, @"venueName");
  self.venueNameMap.Default = DecodeStringFromDic(venueNameDic, @"default");
  self.venueNameMap.en = DecodeStringFromDic(venueNameDic, @"en");
  self.venueNameMap.zh_Hans = DecodeStringFromDic(venueNameDic, @"zh-Hans");
  self.venueNameMap.zh_Hant = DecodeStringFromDic(venueNameDic, @"zh-Hant");
  self.venueNameMap.ja = DecodeStringFromDic(venueNameDic, @"ja");
  self.venueNameMap.ko = DecodeStringFromDic(venueNameDic, @"ko");
  
  NSDictionary *addressDic = DecodeDicFromDic(dic, @"address");
  self.addressMap.Default = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"default")];
  self.addressMap.en = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"en")];
  self.addressMap.zh_Hans = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"zh-Hans")];
  self.addressMap.zh_Hant = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"zh-Hant")];
  self.addressMap.ja = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"ja")];
  self.addressMap.ko = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"ko")];
  
  return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"floors" : [MXMFloorInfo class]};
}

- (NSString *)name_default {
  return self.nameMap.Default;
}

- (void)setName_default:(NSString *)name_default {
  self.nameMap.Default = name_default;
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

- (NSString *)venueName_default {
  return self.venueNameMap.Default;
}

- (void)setVenueName_default:(NSString *)venueName_default {
  self.venueNameMap.Default = venueName_default;
}

- (NSString *)venueName_en {
  return self.venueNameMap.en;
}

- (void)setVenueName_en:(NSString *)venueName_en {
  self.venueNameMap.en = venueName_en;
}

- (NSString *)venueName_cn {
  return self.venueNameMap.zh_Hans;
}

- (void)setVenueName_cn:(NSString *)venueName_cn {
  self.venueNameMap.zh_Hans = venueName_cn;
}

- (NSString *)venueName_zh {
  return self.venueNameMap.zh_Hant;
}

- (void)setVenueName_zh:(NSString *)venueName_zh {
  self.venueNameMap.zh_Hant = venueName_zh;
}

- (NSString *)venueName_ja {
  return self.venueNameMap.ja;
}

- (void)setVenueName_ja:(NSString *)venueName_ja {
  self.venueNameMap.ja = venueName_ja;
}

- (NSString *)venueName_ko {
  return self.venueNameMap.ko;
}

- (void)setVenueName_ko:(NSString *)venueName_ko {
  self.venueNameMap.ko = venueName_ko;
}

- (MXMAddress *)address_default {
  return self.addressMap.Default;
}

- (void)setAddress_default:(MXMAddress *)address_default {
  self.addressMap.Default = address_default;
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

-(void)setAddress_cn:(MXMAddress *)address_cn {
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

- (NSArray<MXMFloorInfo *> *)floors {
  if (!_floors) {
    _floors = @[];
  }
  return _floors;
}

- (NSString *)buildingId {
  if (!_buildingId) {
    _buildingId = @"";
  }
  return _buildingId;
}

- (NSString *)venueId {
  if (!_venueId) {
    _venueId = @"";
  }
  return _venueId;
}

- (MXMultilingualObject<NSString *> *)buildingNameMap {
  if (!_buildingNameMap) {
    _buildingNameMap = [[MXMultilingualObject alloc] init];
  }
  return _buildingNameMap;
}

- (MXMultilingualObject<NSString *> *)nameMap {
  if (!_nameMap) {
    _nameMap = [[MXMultilingualObject alloc] init];
  }
  return _nameMap;
}

- (MXMultilingualObject<NSString *> *)venueNameMap {
  if (!_venueNameMap) {
    _venueNameMap = [[MXMultilingualObject alloc] init];
  }
  return _venueNameMap;
}

- (MXMultilingualObject<MXMAddress *> *)addressMap {
  if (!_addressMap) {
    _addressMap = [[MXMultilingualObject alloc] init];
  }
  return _addressMap;
}

- (NSString *)type {
  return self.category;
}

- (void)setType:(NSString *)type {
  self.category = type;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMVenue

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"venueId" : @[@"venueId", @"id"],
    @"defaultDisplayedBuildingId" : @[@"defaultDisplayedBuildingId", @"defaultBuilding"],
    @"category" : @[@"category", @"type"],
    @"hasVisualMap" : @[@"hasVisualMap", @"visualMap"],
    @"hasSignalMap" : @[@"hasSignalMap", @"signalMap"],
  };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"buildings" : [MXMBuilding class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  
  NSDictionary *nameDic = DecodeDicFromDic(dic, @"name");
  self.nameMap.Default = DecodeStringFromDic(nameDic, @"default");
  self.nameMap.en = DecodeStringFromDic(nameDic, @"en");
  self.nameMap.zh_Hans = DecodeStringFromDic(nameDic, @"zh-Hans");
  self.nameMap.zh_Hant = DecodeStringFromDic(nameDic, @"zh-Hant");
  self.nameMap.ja = DecodeStringFromDic(nameDic, @"ja");
  self.nameMap.ko = DecodeStringFromDic(nameDic, @"ko");
  
  NSDictionary *addressDic = DecodeDicFromDic(dic, @"address");
  self.addressMap.Default = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"default")];
  self.addressMap.en = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"en")];
  self.addressMap.zh_Hans = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"zh-Hans")];
  self.addressMap.zh_Hant = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"zh-Hant")];
  self.addressMap.ja = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"ja")];
  self.addressMap.ko = [MXMAddress yy_modelWithJSON:DecodeDicFromDic(addressDic, @"ko")];
  
  for (MXMBuilding *building in self.buildings) {
    building.venueId = self.venueId;
    building.category = self.category;
    building.venueNameMap = self.nameMap;
    building.addressMap = self.addressMap;
    building.country = self.country;
    building.region = self.region;
  }
  return YES;
}

- (NSString *)name_default {
  return self.nameMap.Default;
}

- (void)setName_default:(NSString *)name_default {
  self.nameMap.Default = name_default;
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

- (MXMAddress *)address_default {
  return self.addressMap.Default;
}

- (void)setAddress_default:(MXMAddress *)address_default {
  self.addressMap.Default = address_default;
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

- (NSArray<MXMBuilding *> *)buildings {
  if (!_buildings) {
    _buildings = @[];
  }
  return _buildings;
}

- (NSString *)venueId {
  if (!_venueId) {
    _venueId = @"";
  }
  return _venueId;
}

- (NSString *)type {
  return self.category;
}

- (void)setType:(NSString *)type {
  self.category = type;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMPOI

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"poiId" : @[@"poiId", @"id"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  
  NSDictionary *descriptionDic = DecodeDicFromDic(dic, @"description");
  if (descriptionDic) {
    self.descriptionMap.Default = DecodeStringFromDic(descriptionDic, @"default");
    self.descriptionMap.en = DecodeStringFromDic(descriptionDic, @"en");
    self.descriptionMap.zh_Hans = DecodeStringFromDic(descriptionDic, @"zh-Hans");
    self.descriptionMap.zh_Hant = DecodeStringFromDic(descriptionDic, @"zh-Hant");
    self.descriptionMap.ja = DecodeStringFromDic(descriptionDic, @"ja");
    self.descriptionMap.ko = DecodeStringFromDic(descriptionDic, @"ko");
    
    self.introduction = self.descriptionMap.Default;
  } else {
    self.introduction = DecodeStringFromDic(dic, @"description");
  }
  
  NSDictionary *nameDic = DecodeDicFromDic(dic, @"name");
  self.nameMap.Default = DecodeStringFromDic(nameDic, @"default");
  self.nameMap.en = DecodeStringFromDic(nameDic, @"en");
  self.nameMap.zh_Hans = DecodeStringFromDic(nameDic, @"zh-Hans");
  self.nameMap.zh_Hant = DecodeStringFromDic(nameDic, @"zh-Hant");
  self.nameMap.ja = DecodeStringFromDic(nameDic, @"ja");
  self.nameMap.ko = DecodeStringFromDic(nameDic, @"ko");
  
  NSDictionary *accessibilityDetailDic = DecodeDicFromDic(dic, @"accessibilityDetail");
  self.accessibilityDetailMap.Default = DecodeStringFromDic(accessibilityDetailDic, @"default");
  self.accessibilityDetailMap.en = DecodeStringFromDic(accessibilityDetailDic, @"en");
  self.accessibilityDetailMap.zh_Hans = DecodeStringFromDic(accessibilityDetailDic, @"zh-Hans");
  self.accessibilityDetailMap.zh_Hant = DecodeStringFromDic(accessibilityDetailDic, @"zh-Hant");
  self.accessibilityDetailMap.ja = DecodeStringFromDic(accessibilityDetailDic, @"ja");
  self.accessibilityDetailMap.ko = DecodeStringFromDic(accessibilityDetailDic, @"ko");
  
  _floor = [[MXMFloor alloc] init];
  _floor.floorId = DecodeStringFromDic(dic, @"floorId");
  _floor.code = DecodeStringFromDic(dic, @"floor");
  
  NSNumber *result = DecodeNumberFromDic(dic, @"ordinal");
  if (result) {
    MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
    ordinal.level = [result integerValue];
    _floor.ordinal = ordinal;
  }
  
  return YES;
}

- (MXMultilingualObject<NSString *> *)descriptionMap {
  if (!_descriptionMap) {
    _descriptionMap = [[MXMultilingualObject alloc] init];
  }
  return _descriptionMap;
}

- (NSString *)name_default {
  return self.nameMap.Default;
}

- (void)setName_default:(NSString *)name_default {
  self.nameMap.Default = name_default;
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

- (NSString *)poiId {
  if (!_poiId) {
    _poiId = @"";
  }
  return _poiId;
}

- (NSArray<NSString *> *)category {
  if (!_category) {
    _category = @[];
  }
  return _category;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end




//
@implementation MXMInstruction

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"venueId" : @[@"venueId", @"venue_id"],
    @"buildingId" : @[@"buildingId", @"building_id"],
    @"floorId" : @[@"floorId", @"floor_id"],
    @"streetName" : @[@"streetName", @"street_name"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  NSNumber *result = DecodeNumberFromDic(dic, @"ordinal");
  if (result) {
    MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
    ordinal.level = [result integerValue];
    self.ordinal = ordinal;
  }
  return YES;
}

- (NSArray<NSNumber *> *)interval {
  if (!_interval) {
    _interval = @[];
  }
  return _interval;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end

//
@implementation MXMGeometry

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  NSArray *coordinates = DecodeArrayFromDic(dic, @"coordinates");
  NSMutableArray *pointList = [NSMutableArray array];
  for (NSArray *location in coordinates) {
    // [lon,lat,elevation]
    MXMGeoPoint *point;
    if (location.count >= 3) {
      point = [MXMGeoPoint locationWithLatitude:[location[1] doubleValue] longitude:[location[0] doubleValue] elevation:[location[2] doubleValue]];
    } else {
      point = [MXMGeoPoint locationWithLatitude:[location.lastObject doubleValue] longitude:[location.firstObject doubleValue]];
    }
    [pointList addObject:point];
  }
  _coordinates = [pointList copy];
  return YES;
}

- (NSArray<MXMGeoPoint *> *)coordinates {
  if (!_coordinates) {
    _coordinates = @[];
  }
  return _coordinates;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end

//
@implementation MXMPath

+ (NSDictionary *)modelContainerPropertyGenericClass {
  // value should be Class or Class name.
  return @{
    @"instructions" : [MXMInstruction class],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  // minLon, minLat, maxLon, maxLat
  NSArray *coordinates = DecodeArrayFromDic(dic, @"bbox");
  MXMBoundingBox *box;
  if (coordinates.count >= 4) {
    box = [MXMBoundingBox boundingBoxWithMinLatitude:[coordinates[1] doubleValue] minLongitude:[coordinates[0] doubleValue] maxLatitude:[coordinates[3] doubleValue] maxLongitude:[coordinates[2] doubleValue]];
  }
  _bbox = box;
  return YES;
}

- (NSArray<MXMInstruction *> *)instructions {
  if (!_instructions) {
    _instructions = @[];
  }
  return _instructions;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end
