//
//  NSString+Compare.m
//  Phchat
//
//  Created by Chenghao Guo on 2018/7/24.
//  Copyright © 2018年 XiaoPao Technology. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)

// 判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
