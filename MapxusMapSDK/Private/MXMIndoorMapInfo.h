//
//  MXMIndoorMapInfo.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/5/31.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMGeoBuilding.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMIndoorMapInfo : NSObject

@property (nonatomic, strong) MXMGeoBuilding *building;

@property (nonatomic, strong) NSString *floor;

- (instancetype)initWithBuilding:(MXMGeoBuilding *)building floor:(NSString *)floor;

@end

NS_ASSUME_NONNULL_END
