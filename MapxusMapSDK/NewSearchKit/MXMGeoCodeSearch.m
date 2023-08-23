//
//  MXMGeoCodeSearch.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoCodeSearch.h"
#import "MXMHttpManager.h"
#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "JXJsonFunctionDefine.h"

@implementation MXMGeoCodeSearch

- (NSInteger)reverseGeoCode:(MXMReverseGeoCodeSearchOption *)reverseGeoCodeOption
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL,@"/bms/api/v3/locate/indoor-coding"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"lat"] = @(reverseGeoCodeOption.location.latitude);
    dic[@"lon"] = @(reverseGeoCodeOption.location.longitude);
    dic[@"ordinalFloor"] = reverseGeoCodeOption.floorOrdinal ? : reverseGeoCodeOption.ordinalFloor;

    NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onGetReverseGeoCode:result:error:)]) {
            MXMReverseGeoCodeSearchResult *result = [MXMReverseGeoCodeSearchResult yy_modelWithJSON:content];
            if (result.building && result.floor) {
                [self.delegate onGetReverseGeoCode:self result:result error:nil];
            } else {
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSKeyValueValidationError userInfo:@{NSLocalizedDescriptionKey:@"Result is null."}];
                [self.delegate onGetReverseGeoCode:self result:nil error:error];
            }
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onGetReverseGeoCode:result:error:)]) {
            [self.delegate onGetReverseGeoCode:self result:nil error:error];
        }
    }];
    
    return task.taskIdentifier;
}

@end
