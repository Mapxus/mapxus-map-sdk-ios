//
//  NSString+Compare.h
//  Phchat
//
//  Created by Chenghao Guo on 2018/7/24.
//  Copyright © 2018年 XiaoPao Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Compare)

/**
 *  Determine if a string is empty
 *
 *  @param string Detection of target characters
 *
 *  @return YES:String with no valid value， NO:Strings have valid values
 */
+ (BOOL)isEmpty:(NSString *)string;


@end
