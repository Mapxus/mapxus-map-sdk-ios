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

@implementation MXMSearchAPI

// 查找建筑
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v2/buildings"];
    
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
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v2/pois/category"];
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
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v2/pois"];
    
    NSMutableDictionary *dic = nil;
    if (request.POIIds.count) {
        NSString *ids = [request.POIIds componentsJoinedByString:@","];
        url = [NSString stringWithFormat:@"%@%@%@", MXMHOSTURL, @"/api/v1/pois/", ids];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
        if ([dic objectForKey:@"bbox"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", request.bbox.min_longitude, request.bbox.min_latitude, request.bbox.max_longitude, request.bbox.max_latitude] forKey:@"bbox"];
            [dic removeObjectForKey:@"distance"];
        }
        if ([dic objectForKey:@"center"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
        }
        if ([dic objectForKey:@"buildingId"]) {
            [dic removeObjectForKey:@"distance"];
        }
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




// 查找路径
- (void)MXMRouteSearch:(MXMRouteSearchRequest *)request
{
    // 起始点
    NSMutableArray *fristP = [NSMutableArray array];
    [fristP addObject:@(request.fromLat)];
    [fristP addObject:@(request.fromLon)];
    if (request.fromBuilding) [fristP addObject:request.fromBuilding];
    if (request.fromFloor) [fristP addObject:request.fromFloor];
    // 终点
    NSMutableArray *secondP = [NSMutableArray array];
    [secondP addObject:@(request.toLat)];
    [secondP addObject:@(request.toLon)];
    if (request.toBuilding) [secondP addObject:request.toBuilding];
    if (request.toFloor) [secondP addObject:request.toFloor];
    
    NSString *points = [NSString stringWithFormat:@"?point=%@&point=%@", [fristP componentsJoinedByString:@","], [secondP componentsJoinedByString:@","]];
    NSString *parameters = [NSString stringWithFormat:@"&type=%@&locale=%@&vehicle=%@&elevation=%@&weighting=fastest&points_encoded=false", @"json", request.locale?:@"", @"foot", @"false"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@", MXMHOSTURL, @"/api/v4/route", points, parameters];
    
    [MXMHttpManager MXMGET:url parameters:nil success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onRouteSearchDone:response:)]) {
            MXMRouteSearchResponse *response = [MXMRouteSearchResponse yy_modelWithJSON:content];
            [self.delegate onRouteSearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}


@end
