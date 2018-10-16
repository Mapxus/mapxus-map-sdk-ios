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

@implementation MXMBoundingBox

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

@implementation MXMAddress

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMFloor

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"floorId" : @"id",
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMBuilding

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @"name.default",
             @"name_en" : @"name.en",
             @"name_cn" : @"name.cn",
             @"name_zh" : @"name.zh",
             @"address_default" : @"address.default",
             @"address_en" : @"address.en",
             @"address_cn" : @"address.cn",
             @"address_zh" : @"address.zh",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"floors" : [MXMFloor class]};
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSLog(@"%@", dic);
//    NSArray *keys = [dic allKeys];
//    for (NSString *key in keys) {
//        if ([key isEqualToString:@"floors"] && [dic[key] isKindOfClass:[NSString class]]) {
//            //            if (_underground) {
//            //                _floors = [dic[key] componentsSeparatedByString:@","];
//            //            } else {
////            _floors = [[[dic[key] componentsSeparatedByString:@","] reverseObjectEnumerator] allObjects];
//            //            }
//        }
//    }
//
//    return YES;
//}

@end

@implementation MXMPOI

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name_default" : @"name.default",
             @"name_en" : @"name.en",
             @"name_cn" : @"name.cn",
             @"name_zh" : @"name.zh",
             @"introduction" : @"description",
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMManeuver

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *location = DecodeArrayFromDic(dic, @"location");
    if (location) {
        _location = [[MXMGeoPoint alloc] init];
        _location.longitude = [location.firstObject doubleValue];
        _location.latitude = [location.lastObject doubleValue];
    }
    return YES;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMCoordinate

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *lon = DecodeNumberFromDic(dic, @"lon");
    NSNumber *lat = DecodeNumberFromDic(dic, @"lat");
    _location = [[MXMGeoPoint alloc] init];
    _location.longitude = [lon doubleValue];
    _location.latitude = [lat doubleValue];
    return YES;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMStep

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"maneuver" : [MXMManeuver class],
             @"coordinates" : [MXMCoordinate class]
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMLeg

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"steps" : [MXMStep class]};
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMRoute

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"legs" : [MXMLeg class]};
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end

@implementation MXMWaypoint

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *location = DecodeArrayFromDic(dic, @"location");
    if (location) {
        _location = [[MXMGeoPoint alloc] init];
        _location.longitude = [location.firstObject doubleValue];
        _location.latitude = [location.lastObject doubleValue];
    }
    return YES;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end







