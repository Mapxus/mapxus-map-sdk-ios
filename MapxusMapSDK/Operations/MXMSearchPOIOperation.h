//
//  MXMSearchPOIOperation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/25.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/MGLGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMSearchPOIOperation : NSOperation

@property (nonatomic, copy) void (^complateBlock)(NSString *buildingId, NSString *floor, CLLocationCoordinate2D centerPoint);
@property (nonatomic, copy) NSString *poiId;

- (instancetype)initWithPoiId:(NSString *)poiId;

@end

NS_ASSUME_NONNULL_END
