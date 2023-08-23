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
    return @{@"categoryId" : @[@"categoryId", @"id"],
             @"title_en" : @[@"title_en", @"title.en"],
             @"title_cn" : @[@"title_cn", @"title.zh-Hans"],
             @"title_zh" : @[@"title_zh", @"title.zh-Hant"],
             @"categoryDescription" : @[@"categoryDescription", @"description"],
    };
}

- (NSString *)description
{
    return [self yy_modelDescription];
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


//
@implementation MXMBuilding

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @[@"name_default", @"name.default"],
             @"name_en" : @[@"name_en", @"name.en"],
             @"name_cn" : @[@"name_cn", @"name.zh-Hans"],
             @"name_zh" : @[@"name_zh", @"name.zh-Hant"],
             @"name_ja" : @[@"name_ja", @"name.ja"],
             @"name_ko" : @[@"name_ko", @"name.ko"],
             @"venueName_default" : @[@"venueName_default", @"venueName.default"],
             @"venueName_en" : @[@"venueName_en", @"venueName.en"],
             @"venueName_cn" : @[@"venueName_cn", @"venueName.zh-Hans"],
             @"venueName_zh" : @[@"venueName_zh", @"venueName.zh-Hant"],
             @"venueName_ja" : @[@"venueName_ja", @"venueName.ja"],
             @"venueName_ko" : @[@"venueName_ko", @"venueName.ko"],
             @"address_default" : @[@"address_default", @"address.default"],
             @"address_en" : @[@"address_en", @"address.en"],
             @"address_cn" : @[@"address_cn", @"address.zh-Hans"],
             @"address_zh" : @[@"address_zh", @"address.zh-Hant"],
             @"address_ja" : @[@"address_ja", @"address.ja"],
             @"address_ko" : @[@"address_ko", @"address.ko"],
             @"buildingId" : @[@"buildingId", @"id"],
             @"defaultDisplayedFloorId" : @[@"defaultDisplayedFloorId", @"defaultFloor"],
             @"hasVisualMap" : @[@"hasVisualMap", @"visualMap"],
             @"hasSignalMap" : @[@"hasSignalMap", @"signalMap"],
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"floors" : [MXMFloorInfo class]};
}

- (NSString *)description
{
    return [self yy_modelDescription];
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

@end



@implementation MXMVenue

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
      @"venueId" : @[@"venueId", @"id"],
      @"name_default" : @[@"name_default", @"name.default"],
      @"name_en" : @[@"name_en", @"name.en"],
      @"name_cn" : @[@"name_cn", @"name.zh-Hans"],
      @"name_zh" : @[@"name_zh", @"name.zh-Hant"],
      @"name_ja" : @[@"name_ja", @"name.ja"],
      @"name_ko" : @[@"name_ko", @"name.ko"],
      @"address_default" : @[@"address_default", @"address.default"],
      @"address_en" : @[@"address_en", @"address.en"],
      @"address_cn" : @[@"address_cn", @"address.zh-Hans"],
      @"address_zh" : @[@"address_zh", @"address.zh-Hant"],
      @"address_ja" : @[@"address_ja", @"address.ja"],
      @"address_ko" : @[@"address_ko", @"address.ko"],
      @"defaultDisplayedBuildingId" : @[@"defaultDisplayedBuildingId", @"defaultBuilding"],
      @"hasVisualMap" : @[@"hasVisualMap", @"visualMap"],
      @"hasSignalMap" : @[@"hasSignalMap", @"signalMap"],
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buildings" : [MXMBuilding class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  for (MXMBuilding *building in self.buildings) {
    building.venueId = self.venueId;
    building.type = self.type;
    building.venueName_default = self.name_default;
    building.venueName_cn = self.name_cn;
    building.venueName_zh = self.name_zh;
    building.venueName_en = self.name_en;
    building.venueName_ja = self.name_ja;
    building.venueName_ko = self.name_ko;
    building.address_default = self.address_default;
    building.address_cn = self.address_cn;
    building.address_zh = self.address_zh;
    building.address_en = self.address_en;
    building.address_ja = self.address_ja;
    building.address_ko = self.address_ko;
    building.country = self.country;
    building.region = self.region;
  }
  return YES;
}

- (NSString *)description
{
    return [self yy_modelDescription];
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

@end



@implementation MXMPOI

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @[@"name_default", @"name.default"],
             @"name_en" : @[@"name_en", @"name.en"],
             @"name_cn" : @[@"name_cn", @"name.zh-Hans"],
             @"name_zh" : @[@"name_zh", @"name.zh-Hant"],
             @"name_ja" : @[@"name_ja", @"name.ja"],
             @"name_ko" : @[@"name_ko", @"name.ko"],
             @"accessibilityDetail" : @[@"accessibilityDetail", @"accessibilityDetail.default"],
             @"accessibilityDetail_en" : @[@"accessibilityDetail_en", @"accessibilityDetail.en"],
             @"accessibilityDetail_cn" : @[@"accessibilityDetail_cn", @"accessibilityDetail.zh-Hans"],
             @"accessibilityDetail_zh" : @[@"accessibilityDetail_zh", @"accessibilityDetail.zh-Hant"],
             @"accessibilityDetail_ja" : @[@"accessibilityDetail_ja", @"accessibilityDetail.ja"],
             @"accessibilityDetail_ko" : @[@"accessibilityDetail_ko", @"accessibilityDetail.ko"],
             @"introduction" : @[@"introduction", @"description"],
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _poiId = DecodeStringFromDic(dic, @"id");
    
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

- (NSString *)description
{
    return [self yy_modelDescription];
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
