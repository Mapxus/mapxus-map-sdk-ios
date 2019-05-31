//
//  MXMIndoorMapInfo.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/5/31.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMIndoorMapInfo.h"
#import <YYModel/YYModel.h>

@implementation MXMIndoorMapInfo

- (instancetype)initWithBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor
{
    self = [super init];
    if (self) {
        _building = building;
        _floor = floor;
    }
    return self;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
