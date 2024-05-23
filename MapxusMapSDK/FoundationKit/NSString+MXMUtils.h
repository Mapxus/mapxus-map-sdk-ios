//
//  NSString+MXMUtils.h
//  MapxusBaseSDK
//
//  Created by guochenghao on 2024/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MXMUtils)


/// This class method checks if the given input string is valid.
///
/// @param input The string to be checked.
///
/// @return YES if the input string is valid, NO otherwise. A valid string is non-nil, not an instance of NSNull, and not a string of only whitespace.
+ (BOOL)mxmIsValid:(nullable NSString *)input;


/// This class method calculates the SHA256 hash for the given input string.
///
/// @param input The string for which the SHA256 hash is to be calculated.
///
/// @return The SHA256 hash of the input string. If the input is nil or cannot be encoded using UTF8, the return value is nil.
+ (nullable NSString *)mxmSha256HashFor:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
