//
//  MXMGeoVenue.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2022/12/14.
//

#import "MXMGeoVenue.h"
#import <YYModel/YYModel.h>

@implementation MXMGeoVenue

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier": @[@"identifier", @"id"],
    @"venueType": @[@"venueType", @"venue"],
    @"name_cn": @[@"name_cn", @"name:zh-Hans"],
    @"name_en": @[@"name_en", @"name:en"],
    @"name_zh": @[@"name_zh", @"name:zh-Hant"],
    @"name_ja": @[@"name_ja", @"name:ja"],
    @"name_ko": @[@"name_ko", @"name:ko"],
  };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  NSArray *floorCodes = nil;
  if ([dic[@"level_names"] isKindOfClass:[NSString class]]) {
    floorCodes = [dic[@"level_names"] componentsSeparatedByString:@","];
  }

  NSArray *floorOrdinals = nil;
  if ([dic[@"level_ordinals"] isKindOfClass:[NSString class]]) {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSArray *ordStr = [dic[@"level_ordinals"] componentsSeparatedByString:@","];

    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *o in ordStr) {
      NSNumber *result = [formatter numberFromString:o];
      if (result) {
        MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
        ordinal.level = [result integerValue];
        [muArr addObject:ordinal];
        // Find the ground floor
        if (ordinal.level == 0) {
          NSUInteger i = [ordStr indexOfObject:o];
          if (floorCodes.count > i) {
            _groundFloor = floorCodes[i];
          }
        }
      } else {
        [muArr addObject:[NSNull null]];
      }
    }
    floorOrdinals = [muArr copy];
  }

  // 数组合并
  NSMutableArray *all = [[NSMutableArray alloc] init];
  for (int i=0; i<floorCodes.count; i++) {
    MXMFloor *floor = [[MXMFloor alloc] init];
    floor.code = floorCodes[i];
    if (floorOrdinals.count > i && [floorOrdinals[i] isKindOfClass:[MXMOrdinal class]]) {
      floor.ordinal = floorOrdinals[i];
    }
    [all addObject:floor];
  }

  _floors = [all copy];

  if ([dic[@"building_ids"] isKindOfClass:[NSString class]]) {
    _buildingIds = [dic[@"building_ids"] componentsSeparatedByString:@","];
  }

  // address_default
  if (dic[@"addr:street"]) {
    if (self.address_default == nil) {
      self.address_default = [[MXMAddress alloc] init];
    }
    self.address_default.street = [NSString stringWithFormat:@"%@", dic[@"addr:street"]];
  }

  if (dic[@"addr:housenumber"]) {
    if (self.address_default == nil) {
      self.address_default = [[MXMAddress alloc] init];
    }
    self.address_default.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber"]];
  }

  // address_en
  if (dic[@"addr:street:en"]) {
    if (self.address_en == nil) {
      self.address_en = [[MXMAddress alloc] init];
    }
    self.address_en.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:en"]];
  }

  if (dic[@"addr:housenumber:en"]) {
    if (self.address_en == nil) {
      self.address_en = [[MXMAddress alloc] init];
    }
    self.address_en.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:en"]];
  }

  // address_cn
  if (dic[@"addr:street:zh-Hans"]) {
    if (self.address_cn == nil) {
      self.address_cn = [[MXMAddress alloc] init];
    }
    self.address_cn.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:zh-Hans"]];
  }

  if (dic[@"addr:housenumber:zh-Hans"]) {
    if (self.address_cn == nil) {
      self.address_cn = [[MXMAddress alloc] init];
    }
    self.address_cn.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:zh-Hans"]];
  }

  // address_zh
  if (dic[@"addr:street:zh-Hant"]) {
    if (self.address_zh == nil) {
      self.address_zh = [[MXMAddress alloc] init];
    }
    self.address_zh.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:zh-Hant"]];
  }

  if (dic[@"addr:housenumber:zh-Hant"]) {
    if (self.address_zh == nil) {
      self.address_zh = [[MXMAddress alloc] init];
    }
    self.address_zh.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:zh-Hant"]];
  }

  // address_ja
  if (dic[@"addr:street:ja"]) {
    if (self.address_ja == nil) {
      self.address_ja = [[MXMAddress alloc] init];
    }
    self.address_ja.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:ja"]];
  }

  if (dic[@"addr:housenumber:ja"]) {
    if (self.address_ja == nil) {
      self.address_ja = [[MXMAddress alloc] init];
    }
    self.address_ja.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:ja"]];
  }

  // address_ko
  if (dic[@"addr:street:ko"]) {
    if (self.address_ko == nil) {
      self.address_ko = [[MXMAddress alloc] init];
    }
    self.address_ko.street = [NSString stringWithFormat:@"%@", dic[@"addr:street:ko"]];
  }

  if (dic[@"addr:housenumber:ko"]) {
    if (self.address_ko == nil) {
      self.address_ko = [[MXMAddress alloc] init];
    }
    self.address_ko.housenumber = [NSString stringWithFormat:@"%@", dic[@"addr:housenumber:ko"]];
  }

  return YES;
}


- (NSString *)identifier {
  if (!_identifier) {
    _identifier = @"";
  }
  return _identifier;
}

- (NSString *)venueType {
  if (!_venueType) {
    _venueType = @"";
  }
  return _venueType;
}

- (NSArray<NSString *> *)buildingIds {
  if (!_buildingIds) {
    _buildingIds = @[];
  }
  return _buildingIds;
}

- (NSArray<MXMFloor *> *)floors {
  if (!_floors) {
    _floors = @[];
  }
  return _floors;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end
