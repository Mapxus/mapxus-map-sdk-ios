//
//  MXMZoomToOperation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/26.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/MGLGeometry.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZoomBlock)(NSString *buildingId, NSString *floor, MGLCoordinateBounds bounds, CLLocationCoordinate2D centerPoint);

@interface MXMZoomToOperation : NSOperation

@property (nonatomic, copy) NSString *buildingId;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, assign) MGLCoordinateBounds bounds;
@property (nonatomic, assign) CLLocationCoordinate2D centerPoint;

- (instancetype)initWithBlock:(ZoomBlock)block;

@end

NS_ASSUME_NONNULL_END
