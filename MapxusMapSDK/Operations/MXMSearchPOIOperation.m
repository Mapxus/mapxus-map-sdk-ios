//
//  MXMSearchPOIOperation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchPOIOperation.h"
#import "MXMSearchAPI.h"

@interface MXMSearchPOIOperation () <MXMSearchDelegate> {
@private
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

@property (nonatomic, strong) MXMSearchAPI *api;
@property (nonatomic, strong) NSString *poiId;

@end

@implementation MXMSearchPOIOperation

- (instancetype)initWithPoiId:(NSString *)poiId
{
    if (poiId == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _poiId = poiId;
    }
    return self;
}

- (void)start
{
    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    if (![self isCancelled] && _poiId) {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        MXMPOISearchRequest *re = [[MXMPOISearchRequest alloc] init];
        re.POIIds = @[self.poiId];
        
        self.api = [[MXMSearchAPI alloc] init];
        self.api.delegate = self;
        [self.api MXMPOISearch:re];
    } else {
        // If it's already been cancelled, mark the operation as finished.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)finish
{
    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    self.api = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self finish];
}

- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response
{
    MXMPOI *poi = response.pois.firstObject;
    if (self.complateBlock) {
        self.complateBlock(poi.buildingId, poi.floor, CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude));
    }
    [self finish];
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

@end
