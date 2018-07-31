//
//  MXMSearchObj.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchObj.h"

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"routes" : @"legs"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"routes" : [MXMPath class]};
}

@end
