//
//  MXMMapServices.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMMapServices+Private.h"
#import "JXJsonFunctionDefine.h"
#import "MXMConstants.h"
#import "MXMURLProtocol.h"
#import "MXMHttpManager.h"

@import Mapbox;

@implementation MXMMapServices

+ (instancetype)sharedServices {
    static MXMMapServices *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MXMMapServices alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MGLAccountManager setAccessToken:MapboxAccessToken];
        [MXMURLProtocol start];
        [self writeUUID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"kCTUserTokenInvalidNotification" object:nil];
    }
    return self;
}

- (void)writeUUID
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MXMUUID"];
    if ([uuid isEqualToString:@""] || uuid == nil) {
        NSString *tUUID = [NSUUID UUID].UUIDString;
        [[NSUserDefaults standardUserDefaults] setObject:tUUID forKey:@"MXMUUID"];
    }
}

- (void)notificationAction:(NSNotification *)notification
{
    [self registerWithApiKey:self.apiKey secret:self.secret complete:nil];
}


- (void)registerWithApiKey:(NSString *)apiKey secret:(NSString *)secret complete:(void (^)(NSError *error))complete
{
    NSString *url = [NSString stringWithFormat:@"%@%@", MXMHOSTURL, @"/api/v1/user/verification"];
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    muDic[@"appId"] = apiKey;
    muDic[@"secret"] = secret;
    muDic[@"keyPlatform"] = @"IOS";
    muDic[@"bundleId"] = [[NSBundle mainBundle] bundleIdentifier];
    
    [MXMHttpManager MXMPOST:url parameters:muDic success:^(NSDictionary *content) {
        NSString *token = DecodeStringFromDic(content, @"idToken");
        if (token) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"MXMToken"];
        }
        if (complete) {
            complete(nil);
        }
    } failure:^(NSError *error) {
        if (complete) {
            complete(error);
        }
        NSLog(@"\n=================\nMXMMapServices register error:\n\n%@\n=================\n", error);
    }];
}

#pragma mark - public

- (void)getTokenComplete:(void (^)(NSString * token))complete
{
    NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"MXMToken"];
    
    BOOL needToRefresh = YES;
    if (oldToken) {
        NSArray *textArr = [oldToken componentsSeparatedByString:@"."];
        if (textArr.count > 2) {
            NSString *stringBase64 = textArr[1];
            NSData *data = [[NSData alloc] initWithBase64EncodedString:stringBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:(data?:[NSData data]) options:kNilOptions error:&jsonError];
            
            if (jsonError == nil &&
                [json isKindOfClass:[NSDictionary class]]) {
                NSNumber *exp = DecodeNumberFromDic(json, @"exp");
                NSTimeInterval now = [NSDate date].timeIntervalSince1970;
                NSTimeInterval space = [exp doubleValue] - now;
                if (space > 60*5) {
//                    NSLog(@"ddd %f", space);
                    needToRefresh = NO;
                }
            }
        }
    }
    
    if (needToRefresh) {
        [self registerWithApiKey:self.apiKey secret:self.secret complete:^(NSError *error) {
            NSString *newToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"MXMToken"];
            if (error == nil && complete) {
//                NSLog(@"=====use new");
                complete(newToken);
            }
        }];
    } else {
        if (complete) {
//            NSLog(@"=====use old");
            complete(oldToken);
        }
    }
}

- (void)registerWithApiKey:(NSString *)apiKey secret:(NSString *)secret
{
    self.apiKey = apiKey;
    self.secret = secret;
    [self registerWithApiKey:apiKey secret:secret complete:nil];
}


@end
