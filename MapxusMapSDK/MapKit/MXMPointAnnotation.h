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

/// The id of the floor where the annotation is located
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");

/// The id of the building where the annotation is located
@property (nonatomic, strong, nullable) NSString *buildingId;

@end

NS_ASSUME_NONNULL_END
