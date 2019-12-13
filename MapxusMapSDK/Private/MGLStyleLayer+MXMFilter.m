//
//  MGLStyleLayer+MXMFilter.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/18.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MGLStyleLayer+MXMFilter.h"

@implementation MGLStyleLayer (MXMFilter)

- (BOOL)isBuildingFillLayer
{
    return [self.identifier hasPrefix:@"mapxus-building-line"];
}

- (BOOL)isVenueFillLayer
{
    return [self.identifier hasPrefix:@"mapxus-venue-fill"];
}

- (BOOL)isIndoorSymbolLayer
{
    return [self isKindOfClass:[MGLSymbolStyleLayer class]] && [self.identifier hasPrefix:@"mapxus"];
}

- (BOOL)isOutdoorLayer
{
    return [self isKindOfClass:[MGLForegroundStyleLayer class]] && [((MGLForegroundStyleLayer *)self).sourceIdentifier isEqualToString:@"composite"];
}

@end
