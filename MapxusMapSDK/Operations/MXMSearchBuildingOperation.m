//
//  MXMSearchBuildingOperation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchBuildingOperation.h"
#import "MXMSearchAPI.h"

@interface MXMSearchBuildingOperation () <MXMSearchDelegate> {
@private
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

@property (nonatomic, strong) MXMSearchAPI *api;

@end

@implementation MXMSearchBuildingOperation

- (instancetype)initWithBuildingId:(NSString *)buildingId floor:(NSString *)floor
{
    self = [super init];
    if (self) {
        _buildingId = buildingId;
        _floor = floor;
    }
    return self;
}

- (void)start
{
    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    if (![self isCancelled] && _buildingId) {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
        re.buildingIds = @[self.buildingId];
        
        self.api = [[MXMSearchAPI alloc] init];
        self.api.delegate = self;
        [self.api MXMBuildingSearch:re];
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

#pragma mark - MXMSearchDelegate

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self finish];
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response
{
    MXMBuilding *building = response.buildings.firstObject;
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(building.bbox.min_latitude, building.bbox.min_longitude), CLLocationCoordinate2DMake(building.bbox.max_latitude, building.bbox.max_longitude));

    if (self.complateBlock) {
        self.complateBlock(building, self.floor, bounds);
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
