//
//  MXMPointAnnotation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

/**
 For creating indoor annotations
 */
@interface MXMPointAnnotation : MGLPointAnnotation

/// The floorId indicates the location of the annotation. The marker will only be displayed when the floorId matches the currently selected floor.
/// If it is set to nil, it signifies that the annotation is outdoors and will be displayed at all times.
@property (nonatomic, strong, nullable) NSString *floorId;

@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");

@property (nonatomic, strong, nullable) NSString *buildingId DEPRECATED_MSG_ATTRIBUTE("Will be removed");

@end

NS_ASSUME_NONNULL_END
