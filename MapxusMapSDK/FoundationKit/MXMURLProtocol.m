//
//  MXMURLProtocol.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/8/3.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMURLProtocol.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface MXMURLProtocol () <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) NSURLSessionDataTask *task;
@end

@implementation MXMURLProtocol

+ (void)start
{    
    [NSURLProtocol registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    NSString *host = [[request.URL host] lowercaseString];
    if ([host containsString:@"maphive"] ||
        [host containsString:@"mapxus"]) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mRequest = [request mutableCopy];
    NSBundle *bundle = [NSBundle bundleForClass:[MXMURLProtocol class]];
    NSDictionary *infoDic = [bundle infoDictionary];
    NSString *version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MXMUUID"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"MXMToken"];
    [mRequest setValue:version forHTTPHeaderField:@"sdkVersion"];
    [mRequest setValue:uuid forHTTPHeaderField:@"identifier"];
    [mRequest setValue:token forHTTPHeaderField:@"token"];
    return mRequest;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    BOOL rst = [super requestIsCacheEquivalent:a toRequest:b];
    return rst;
}

- (void)startLoading {
    NSMutableURLRequest *req = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:req];
    self.task = [self.session dataTaskWithRequest:req];
    [self.task resume];
}

- (void)stopLoading {
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 所有捕获的请求都检测statusCode，因为有部分请求如瓦片没有用MXMHttpManager请求
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        // get response
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        // authority error
        if (response.statusCode == 401) {
            NSURL *failingURL = self.request.URL;
            NSString *failingURLString = failingURL.absoluteString;
            // login request did not request again
            if (![failingURLString containsString:@"/api/v1/user/verification"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kCTUserTokenInvalidNotification" object:nil];
            }
        }
    }
    // go on what to do
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - Lazy load

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}

@end
