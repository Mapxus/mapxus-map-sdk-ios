//
//  MXMLevelModel.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/7/10.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMLevelModel.h"
#import <YYModel/YYModel.h>

@implementation MXMLevelModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.levelId && self.refBuildingId) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"levelId": @[@"levelId", @"id"],
             @"refBuildingId": @[@"refBuildingId", @"ref:building"],
             @"name": @"name",
             @"ordinal": @"ordinal"};
}

@end
