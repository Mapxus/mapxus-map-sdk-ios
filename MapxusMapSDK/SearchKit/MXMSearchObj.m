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

@end


@implementation MXMPOISearchRequest

@end

@implementation MXMPOISearchResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"pois" : [MXMPOI class]};
}

@end



@implementation MXMRouteSearchRequest


@end


@implementation MXMRouteSearchResponse

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _total = _routes.count;
    return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"routes" : [MXMRoute class],
             @"waypoints" : [MXMWaypoint class]
             };
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
