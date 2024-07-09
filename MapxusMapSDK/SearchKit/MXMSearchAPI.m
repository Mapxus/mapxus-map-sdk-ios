//
//  MXMSearchAPI.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchAPI.h"
#import "MXMHttpManager.h"
#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "JXJsonFunctionDefine.h"
#import "NSString+MXMUtils.h"
#import <MapxusBaseSDK/MXMErrorDefined.h>


@implementation MXMSearchAPI

- (void)MXMVenueSearch:(MXMVenueSearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v4/venues"];

    NSMutableDictionary *dic = nil;
    if (request.venueIds.count) {
        // 过滤掉空字符串
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self != ''"];
        NSArray<NSString *> *filteredArray = [request.venueIds filteredArrayUsingPredicate:predicate];
      
        // 过滤后如果没有id,立刻返回
        if (!filteredArray.count && self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
          NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                               code:kParameterEinval
                                           userInfo:@{NSLocalizedDescriptionKey: @"The `venueIds` array must contain at least one id that is not null."}];
          [self.delegate MXMSearchRequest:request didFailWithError:error];
          return;
        }

        NSString *ids = [filteredArray componentsJoinedByString:@","];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"/%@", ids]];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
        if ([dic objectForKey:@"bbox"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", request.bbox.min_longitude, request.bbox.min_latitude, request.bbox.max_longitude, request.bbox.max_latitude] forKey:@"bbox"];
        }
        if ([dic objectForKey:@"center"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
        }
        // keywords为空时，不传该参数，返回所有结果
        if (![NSString mxmIsValid:[dic objectForKey:@"keywords"]]) {
            [dic removeObjectForKey:@"keywords"];
        }
    }

    if (dic && request.offset == 0) {
      [dic setObject:@(10) forKey:@"offset"];
    }
    
    [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onVenueSearchDone:response:)]) {
            MXMVenueSearchResponse *response = [MXMVenueSearchResponse yy_modelWithJSON:content];
            [self.delegate onVenueSearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}


// 查找建筑
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v4/buildings"];

    NSMutableDictionary *dic = nil;
    if (request.buildingIds.count) {
        // 过滤掉空字符串
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self != ''"];
        NSArray<NSString *> *filteredArray = [request.buildingIds filteredArrayUsingPredicate:predicate];
      
        // 过滤后如果没有id,立刻返回
        if (!filteredArray.count && self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
          NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                               code:kParameterEinval
                                           userInfo:@{NSLocalizedDescriptionKey: @"The `buildingIds` array must contain at least one id that is not null."}];
          [self.delegate MXMSearchRequest:request didFailWithError:error];
          return;
        }
        
        NSString *ids = [filteredArray componentsJoinedByString:@","];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"/%@", ids]];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
        if ([dic objectForKey:@"bbox"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", request.bbox.min_longitude, request.bbox.min_latitude, request.bbox.max_longitude, request.bbox.max_latitude] forKey:@"bbox"];
        }
        if ([dic objectForKey:@"center"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
        }
        // keywords为空时，不传该参数，返回所有结果
        if (![NSString mxmIsValid:[dic objectForKey:@"keywords"]]) {
            [dic removeObjectForKey:@"keywords"];
        }
        dic[@"region"] = @(0);
    }

  if (dic && request.offset == 0) {
    [dic setObject:@(10) forKey:@"offset"];
  }
    
    [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBuildingSearchDone:response:)]) {
            MXMBuildingSearchResponse *response = [MXMBuildingSearchResponse yy_modelWithJSON:content];
            [self.delegate onBuildingSearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}


- (void)MXMPOICategorySearch:(MXMPOICategorySearchRequest *)request
{
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/categories/pois"];
  if (!request.floorId && request.floor) {
    url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v1/categories/pois"];
  }
  NSDictionary *dic = [request yy_modelToJSONObject];
  
  [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPOICategorySearchDone:response:)]) {
      MXMPOICategorySearchResponse *response = [MXMPOICategorySearchResponse yy_modelWithJSON:content];
      [self.delegate onPOICategorySearchDone:request response:response];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
      [self.delegate MXMSearchRequest:request didFailWithError:error];
    }
  }];
}


// 查找POI
- (void)MXMPOISearch:(MXMPOISearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v3/pois"];

    NSMutableDictionary *dic = nil;
    if (request.POIIds.count) {
        // 过滤掉空字符串
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self != ''"];
        NSArray<NSString *> *filteredArray = [request.POIIds filteredArrayUsingPredicate:predicate];
      
        // 过滤后如果没有id,立刻返回
        if (!filteredArray.count && self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
          NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                               code:kParameterEinval
                                           userInfo:@{NSLocalizedDescriptionKey: @"The `POIIds` array must contain at least one id that is not null."}];
          [self.delegate MXMSearchRequest:request didFailWithError:error];
          return;
        }
        
        NSString *ids = [filteredArray componentsJoinedByString:@","];
        url = [NSString stringWithFormat:@"%@%@%@", MXMAPIHOSTURL, @"/bms/api/v4/pois/", ids];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
        if ([dic objectForKey:@"bbox"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", request.bbox.min_longitude, request.bbox.min_latitude, request.bbox.max_longitude, request.bbox.max_latitude] forKey:@"bbox"];
            [dic removeObjectForKey:@"distance"];
        }
        if ([dic objectForKey:@"center"]) {
            if ([[dic objectForKey:@"sort"] isEqualToString:@"ActualDistance"]) {
                [dic setObject:[NSString stringWithFormat:@"%f,%f,%ld", request.center.longitude, request.center.latitude, (long)request.ordinal] forKey:@"center"];
            } else {
                [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
            }
        } else {
          [dic removeObjectForKey:@"distance"];
        }
        [dic removeObjectForKey:@"ordinal"];
        // keywords为空时，不传该参数，返回所有结果
        if (![NSString mxmIsValid:[dic objectForKey:@"keywords"]]) {
            [dic removeObjectForKey:@"keywords"];
        }
    }
    
    [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPOISearchDone:response:)]) {
            MXMPOISearchResponse *response = [MXMPOISearchResponse yy_modelWithJSON:content];
            [self.delegate onPOISearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}



- (void)MXMOrientationPOISearch:(MXMOrientationPOISearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v3/pois/orientation"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
    if ([dic objectForKey:@"center"]) {
        [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
    }
    
    [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onOrientationPOISearchDone:response:)]) {
            MXMOrientationPOISearchResponse *response = [MXMOrientationPOISearchResponse yy_modelWithJSON:content];
            [self.delegate onOrientationPOISearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}



// 查找路径
- (void)MXMRouteSearch:(MXMRouteSearchRequest *)request
{
  int version = 1;
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  NSArray *list = request.points;
  
  if (list) { // 有传入points，直接使用新接口
    version = 2;
  } else {
    
    BOOL notInPairs1 = request.fromFloorId && request.toFloor && !request.fromFloor && !request.toFloorId;
    BOOL notInPairs2 = request.fromFloor && request.toFloorId && !request.fromFloorId && !request.toFloor;
    BOOL notInPairs = notInPairs1 || notInPairs2;
    
    if (notInPairs) {
      // floor 和 floorId 一样用了一个，报错
      if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
        NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                             code:-1601
                                         userInfo:@{NSLocalizedDescriptionKey: @"Please use either floor or floorId in pairs."}];
        [self.delegate MXMSearchRequest:request didFailWithError:error];
      }
      return;
    } else if ((request.fromFloorId || request.toFloorId) || (!request.fromFloor && !request.toFloor)) {
      version = 2;
      MXMIndoorPoint *startP = [MXMIndoorPoint locationWithLatitude:request.fromLat longitude:request.fromLon buildingId:request.fromBuildingId floorId:request.fromFloorId];
      MXMIndoorPoint *endP = [MXMIndoorPoint locationWithLatitude:request.toLat longitude:request.toLon buildingId:request.toBuildingId floorId:request.toFloorId];
      list = @[startP, endP];
    }
  }
  
  
  if (version == 2) {
    // 点数量限制
    if (list.count < 2) { // 当points有值且点数小于2时，报错
      if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
        NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                             code:-1601
                                         userInfo:@{NSLocalizedDescriptionKey: @"Minimum of 2 incoming points."}];
        [self.delegate MXMSearchRequest:request didFailWithError:error];
      }
      return;
    } else if (list.count > 5) { // 当points数量大于5时，报错
      if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
        NSError *error = [NSError errorWithDomain:MXMParamErrorDomain
                                             code:-1601
                                         userInfo:@{NSLocalizedDescriptionKey: @"Maximum of 5 incoming points."}];
        [self.delegate MXMSearchRequest:request didFailWithError:error];
      }
      return;
    }
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:list.count];
    for (MXMIndoorPoint *p in list) {
      NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
      muDic[@"buildingId"] = p.buildingId;
      muDic[@"floorId"] = p.floorId;
      muDic[@"lat"] = @(p.latitude);
      muDic[@"lon"] = @(p.longitude);
      [muArr addObject:muDic];
    }
    dic[@"vehicle"] = request.vehicle;
    dic[@"locale"] = request.locale;
    dic[@"points"] = muArr;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/route/query"];
    [MXMHttpManager MXMPOST:url parameters:dic success:^(NSDictionary *content) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(onRouteSearchDone:response:)]) {
        MXMRouteSearchResponse *response = [MXMRouteSearchResponse yy_modelWithJSON:content];
        response.wayPointList = list;
        [self.delegate onRouteSearchDone:request response:response];
      }
    } failure:^(NSError *error) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
        [self.delegate MXMSearchRequest:request didFailWithError:error];
      }
    }];
    
    return;
  }
  
  dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
  [dic removeObjectsForKeys:@[@"fromBuildingId", @"fromFloorId", @"toBuildingId", @"toFloorId", @"points"]];
  // v1接口
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v1/route"];
  [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRouteSearchDone:response:)]) {
      // 途经点赋值
      MXMIndoorPoint *startP = [MXMIndoorPoint locationWithLatitude:request.fromLat longitude:request.fromLon building:request.fromBuilding floor:request.fromFloor];
      MXMIndoorPoint *endP = [MXMIndoorPoint locationWithLatitude:request.toLat longitude:request.toLon building:request.toBuilding floor:request.toFloor];
      MXMRouteSearchResponse *response = [MXMRouteSearchResponse yy_modelWithJSON:content];
      response.wayPointList = @[startP, endP];
      [self.delegate onRouteSearchDone:request response:response];
    }
  } failure:^(NSError *error) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
      [self.delegate MXMSearchRequest:request didFailWithError:error];
    }
  }];
}


@end
