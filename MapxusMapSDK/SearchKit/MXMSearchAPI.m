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

@implementation MXMSearchAPI

// 查找建筑
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v1/buildings"];
    
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




// 查找POI
- (void)MXMPOISearch:(MXMPOISearchRequest *)request
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v1/pois"];
    
    NSMutableDictionary *dic = nil;
    if (request.POIIds.count) {
        NSString *ids = [request.POIIds componentsJoinedByString:@","];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"/%@", ids]];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[request yy_modelToJSONObject]];
        if ([dic objectForKey:@"bbox"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f,%f,%f", request.bbox.min_longitude, request.bbox.min_latitude, request.bbox.max_longitude, request.bbox.max_latitude] forKey:@"bbox"];
        }
        if ([dic objectForKey:@"center"]) {
            [dic setObject:[NSString stringWithFormat:@"%f,%f", request.center.longitude, request.center.latitude] forKey:@"center"];
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
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v1/route"];
    NSDictionary *dic = [request yy_modelToJSONObject];
    
    [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onRouteSearchDone:response:)]) {
            NSArray *routes = DecodeArrayFromDic(content, @"routes");
            NSDictionary *fristRoute = routes.firstObject;
            MXMRouteSearchResponse *response = [MXMRouteSearchResponse yy_modelWithJSON:fristRoute];
            [self.delegate onRouteSearchDone:request response:response];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(MXMSearchRequest:didFailWithError:)]) {
            [self.delegate MXMSearchRequest:request didFailWithError:error];
        }
    }];
}


@end
