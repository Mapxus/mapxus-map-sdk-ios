//
//  MXMGeoPOI.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoPOI.h"
#import <YYModel/YYModel.h>

@implementation MXMGeoPOI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.identifier = @"";
        self.category = @[];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"identifier" : @"osm:ref",
             @"buildingId" : @"ref:building",
             @"name_cn" : @"name:zh-Hans",
             @"name_en" : @"name:en",
             @"name_zh" : @"name:zh-Hant"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"place"] isKindOfClass:[NSString class]]) {
        _category = [dic[@"place"] componentsSeparatedByString:@","];
    }
    return YES;
}

- (NSString *)description
{
    return [self yy_modelDescription];
}


@end
