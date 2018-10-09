//
//  MXMZoomToOperation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/26.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMZoomToOperation.h"

@interface MXMZoomToOperation () {
@private
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

@property (nonatomic, copy) ZoomBlock zoomBlock;

@end

@implementation MXMZoomToOperation

- (instancetype)initWithBlock:(ZoomBlock)block
{
    self = [super init];
    if (self) {
        _zoomBlock = block;
    }
    return self;
}

- (void)start
{
//    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    if (![self isCancelled] && _zoomBlock) {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        self.zoomBlock(self.buildingId, self.floor, self.bounds, self.centerPoint);
        
        [self finish];
        
    } else {
        // If it's already been cancelled, mark the operation as finished.
        [self finish];
    }
}

- (void)finish
{
//    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
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
