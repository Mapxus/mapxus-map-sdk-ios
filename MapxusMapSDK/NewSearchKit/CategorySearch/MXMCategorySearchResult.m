//
//  MXMCategorySearchResult.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCategorySearchResult.h"
#import <YYModel/YYModel.h>
#import "JXJsonFunctionDefine.h"

@implementation MXMPoiCategorySearchResult

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"categoryResults" : @[@"categoryResults", @"result"],
  };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"categoryResults" : [MXMCategory class]};
}

- (NSArray<MXMCategory *> *)categoryResults {
  if (!_categoryResults) {
    _categoryResults = @[];
  }
  return _categoryResults;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMPoiCategoryVenueInfoEx

- (MXMCategory *)category {
  if (!_category) {
    _category = [[MXMCategory alloc] init];
  }
  return _category;
}

- (NSString *)venueId {
  if (!_venueId) {
    _venueId = @"";
  }
  return _venueId;
}

- (MXMultilingualObjectString *)venueNameMap {
  if (!_venueNameMap) {
    _venueNameMap = [[MXMultilingualObject alloc] init];
  }
  return _venueNameMap;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end



@implementation MXMPoiCategoryBboxSearchResult

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
  
  NSMutableArray *list = [NSMutableArray array];
  NSMutableDictionary *venueDic = [NSMutableDictionary dictionary];
  
  NSArray *categoryList = DecodeArrayFromDic(dic, @"categoryGroups");
  for (NSDictionary *pDic in categoryList) {
    
    MXMPoiCategoryVenueInfoEx *categoryEx = [[MXMPoiCategoryVenueInfoEx alloc] init];
    
    NSDictionary *titleDic = DecodeDicFromDic(pDic, @"title");
    categoryEx.category.titleMap.Default = DecodeStringFromDic(titleDic, @"default");
    categoryEx.category.titleMap.en = DecodeStringFromDic(titleDic, @"en");
    categoryEx.category.titleMap.zh_Hans = DecodeStringFromDic(titleDic, @"zh-Hans");
    categoryEx.category.titleMap.zh_Hant = DecodeStringFromDic(titleDic, @"zh-Hant");
    categoryEx.category.titleMap.ja = DecodeStringFromDic(titleDic, @"ja");
    categoryEx.category.titleMap.ko = DecodeStringFromDic(titleDic, @"ko");
    categoryEx.category.titleMap.fil = DecodeStringFromDic(titleDic, @"fil");
    categoryEx.category.titleMap._id = DecodeStringFromDic(titleDic, @"id");
    categoryEx.category.titleMap.pt = DecodeStringFromDic(titleDic, @"pt");
    categoryEx.category.titleMap.th = DecodeStringFromDic(titleDic, @"th");
    categoryEx.category.titleMap.vi = DecodeStringFromDic(titleDic, @"vi");
    categoryEx.category.titleMap.ar = DecodeStringFromDic(titleDic, @"ar");
    
    categoryEx.category.categoryId = DecodeStringFromDic(pDic, @"id");
    categoryEx.category.category = DecodeStringFromDic(pDic, @"category");
    categoryEx.category.categoryDescription = DecodeStringFromDic(pDic, @"description");
    
    categoryEx.venueId = DecodeStringFromDic(pDic, @"venueId");
    
    MXMultilingualObjectString *venueName = venueDic[categoryEx.venueId];
    
    if (venueName) {
      categoryEx.venueNameMap = venueName;
    } else {
      NSDictionary *venueNameDic = DecodeDicFromDic(pDic, @"venueNames");
      categoryEx.venueNameMap.Default = DecodeStringFromDic(venueNameDic, @"default");
      categoryEx.venueNameMap.en = DecodeStringFromDic(venueNameDic, @"en");
      categoryEx.venueNameMap.zh_Hans = DecodeStringFromDic(venueNameDic, @"zh-Hans");
      categoryEx.venueNameMap.zh_Hant = DecodeStringFromDic(venueNameDic, @"zh-Hant");
      categoryEx.venueNameMap.ja = DecodeStringFromDic(venueNameDic, @"ja");
      categoryEx.venueNameMap.ko = DecodeStringFromDic(venueNameDic, @"ko");
      categoryEx.venueNameMap.fil = DecodeStringFromDic(venueNameDic, @"fil");
      categoryEx.venueNameMap._id = DecodeStringFromDic(venueNameDic, @"id");
      categoryEx.venueNameMap.pt = DecodeStringFromDic(venueNameDic, @"pt");
      categoryEx.venueNameMap.th = DecodeStringFromDic(venueNameDic, @"th");
      categoryEx.venueNameMap.vi = DecodeStringFromDic(venueNameDic, @"vi");
      categoryEx.venueNameMap.ar = DecodeStringFromDic(venueNameDic, @"ar");
      
      venueDic[categoryEx.venueId] = categoryEx.venueNameMap;
    }
    
    [list addObject:categoryEx];
  }
  
  self.categoryVenueInfoExResults = [list copy];
  
  return YES;
}

- (NSArray<MXMPoiCategoryVenueInfoEx *> *)categoryVenueInfoExResults {
  if (!_categoryVenueInfoExResults) {
    _categoryVenueInfoExResults = @[];
  }
  return _categoryVenueInfoExResults;
}

- (NSString *)description
{
  return [self yy_modelDescription];
}

@end
