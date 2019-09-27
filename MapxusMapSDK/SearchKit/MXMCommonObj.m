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
    return @{@"latitude" : @"lat",
             @"longitude" : @"lon",
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end



@implementation MXMIndoorPoint

+ (MXMIndoorPoint *)locationWithLatitude:(double)lat longitude:(double)lng building:(NSString *)buildingId floor:(NSString *)floor
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
    return @{@"min_latitude" : @"minLat",
             @"min_longitude" : @"minLon",
             @"max_latitude" : @"maxLat",
             @"max_longitude" : @"maxLon",
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

//
@implementation MXMAddress

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

//
@implementation MXMFloor

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"floorId" : @"id",
             @"hasVisualMap" : @"visualMap"
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

//
@implementation MXMBuilding

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @"name.default",
             @"name_en" : @"name.en",
             @"name_cn" : @"name.zh-Hans",
             @"name_zh" : @"name.zh-Hant",
             @"address_default" : @"address.default",
             @"address_en" : @"address.en",
             @"address_cn" : @"address.zh-Hans",
             @"address_zh" : @"address.zh-Hant",
             @"buildingId" : @[@"buildingId", @"id"],
             @"hasVisualMap" : @"visualMap"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"floors" : [MXMFloor class]};
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

//
@implementation MXMPOI

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @"name.default",
             @"name_en" : @"name.en",
             @"name_cn" : @"name.zh-Hans",
             @"name_zh" : @"name.zh-Hant",
             @"introduction" : @"description",
             };
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
             @"buildingId" : @"building_id",
             @"streetName" : @"street_name",
             };
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

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
