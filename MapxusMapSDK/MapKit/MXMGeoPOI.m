//
//  MXMGeoPOI.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoPOI+Private.h"
#import <YYModel/YYModel.h>

@implementation MXMGeoPOI

- (id)copyWithZone:(NSZone *)zone
{
  MXMGeoPOI * copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.identifier = self.identifier;
  copyedModel.buildingId = self.buildingId;
  copyedModel.floor = [self.floor copy];
  copyedModel.coordinate = self.coordinate;
  copyedModel.name = self.name;
  copyedModel.name_en = self.name_en;
  copyedModel.name_cn = self.name_cn;
  copyedModel.name_zh = self.name_zh;
  copyedModel.name_ja = self.name_ja;
  copyedModel.name_ko = self.name_ko;
  copyedModel.accessibilityDetail = self.accessibilityDetail;
  copyedModel.accessibilityDetail_en = self.accessibilityDetail_en;
  copyedModel.accessibilityDetail_cn = self.accessibilityDetail_cn;
  copyedModel.accessibilityDetail_zh = self.accessibilityDetail_zh;
  copyedModel.accessibilityDetail_ja = self.accessibilityDetail_ja;
  copyedModel.accessibilityDetail_ko = self.accessibilityDetail_ko;
  copyedModel.category = self.category;
  copyedModel.overlapFloorIds = self.overlapFloorIds;
  return copyedModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier" : @[@"identifier", @"osm:ref"],
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
  
  if ([dic[@"ref:level"] isKindOfClass:[NSString class]]) {
    _floor = [[MXMFloor alloc] init];
    _floor.floorId = dic[@"ref:level"] ? : @"";
    _floor.code = @"";
  }
  
  if ([dic[@"overlap"] isKindOfClass:[NSString class]]) {
    _overlapFloorIds = [dic[@"overlap"] componentsSeparatedByString:@","];
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
