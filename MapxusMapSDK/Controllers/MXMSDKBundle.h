//
//  MXMSDKBundle.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/15.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MXMLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"", [MXMSDKBundle getMXMSdkBundle], nil)

@interface MXMSDKBundle : NSBundle

+ (NSBundle *)getMXMSdkBundle;

@end

NS_ASSUME_NONNULL_END

