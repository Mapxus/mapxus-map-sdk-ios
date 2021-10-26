//
//  MXMSearchObj.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchObj.h"
#import <YYModel/YYModel.h>


@implementation MXMBuildingSearchRequest

@end

@implementation MXMBuildingSearchResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"buildings" : [MXMBuilding class]};
}

- (NSArray<MXMBuilding *> *)buildings {
    if (!_buildings) {
        _buildings = @[];
    }
    return _buildings;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end


@implementation MXMPOICategorySearchRequest

@end

@implementation MXMPOICategorySearchResponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"category" : @[@"category", @"result"],
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"category" : [MXMCategory class]};
}

- (NSArray<MXMCategory *> *)category {
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


@implementation MXMPOISearchRequest

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"meterDistance" : @"distance",
             };
}

@end

@implementation MXMPOISearchResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"pois" : [MXMPOI class]};
}

- (NSArray<MXMPOI *> *)pois {
    if (!_pois) {
        _pois = @[];
    }
    return _pois;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end


@implementation MXMOrientationPOISearchRequest
@end

@implementation MXMOrientationPOISearchResponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"pois" : @[@"pois", @"result"],
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"pois" : [MXMPOI class]};
}

- (NSArray<MXMPOI *> *)pois {
    if (!_pois) {
        _pois = @[];
    }
    return _pois;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end


@implementation MXMRouteSearchRequest
@end

@implementation MXMRouteSearchResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             @"paths" : [MXMPath class],
            };
}

- (NSArray<MXMIndoorPoint *> *)wayPointList {
    if (!_wayPointList) {
        _wayPointList = @[];
    }
    return _wayPointList;
}

- (NSArray<MXMPath *> *)paths {
    if (!_paths) {
        _paths = @[];
    }
    return _paths;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
