//
//  MXMCommonObj.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCommonObj.h"
#import <YYModel/YYModel.h>

@implementation MXMGeoPoint

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"latitude" : @"lat",
             @"longitude" : @"lon",
             };
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

@end



@implementation MXMAddress

@end


@implementation MXMFloor

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"floorId" : @"id",
             };
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

@end



@implementation MXMStep


@end



@implementation MXMPath

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coordinates" : [MXMStep class]};
}

@end
