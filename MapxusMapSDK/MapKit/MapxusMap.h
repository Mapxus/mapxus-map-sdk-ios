//
//  MapxusMap.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMFloorSelectorBar.h"
#import "MXMConfiguration.h"
#import "MXMDefine.h"

@class MGLMapView;
@class MXMGeoBuilding;
@class MXMPointAnnotation;
@protocol MapxusMapDelegate;


NS_ASSUME_NONNULL_BEGIN

/**
 * MapxusMap, managing indoor maps
 */
@interface MapxusMap : NSObject

/**
 MapxusMap initialisation function
 @param mapView Bind MGLMapView and introduce MapBox as a map rendering tool
 @return MapxusMap object
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView;

/**
 MapxusMap initialisation function
 @param mapView Bind MGLMapView and introduce MapBox as a map rendering tool
 @param configuration Initialization parameters, see `MXMConfiguration` for details
 @return MapxusMap object
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Event callback agent for MapxusMap
@property (nonatomic, weak, nullable) id<MapxusMapDelegate> delegate;

/// Building selection button, appears when multiple buildings appear in the rectangular area in the centre of the screen
@property (nonatomic, strong, readonly) UIButton *buildingSelectButton;

/// Floor selector
@property (nonatomic, strong, readonly) MXMFloorSelectorBar *floorBar;

/// Always hide map controls, default is NO
@property (nonatomic, assign) BOOL indoorControllerAlwaysHidden;

/// Set the position of the map control, default is `MXMSelectorPositionCenterLeft`
@property (nonatomic, assign) MXMSelectorPosition selectorPosition;

/// Set the margin of the Mapxus logo from the bottom of the mapView, you can only pass 0 or a positive number, passing a negative number will reset it to 0
@property (nonatomic, assign) CGFloat logoBottomMargin;

/// Set the margin of the Open Street Source from the bottom of the mapView, you can only pass in 0 or a positive number, passing in a negative number will reset it to 0
@property (nonatomic, assign) CGFloat openStreetSourceBottomMargin;

/// Whether the outdoor map is displayed
@property (nonatomic, assign) BOOL outdoorHidden;

/// The function of click on the map to switch the building, the default is YES.
@property (nonatomic, assign) BOOL gestureSwitchingBuilding;

/// When auto switch mode is on, the building is moved to the centre of the view and the building is automatically selected to show its internal structure. The default is YES
@property (nonatomic, assign) BOOL autoChangeBuilding;

/**
 Setting the general map appearance
 @param style Appearance type. Please refer to `MXMStyle` for specific attribute fields.
 */
- (void)setMapSytle:(MXMStyle)style;

/**
 Set up custom map appearance, you can contact us for map appearance customization
 @param styleName Appearance mame
 */
- (void)setMapStyleWithName:(NSString *)styleName;

/**
 Setting the map language
 @param language Map language with options for en, zh-Hant, zh-Hans, ja, ko, default
 */
- (void)setMapLanguage:(NSString *)language;

/// Currently selected floor
@property (nonatomic, copy, readonly, nullable) NSString *floor;

/// Current selected buildings
@property (nonatomic, copy, readonly, nullable) MXMGeoBuilding *building;

/**
 The user's current floor, which is only trusted if `MGLMapView`'s `userTrackingMode` is not `MGLUserTrackingModeNone` value.
  nil when there is no indoor data
 */
@property (nonatomic, copy, readonly, nullable) NSString *userLocationFloor;

/**
 The user's current building, which is only trusted if `MGLMapView`'s `userTrackingMode` is not `MGLUserTrackingModeNone` value.
  nil when there is no indoor data
 */
@property (nonatomic, copy, readonly, nullable) MXMGeoBuilding *userLocationBuilding;

/// Returns all the measured buildings visible in the currently bound MGLMapView viewport
@property (nonatomic, copy, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

/**
 Select the floor of the currently selected building and the map will move to that building area by default, with a zoom adaptation margin of 0
 @param floor The floor name of your choice.
 */
- (void)selectFloor:(nullable NSString *)floor;

/**
 Select the floor of the currently selected building
 @param floor The floor name of your choice.
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectFloor:(nullable NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets;

/**
 Selecting a building, the floor will automatically switch to the map's most recent floor switching history from creation, or if not, to the ground level, and the map will move to that building area by default, with a zoom adaptation margin of 0
 @param buildingId Id of the building to be selected
 */
- (void)selectBuilding:(nullable NSString *)buildingId;

/**
 Select the building and the floor will automatically switch to map's most recent floor switching history from creation, or if not, to the ground floor
 @param buildingId The ID of the building to be selected
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectBuilding:(nullable NSString *)buildingId
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets;

/**
 Select the building and the floor of that building and the map will move to that building area by default, with a zoom adaptation margin of 0
 @param buildingId ID of the building to be selected
 @param floor Floor name of choice
 */
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor;

/**
 Select the building and the floor of that building
 @param buildingId The ID of the building to be selected
 @param floor The name of the selected floor
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectBuilding:(nullable NSString *)buildingId
                 floor:(nullable NSString *)floor
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets;

/// An array of indoor annotations that have been added to the current MapView
@property (nonatomic, readonly) NSArray<MXMPointAnnotation *> *MXMAnnotations;

/**
 Add map annotations, if you need to add indoor points, you must call this method to layer them.
 @param annotations `MXMPointAnnotation` list
 */
- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations;

/**
 To delete a map marker, if you need to delete an indoor point, you must call this method to delete it completely.
 @param annotations `MXMPointAnnotation` list
 */
- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations;

@end

NS_ASSUME_NONNULL_END



