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

/**
 MapxusMap的delegate
 */
@protocol MapxusMapDelegate <NSObject>

@optional

/**
 Tell the delegate that the user clicked on the map.
 
 If either the `- [MapxusMapDelegate map:didSingleTapOnPOI:atCoordinate:atSite:]` or the
 `- [MapxusMapDelegate map:didSingleTapOnBlank:atSite:]` method is implemented, this method will not be called back.
 
 @param map Responding `MapxusMap` object.
 @param coordinate The coordinates of where the user clicked.
 */
- (void)map:(MapxusMap *)map
    didSingleTapAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapAtCoordinate:]`");

/**
 Tell the delegate that the user clicked on the POI.
 
 @param map Responding `MapxusMap` object.
 @param poi The information of the selected POI. Detailed information can be referred at `MXMGeoPOI`.
 @param coordinate The latitude and longitude of the actual click position. It may differ from the POI’s coordinates.
 @param site The information of the site which the user clicked on. If the user clicked outdoors, it will be nil.
*/
- (void)map:(MapxusMap *)map
    didSingleTapOnPOI:(MXMGeoPOI *)poi
    atCoordinate:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedOnPOI:(MXMGeoPOI *)poi
    atCoordinate:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapOnPOI:atCoordinate:atSite:]`");

/**
 Tell the delegate that the user clicked on the blank space in the map.
 
 @param map Responding `MapxusMap` object.
 @param coordinate The coordinate of the blank where the user clicked.
 @param site The information of the site which the user clicked on. If the user clicked outdoors, it will be nil.
*/
- (void)map:(MapxusMap *)map
    didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didSingleTappedOnMapBlank:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didSingleTapOnBlank:atSite:]`");

/**
 Tell the delegate that the user long press on the map.

 If `- [MapxusMapDelegate map:didLongPressAtCoordinate:atSite:]` method is implemented, this method will not be called back.
 
 @param map Responding `MapxusMap` object.
 @param coordinate Coordinates of the clicking position.
 */
- (void)map:(MapxusMap *)map
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)mapView:(MapxusMap *)mapView
    didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didLongPressAtCoordinate:]`");

/**
 Tell the delegate that the user long press on the map.

 @param map Responding `MapxusMap` object.
 @param coordinate Coordinates of the clicking position.
 @param site The information of the site which the user long press. If the user clicked outdoors, it will be nil.
 */
- (void)map:(MapxusMap *)map
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
    atSite:(nullable MXMSite *)site;

- (void)mapView:(MapxusMap *)mapView
    didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
    onFloor:(nullable NSString *)floorName
    inBuilding:(nullable MXMGeoBuilding *)building DEPRECATED_MSG_ATTRIBUTE("Please use `- [MapxusMapDelegate map:didLongPressAtCoordinate:atSite:]`");

/// Tell the delegate that the selected floor , building and venue have been changed.
/// - Parameters:
///   - map: Responding `MapxusMap` object.
///   - floor: The information of the selected floor. It can be nil when the selection is cleared.
///   - buildingId: The ID of the building where the currently selected floor is located. You can look up the tile information in the `buildings` dictionary or
///                 retrieve the details through the building search interface. If `selectedFloor` is nil, the property will also be set to nil.
///   - venueId: The ID of the venue where the currently selected floor is located. You can look up the tile information in the `venues` dictionary or
///              retrieve the details through the venue search interface. If `selectedFloor` is nil, the property will also be set to nil.
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

/// Called when the visual state of the selected floor changes, the same result may be called multiple times
/// - Parameters:
///   - map: Responding `MapxusMap` object.
///   - isVisible: Flag for whether a selected floor is visible.
///   - floor: The information of the selected floor. It can be nil when the selection is cleared.
///   - buildingId: The ID of the building where the currently selected floor is located. You can look up the tile information in the `buildings` dictionary or
///                 retrieve the details through the building search interface. If `selectedFloor` is nil, the property will also be set to nil.
///   - venueId: The ID of the venue where the currently selected floor is located. You can look up the tile information in the `venues` dictionary or
///              retrieve the details through the venue search interface. If `selectedFloor` is nil, the property will also be set to nil.
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




