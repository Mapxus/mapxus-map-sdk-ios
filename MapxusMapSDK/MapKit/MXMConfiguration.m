//
//  MXMConfiguration.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMConfiguration.h"

@implementation MXMConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _outdoorHidden = NO;
        _defaultStyle = MXMStyleMAPXUS;
        _zoomInsets = UIEdgeInsetsZero;
        _zoomLevel = 19;
    }
    return self;
}

@end
