//
//  UIImage+MXMSdk.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/15.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "UIImage+MXMSdk.h"
#import "MXMSDKBundle.h"

@implementation UIImage (MXMSdk)

+ (UIImage *)getMXMSdkImage:(NSString *)name {
  return [UIImage imageNamed:name inBundle:[MXMSDKBundle getMXMSdkBundle] compatibleWithTraitCollection:nil];
}

@end
