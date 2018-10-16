//
//  MXMLoadMapOperation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMLoadMapOperation.h"

@interface MXMLoadMapOperation () {
@private
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

@property (nonatomic, copy) LoadMapBlock loadBlock;

@end

@implementation MXMLoadMapOperation

- (instancetype)initWithBlock:(LoadMapBlock)block
{
    self = [super init];
    if (self) {
        _loadBlock = block;
    }
    return self;
}

- (void)start
{
//    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    if (![self isCancelled] && _loadBlock) {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        self.loadBlock(self.token);
        
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
