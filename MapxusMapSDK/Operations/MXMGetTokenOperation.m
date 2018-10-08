//
//  MXMGetTokenOperation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGetTokenOperation.h"
#import "MXMMapServices+Private.h"

@interface MXMGetTokenOperation () {
@private
    // properties to maintain the NSOperation
    BOOL finished;
    BOOL executing;
}

@end

@implementation MXMGetTokenOperation

- (void)start
{
    NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
    if (![self isCancelled]) {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        __weak typeof(self) weakSelf = self;
        [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
            if (token && weakSelf.complateBlock) {
                weakSelf.complateBlock(token);
            }
            [weakSelf finish];
        }];
        
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
