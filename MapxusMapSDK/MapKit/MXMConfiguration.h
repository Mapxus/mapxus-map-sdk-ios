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

/// MapxusMap initial configuration.
@interface MXMConfiguration : NSObject

/// Whether to display the outdoor map,  NO is default.
@property (nonatomic) BOOL outdoorHidden;

/// Initialize regular map style, configurable with other conditions except `defaultStyleName`, MXMStyleMAPXUS is default.
@property (nonatomic) MXMStyle defaultStyle;

/// Initialize the custom map style, when this parameter is set to a non-null value, the `defaultStyle` is ignored, nil is default.
@property (nonatomic, copy, nullable) NSString *defaultStyleName;

/// Utilize the poiId for the initialization of the map.
/// @discussion Once this value is set to a non-nil, the `floorId`, `buildingId`, and `venueId` will be disregarded. The map initialization will then
/// reposition the map’s center to the coordinates of the specified point of POI.
@property (nonatomic, copy, nullable) NSString *poiId;

/// Initialize the initial zoom level of the map with poiId, 19 is default.
@property (nonatomic, assign) double zoomLevel;

/// Utilize the floorId for the initialization of the map.
/// @discussion Once this value is set to a non-nil, the `buildingId` and `venueId` will be disregarded. Upon initialization, the map will adjust
/// the mapView’s viewport to fit the bbox of the building to which the floor belongs, with additional padding included on each side.
@property (nonatomic, copy, nullable) NSString *floorId;

@property (nonatomic, copy, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");

/// Utilize the buildingId for the initialization of the map.
/// @discussion Once this value is set to a non-nil, the `venueId` will be disregarded. The map initialization will then changes the mapView's viewport to fit
/// the bbox with some additional padding on each side.
@property (nonatomic, copy, nullable) NSString *buildingId;

/// Utilize the venueId for the initialization of the map.
/// @discussion Once this value is set to a non-nil. Upon initialization, the map will adjust the mapView’s viewport to fit the bounding box of
/// the venue’s default display building, with additional padding included on each side. If there is no default display building, the first building from
/// the venue’s building list will be used.
@property (nonatomic, copy, nullable) NSString *venueId;

/// Adaptive margins when initializing a map by floorId, buildingId or revenueId. Default value is UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets zoomInsets;

@end

NS_ASSUME_NONNULL_END
