//
//  MXMAnnotationsHolder.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/26.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import "MXMPointAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMAnnotationsHolder : NSObject

@property (nonatomic, strong) NSMutableArray *mxmPointAnnotations;

- (instancetype)initWithMapView:(MGLMapView *)mapView;

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations;

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations;

- (void)filterMXMAnnotationsWithBuilding:(NSString *)buildingId floor:(nullable NSString *)floor indoorState:(BOOL)isIndoor;

@end

NS_ASSUME_NONNULL_END
