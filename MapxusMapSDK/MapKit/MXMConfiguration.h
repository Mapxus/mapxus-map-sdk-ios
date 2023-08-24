//
//  MXMConfiguration.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapxusMapSDK/MXMDefine.h>

NS_ASSUME_NONNULL_BEGIN

/**
 MapxusMap initial configuration.
 */
@interface MXMConfiguration : NSObject

/// Whether to display the outdoor map,  NO is default.
@property (nonatomic) BOOL outdoorHidden;

/// Initialize regular map style, configurable with other conditions except `defaultStyleName`, MXMStyleMAPXUS is default.
@property (nonatomic) MXMStyle defaultStyle;

/// Initialize the custom map style, when this parameter is set to a non-null value, the `defaultStyle` is ignored, nil is default.
@property (nonatomic, copy, nullable) NSString *defaultStyleName;

/// Specify the location of the building and floor to be displayed at the start of the map, if floor is not set, the ground floor of the building is displayed by default,
/// cannot be set at the same time as poiId.
@property (nonatomic, copy, nullable) NSString *floorId;
@property (nonatomic, copy, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");

/// Specify the location of the building to be displayed at the start of the map, which cannot be set at the same time as the poiId.
@property (nonatomic, copy, nullable) NSString *buildingId;

/// Specify the location of the venue to be displayed at the start of the map, which cannot be set at the same time as the poiId.
@property (nonatomic, copy, nullable) NSString *venueId;

/// Adaptive margins when initializing the map via buildingId, default value is UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets zoomInsets;

/// Initialize the map with poiId, so that the map starts to display the location centre set to poi latitude and longitude, and switch to the corresponding building and
/// floor, with buildingId and floor can not be set at the same time, if set poiId, then setting buildingId is invalid.
@property (nonatomic, copy, nullable) NSString *poiId;

/// Initialize the initial zoom level of the map with poiId, 19 is default.
@property (nonatomic, assign) double zoomLevel;

@end

NS_ASSUME_NONNULL_END
