//
//  MXMSearchBuildingOperation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/MGLGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMSearchBuildingOperation : NSOperation

@property (nonatomic, copy) void (^complateBlock)(NSString *buildingId, NSString *floor, MGLCoordinateBounds bounds);

- (instancetype)initWithBuildingId:(NSString *)buildingId floor:(NSString *)floor;

@end

NS_ASSUME_NONNULL_END
