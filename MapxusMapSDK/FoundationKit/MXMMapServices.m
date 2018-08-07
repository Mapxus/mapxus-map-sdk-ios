//
//  MXMMapServices.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMMapServices+Private.h"
#import "Constants.h"
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>
#import "MXMURLProtocol.h"

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
        [self setuppool];
        [MXMURLProtocol start];
        [self writeUUID];
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

- (void)setuppool
{
    //setup logging
    [AWSDDLog sharedInstance].logLevel = AWSLogLevelVerbose;
    
    //setup service config
    AWSServiceConfiguration *serviceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:CognitoIdentityUserPoolRegion credentialsProvider:nil];
    
    //create a pool
    AWSCognitoIdentityUserPoolConfiguration *configuration = [[AWSCognitoIdentityUserPoolConfiguration alloc] initWithClientId:CognitoIdentityUserPoolAppClientId  clientSecret:CognitoIdentityUserPoolAppClientSecret poolId:CognitoIdentityUserPoolId];
    
    [AWSCognitoIdentityUserPool registerCognitoIdentityUserPoolWithConfiguration:serviceConfiguration userPoolConfiguration:configuration forKey:@"UserPool"];
}

- (void)getTokenComplete:(void (^)(NSString * token))complete
{
    AWSCognitoIdentityUserPool *pool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:@"UserPool"];
    AWSCognitoIdentityUser *user = [pool currentUser];
    [[user getSession] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserSession *> * _Nonnull t) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(t.error){
                NSLog(@"Authentication error: %@", t.error);
            }else {
                NSString *idToken = t.result.idToken.tokenString;
                if (complete) {
                    complete(idToken);
                }
            }
        });
        return nil;
    }];
}

- (void)registerWithApiKey:(NSString *)apiKey secret:(NSString *)secret
{
    self.apiKey = apiKey;
    self.secret = secret;
    AWSCognitoIdentityUserPool *pool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:@"UserPool"];
    AWSCognitoIdentityUser *user = [pool currentUser];
    //    if (!user.isSignedIn) {
    [[user getSession:self.apiKey password:self.secret validationData:nil] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserSession *> * _Nonnull t) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(t.error){
                NSLog(@"Authentication error: %@", t.error);
            }else {
                NSString *idToken = t.result.idToken.tokenString;
                if (idToken) {
                    [[NSUserDefaults standardUserDefaults] setObject:idToken forKey:@"MXMToken"];
                }
            }
        });
        return nil;
    }];
    //    }
}


@end
