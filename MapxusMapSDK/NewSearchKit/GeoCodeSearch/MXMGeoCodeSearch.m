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

// 根据[SDK-854] 【iOS】SDK增加對歷史定位ordinal進行缓存，修改请求导航路线方法和路线吸附方法，定义全局变量作为室外定位时的默认与历史楼层记录
NSInteger historyFloor = 0;

@implementation MXMGeoCodeSearch

- (NSInteger)reverseGeoCode:(MXMReverseGeoCodeSearchOption *)reverseGeoCodeOption
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMAPIHOSTURL,@"/bms/api/v3/locate/indoor-coding"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"lat"] = @(reverseGeoCodeOption.location.latitude);
    dic[@"lon"] = @(reverseGeoCodeOption.location.longitude);
    dic[@"ordinalFloor"] = reverseGeoCodeOption.floorOrdinal ? : reverseGeoCodeOption.ordinalFloor;
    // 根据[SDK-854] 【iOS】SDK增加對歷史定位ordinal進行缓存，修改请求导航路线方法和路线吸附方法，当用户没有传入ordinal时，把历史或默认值填入以增强解析体验
    if (dic[@"ordinalFloor"] == nil) {
      dic[@"ordinalFloor"] = @(historyFloor);
    }

    NSURLSessionTask *task = [MXMHttpManager MXMGET:url parameters:dic success:^(NSDictionary *content) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onGetReverseGeoCode:result:error:)]) {
            MXMReverseGeoCodeSearchResult *result = [MXMReverseGeoCodeSearchResult yy_modelWithJSON:content];
            if (result.building && result.floor) {
                NSNumber *level = dic[@"ordinalFloor"];
                if (level) {
                  MXMOrdinal *ordinal = [[MXMOrdinal alloc] init];
                  ordinal.level = level.integerValue;
                  result.floor.ordinal = ordinal;
                }
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
