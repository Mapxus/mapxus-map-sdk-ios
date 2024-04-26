//
//  NSString+MXMUtils.h
//  MapxusBaseSDK
//
//  Created by guochenghao on 2024/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MXMUtils)


/**
 * Determines if the string contains any valid characters. A string consisting only of spaces is considered invalid.
 *
 * @param input The target string to check.
 *
 * @return YES: The target string is valid, NO: The target string is invalid.
 */
+ (BOOL)mxmIsValid:(nullable NSString *)input;


/**
 * Calculates the SHA256 hash value of the target string.
 *
 * @param input The target string.
 *
 * @return The SHA256 hash value of the target string. Returns nil if there is an error with the input.
 */
+ (nullable NSString *)mxmSha256HashFor:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
