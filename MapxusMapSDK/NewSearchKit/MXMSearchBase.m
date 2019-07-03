//
//  MXMSearchBase.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchBase.h"
#import "MXMHttpManager.h"

@implementation MXMSearchBase

- (void)cancelTaskById:(NSInteger)taskId
{
    AFHTTPSessionManager *manager = [MXMHttpManager sharedManager];
    for (NSURLSessionTask *task in manager.tasks) {
        if (task.taskIdentifier == taskId) {
            [task cancel];
        }
    }
}

@end
