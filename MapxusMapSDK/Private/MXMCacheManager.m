//
//  MXMCacheManager.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2020/9/15.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

#import "MXMCacheManager.h"
#import "MXMHttpManager.h"
#import "MXMConstants.h"
#import "JXJsonFunctionDefine.h"

@implementation MXMCacheManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getTheCache];
    }
    return self;
}

- (void)getTheCache {
    NSString *cacheVersionUrl = @"https://mapxusprod.blob.core.windows.net/com-mapxus-sdk/prod/version.json";
        
    [MXMHttpManager MXMGET:cacheVersionUrl parameters:nil success:^(NSDictionary *content) {
        NSDictionary *dic = DecodeDicFromDic(content, @"version");
        NSNumber *version = DecodeNumberFromDic(dic, @"tile");
        NSNumber *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"tile_version"];
        if (version) {
            if (oldVersion) {
                if (version.integerValue > oldVersion.integerValue) {
                    [MGLOfflineStorage.sharedOfflineStorage clearAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
                        if (error == nil) {
                            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tile_version"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }];
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"tile_version"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
