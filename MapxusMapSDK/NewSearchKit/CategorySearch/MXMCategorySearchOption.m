//
//  MXMCategorySearchOption.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCategorySearchOption.h"
#import <YYModel/YYModel.h>

@implementation MXMPoiCategoryFloorSearchOption

@end



@implementation MXMPoiCategoryBuildingSearchOption

@end



@implementation MXMPoiCategoryVenueSearchOption

@end



@implementation MXMPoiCategoryBboxSearchOption

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"keyword" : @[@"keywords"],
  };
}

@end
