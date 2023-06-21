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
#import "NSString+Compare.h"

NSString * const MXMParamErrorDomain = @"com.mapxus.param.error";

@implementation MXMSearchAPI

// 查找建筑
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v3/buildings"];

    NSMutableDictionary *dic = nil;
    if (request.buildingIds.count) {
        NSString *ids = [request.buildingIds componentsJoinedByString:@","];
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
        if ([NSString isEmpty:[dic objectForKey:@"keywords"]]) {
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
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v1/categories/pois"];
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
        NSString *ids = [request.POIIds componentsJoinedByString:@","];
        url = [NSString stringWithFormat:@"%@%@%@", MXMAPIHOSTURL, @"/bms/api/v3/pois/", ids];
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
        }
        [dic removeObjectForKey:@"ordinal"];
        // keywords为空时，不传该参数，返回所有结果
        if ([NSString isEmpty:[dic objectForKey:@"keywords"]]) {
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
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v1/pois/orientation"];
    
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
  // 更新属性名
  if (!request.fromBuildingId) {
    request.fromBuildingId = request.fromBuilding;
  }
  if (!request.toBuildingId) {
    request.toBuildingId = request.toBuilding;
  }

  int version = 1;
  NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v1/route"];
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];

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
    // 除了上面的情况，只要其中一个不为空，就用v3
    version = 2;
    url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL, @"/bms/api/v2/route"];
    dic[@"fromFloor"] = request.fromFloorId;
    dic[@"toFloor"] = request.toFloorId;
    [dic removeObjectForKey:@"fromFloorId"];
    [dic removeObjectForKey:@"toFloorId"];
  } else {
    [dic removeObjectForKey:@"fromFloorId"];
    [dic removeObjectForKey:@"toFloorId"];
  }
  // 过渡版本删除，最终版本使用YYModel转换
  [dic removeObjectForKey:@"fromBuildingId"];
  [dic removeObjectForKey:@"toBuildingId"];
  dic[@"fromBuilding"] = request.fromBuildingId;
  dic[@"toBuilding"] = request.toBuildingId;
      
  [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRouteSearchDone:response:)]) {
      // 途经点赋值
      MXMIndoorPoint *startP = [MXMIndoorPoint locationWithLatitude:request.fromLat longitude:request.fromLon building:request.fromBuilding floor:request.fromFloor];
      MXMIndoorPoint *endP = [MXMIndoorPoint locationWithLatitude:request.toLat longitude:request.toLon building:request.toBuilding floor:request.toFloor];
      if (version == 2) {
        startP = [MXMIndoorPoint locationWithLatitude:request.fromLat longitude:request.fromLon buildingId:request.fromBuildingId floorId:request.fromFloorId];
        endP = [MXMIndoorPoint locationWithLatitude:request.toLat longitude:request.toLon buildingId:request.toBuildingId floorId:request.toFloorId];
      }
      
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
