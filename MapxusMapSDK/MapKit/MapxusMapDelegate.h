//
//  MapxusMapDelegate.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class MapxusMap;
@class MXMGeoPOI;
@class MXMFloor;
@class MXMGeoBuilding;
@class MXMGeoVenue;
@class MXMSite;

NS_ASSUME_NONNULL_BEGIN

/// The `MapxusMapDelegate` protocol defines a set of optional methods that you can use to receive indoor-map-related update messages.
@protocol MapxusMapDelegate <NSObject>

@optional


/// This method informs the delegate that the user clicked on the map.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param coordinate The coordinates where the user clicked.
///
/// @discussion
/// If either the `- [MapxusMapDelegate map:didSingleTapOnPOI:atCoordinate:atSite:]` or the
/// `- [MapxusMapDelegate map:didSingleTapOnBlank:atSite:]` method is implemented, this method will not be called back.
- (void)map:(MapxusMap *)map
    didSingleTapAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapAtCoordinate:]`");


/// This method informs the delegate that the user clicked on a Point of Interest (POI).
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param poi The `MXMGeoPOI` object representing the selected POI.
/// @param coordinate The actual latitude and longitude where the user clicked. It may differ from the POI’s coordinates.
/// @param site The `MXMSite` object representing the site where the user clicked. If the user clicked outdoors, it will be nil.
- (void)map:(MapxusMap *)map
    didSingleTapOnPOI:(MXMGeoPOI *)poi
    atCoordinate:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedOnPOI:(MXMGeoPOI *)poi
    atCoordinate:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapOnPOI:atCoordinate:atSite:]`");


/// This method informs the delegate that the user clicked on a blank space in the map.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param coordinate The coordinates of the blank space where the user clicked.
/// @param site The `MXMSite` object representing the site where the user clicked. If the user clicked outdoors, it will be nil.
- (void)map:(MapxusMap *)map
    didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedOnMapBlank:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapOnBlank:atSite:]`");


/// This method informs the delegate that the user long pressed on the map.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param coordinate The coordinates where the user long pressed.
///
/// @discussion
/// If `- [MapxusMapDelegate map:didLongPressAtCoordinate:atSite:]` method is implemented, this method will not be called back.
- (void)map:(MapxusMap *)map
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)mapView:(MapxusMap *)mapView
    didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didLongPressAtCoordinate:]`");


/// This method informs the delegate that the user long pressed on the map.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param coordinate The coordinates where the user long pressed.
/// @param site The `MXMSite` object representing the site where the user long pressed. If the user clicked outdoors, it will be nil.
- (void)map:(MapxusMap *)map
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didLongPressAtCoordinate:atSite:]`");


/// This method informs the delegate that the selected floor, building, and venue have changed.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param floor The `MXMFloor` object representing the selected floor. It can be nil when the selection is cleared.
/// @param buildingId The ID of the building where the currently selected floor is located. You can look up the tile information in the `MapxusMap.buildings` dictionary or
///        retrieve the details through the building search interface. If `floor` is nil, the property will also be set to nil.
/// @param venueId The ID of the venue where the currently selected floor is located. You can look up the tile information in the `MapxusMap.venues` dictionary or
///        retrieve the details through the venue search interface. If `floor` is nil, the property will also be set to nil.
- (void)map:(MapxusMap *)map
    didChangeSelectedFloor:(nullable MXMFloor *)floor
    inSelectedBuildingId:(nullable NSString *)buildingId
    atSelectedVenueId:(nullable NSString *)venueId;

- (void)map:(MapxusMap *)map
    didChangeSelectedFloor:(nullable MXMFloor *)floor
    inSelectedBuilding:(nullable MXMGeoBuilding *)building
    atSelectedVenue:(nullable MXMGeoVenue *)venue DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didChangeSelectedFloor:inSelectedBuildingId:atSelectedVenueId:]`");

- (void)mapView:(MapxusMap *)mapView
    didChangeFloor:(nullable NSString *)floorName
    atBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didChangeSelectedFloor:inSelectedBuildingId:atSelectedVenueId:]`");


/// Called when the visual state of the selected floor changes.
///
/// @param map The `MapxusMap` object that the user interacted with.
/// @param isVisible A flag indicating whether a selected floor is visible.
/// @param floor The `MXMFloor` object representing the selected floor. It can be nil when the selection is cleared.
/// @param buildingId The ID of the building where the currently selected floor is located. You can look up the tile information in the `MapxusMap.buildings` dictionary or
///        retrieve the details through the building search interface. If `floor` is nil, the property will also be set to nil.
/// @param venueId The ID of the venue where the currently selected floor is located. You can look up the tile information in the `MapxusMap.venues` dictionary or
///        retrieve the details through the venue search interface. If `floor` is nil, the property will also be set to nil.
///
/// @discussion
/// the same result may be called multiple times.
- (void)map:(MapxusMap *)map
    didChangeSelectedFloorVisualizationStatus:(BOOL)isVisible
    withSelectedFloor:(nullable MXMFloor *)floor
    selectedBuildingId:(nullable NSString *)buildingId
    selectedVenueId:(nullable NSString *)venueId;

- (void)map:(MapxusMap *)map
    didChangeIndoorSiteAccess:(BOOL)flag
    selectedFloor:(nullable MXMFloor *)floor
    selectedBuilding:(nullable MXMGeoBuilding *)building
    selectedVenue:(nullable MXMGeoVenue *)venue DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didChangeSelectedFloorVisualizationStatus:withSelectedFloor:selectedBuildingId:selectedVenueId:]`");

- (void)mapView:(MapxusMap *)mapView
    indoorMapWithIn:(BOOL)flag
    building:(nullable NSString *)buildingId
    floor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didChangeSelectedFloorVisualizationStatus:withSelectedFloor:selectedBuildingId:selectedVenueId:]`");

@end

NS_ASSUME_NONNULL_END




