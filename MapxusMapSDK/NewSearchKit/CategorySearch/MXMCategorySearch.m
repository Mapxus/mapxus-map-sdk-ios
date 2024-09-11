//
//  MXMCategorySearch.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCategorySearch.h"
#import "MXMHttpManager.h"
#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "JXJsonFunctionDefine.h"

@implementation MXMCategorySearch


- (NSInteger)searchPoiCategoriesByFloor:(MXMPoiCategoryFloorSearchOption *)floorOption {
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/categories/pois"];
  NSDictionary *dic = [floorOption yy_modelToJSONObject];
  
  NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      MXMPoiCategorySearchResult *response = [MXMPoiCategorySearchResult yy_modelWithJSON:content];
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:response error:nil];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:nil error:error];
    }
  }];
  
  return task.taskIdentifier;
}


- (NSInteger)searchPoiCategoriesByBuilding:(MXMPoiCategoryBuildingSearchOption *)buildingOption {
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/categories/pois"];
  NSDictionary *dic = [buildingOption yy_modelToJSONObject];
  
  NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      MXMPoiCategorySearchResult *response = [MXMPoiCategorySearchResult yy_modelWithJSON:content];
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:response error:nil];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:nil error:error];
    }
  }];
  
  return task.taskIdentifier;
}


- (NSInteger)searchPoiCategoriesByVenue:(MXMPoiCategoryVenueSearchOption *)venueOption {
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/categories/pois"];
  NSDictionary *dic = [venueOption yy_modelToJSONObject];
  
  NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      MXMPoiCategorySearchResult *response = [MXMPoiCategorySearchResult yy_modelWithJSON:content];
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:response error:nil];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryWithResult:error:)]) {
      [self.delegate categorySearcher:self didReceivePoiCategoryWithResult:nil error:error];
    }
  }];
  
  return task.taskIdentifier;
}


- (NSInteger)searchPoiCategoriesInBoundingBox:(MXMPoiCategoryBboxSearchOption *)bboxOption {
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v5/categories/group"];
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[bboxOption yy_modelToJSONObject]];
  if ([dic objectForKey:@"bbox"]) {
    [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", bboxOption.bbox.min_longitude, bboxOption.bbox.min_latitude, bboxOption.bbox.max_longitude, bboxOption.bbox.max_latitude] forKey:@"bbox"];
  }
  
  NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryInBoundingBoxWithResult:error:)]) {
      MXMPoiCategoryBboxSearchResult *response = [MXMPoiCategoryBboxSearchResult yy_modelWithJSON:content];
      [self.delegate categorySearcher:self didReceivePoiCategoryInBoundingBoxWithResult:response error:nil];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categorySearcher:didReceivePoiCategoryInBoundingBoxWithResult:error:)]) {
      [self.delegate categorySearcher:self didReceivePoiCategoryInBoundingBoxWithResult:nil error:error];
    }
  }];
  
  return task.taskIdentifier;
}

@end
