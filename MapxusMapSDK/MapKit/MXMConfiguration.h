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

/// This class is used for the initial configuration of MapxusMap.
@interface MXMConfiguration : NSObject


/// A boolean value indicating whether to display the outdoor map. The default is NO.
@property (nonatomic) BOOL outdoorHidden;


/// The default style for the map. 
///
/// @discussion This can be configured with other conditions except `defaultStyleName`. The default is MXMStyleMAPXUS.
@property (nonatomic) MXMStyle defaultStyle;


/// The name of the custom map style. 
///
/// @discussion When this parameter is set to a non-null value, the `defaultStyle` is ignored. The default is nil.
@property (nonatomic, copy, nullable) NSString *defaultStyleName;


/// The poiId used for the initialization of the map.
///
/// @discussion If this value is set to a non-nil, the `floorId`, `buildingId`, and `venueId` will be disregarded. The map initialization will then
/// reposition the map’s center to the coordinates of the specified point of POI.
@property (nonatomic, copy, nullable) NSString *poiId;


/// The initial zoom level of the map with poiId. The default is 19.
@property (nonatomic, assign) double zoomLevel;


/// The floorId used for the initialization of the map.
///
/// @discussion If this value is set to a non-nil, the `buildingId` and `venueId` will be disregarded. Upon initialization, the map will adjust
/// the mapView’s viewport to fit the bbox of the building to which the floor belongs, with additional padding included on each side.
@property (nonatomic, copy, nullable) NSString *floorId;

@property (nonatomic, copy, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");


/// The buildingId used for the initialization of the map.
///
/// @discussion If this value is set to a non-nil, the `venueId` will be disregarded. The map initialization will then change the mapView's viewport to fit
/// the bbox with some additional padding on each side.
@property (nonatomic, copy, nullable) NSString *buildingId;


/// The venueId used for the initialization of the map.
///
/// @discussion If this value is set to a non-nil. Upon initialization, the map will adjust the mapView’s viewport to fit the bounding box of
/// the venue’s default display building, with additional padding included on each side. If there is no default display building, the first building from
/// the venue’s building list will be used.
@property (nonatomic, copy, nullable) NSString *venueId;


/// Adaptive margins when initializing a map by floorId, buildingId or revenueId. Default value is UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets zoomInsets;

@end

NS_ASSUME_NONNULL_END
