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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"identifier" : @[@"identifier", @"osm:ref"],
             @"buildingId" : @[@"buildingId", @"ref:building"],
             @"name_ja" : @[@"name_ja", @"name:ja"],
             @"name_ko" : @[@"name_ko", @"name:ko"],
             @"name_cn" : @[@"name_cn", @"name:zh-Hans"],
             @"name_en" : @[@"name_en", @"name:en"],
             @"name_zh" : @[@"name_zh", @"name:zh-Hant"],
             @"accessibilityDetail" : @[@"accessibilityDetail", @"accessibility_detail"],
             @"accessibilityDetail_en" : @[@"accessibilityDetail_en", @"accessibility_detail:en"],
             @"accessibilityDetail_cn" : @[@"accessibilityDetail_cn", @"accessibility_detail:zh-Hans"],
             @"accessibilityDetail_zh" : @[@"accessibilityDetail_zh", @"accessibility_detail:zh-Hant"],
             @"accessibilityDetail_ja" : @[@"accessibilityDetail_ja", @"accessibility_detail:ja"],
             @"accessibilityDetail_ko" : @[@"accessibilityDetail_ko", @"accessibility_detail:ko"],
    };
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

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}

- (NSArray<NSString *> *)category {
    if (!_category) {
        _category = @[];
    }
    return _category;
}


@end
