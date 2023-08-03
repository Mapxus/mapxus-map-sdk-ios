//
//  MapxusMap.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMFloorSelectorBar.h>
#import <MapxusMapSDK/MXMConfiguration.h>
#import <MapxusMapSDK/MXMBorderStyle.h>
#import <MapxusMapSDK/MXMDefine.h>
#import <MapxusMapSDK/MXMCommonObj.h>
#import <MapxusmapSDK/MXMGeoBuilding.h>
#import <MapxusmapSDK/MXMGeoVenue.h>
#import <MapxusmapSDK/MXMPointAnnotation.h>

@class MGLMapView;
@protocol MapxusMapDelegate;


NS_ASSUME_NONNULL_BEGIN

/**
 MapxusMap, managing indoor maps.
 */
@interface MapxusMap : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 MapxusMap initialisation function.
 
 @param mapView Bind MGLMapView and introduce MapBox as a map rendering tool
 @return MapxusMap object
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView;

/**
 MapxusMap initialisation function.
 
 @param mapView Bind MGLMapView and introduce MapBox as a map rendering tool
 @param configuration Initialization parameters, see `MXMConfiguration` for details
 @return MapxusMap object
 */
- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration;

/// Event callback agent for MapxusMap.
@property (nonatomic, weak, nullable) id<MapxusMapDelegate> delegate;

/// Building selection button, appears when multiple buildings appear in the rectangular area in the centre of the screen.
@property (nonatomic, strong, readonly) UIButton *buildingSelectButton;

/// Floor selector bar.
@property (nonatomic, strong, readonly) MXMFloorSelectorBar *floorBar;

/// Always hide map controls, default is NO.
@property (nonatomic, assign) BOOL indoorControllerAlwaysHidden;

/// Set the position of the map control, default is `MXMSelectorPositionCenterLeft`.
@property (nonatomic, assign) MXMSelectorPosition selectorPosition;

/// Set the margin of the Mapxus logo from the bottom of the mapView, you can only pass 0 or a positive number, passing a negative number will reset it to 0
@property (nonatomic, assign) CGFloat logoBottomMargin;

/// Set the margin of the Open Street Source from the bottom of the mapView, you can only pass in 0 or a positive number, passing in a negative number will reset
/// it to 0.
@property (nonatomic, assign) CGFloat openStreetSourceBottomMargin;

/// If the attribution has been set to YES, an ‘(i)’ button will appear in the left corner of the map. If the attribution has been set to NO, two logo buttons will appear
/// in the bottom corners of the map.   The default is NO.
@property (nonatomic, assign) BOOL collapseCopyright;

/**
 The style of the border that will be drawn for the selected building.
 
 The default value of this property is an MXMBorderStyle that evaluates to `+ [MXMBorderStyle defaultSelectedBuildingBorderStyle]`. Set this
 property to `nil` to reset it to the default style.
 */
@property (nonatomic, strong, null_resettable) MXMBorderStyle *selectedBuildingBorderStyle;

/// Whether the outdoor map is displayed.
@property (nonatomic, assign) BOOL outdoorHidden;

/// The function of click on the map to switch the building, the default is YES.
@property (nonatomic, assign) BOOL gestureSwitchingBuilding;

/// When auto switch mode is on, the building is moved to the centre of the view and the building is automatically selected to show its internal structure. The
/// default is YES.
@property (nonatomic, assign) BOOL autoChangeBuilding;

/**
 Set the floor switch mode.
 
 If attribution has been set to MXMSwitchingByVenue, switching floor will synchronize the floor ordinal for all buildings on the same venue; If the attribution has
 been set to MXMSwitchingByBuilding, only the current building’s floor will change. The default is MXMSwitchingByVenue.
 */
@property (nonatomic, assign) MXMFloorSwitchMode floorSwitchMode;

/// Currently selected floor
@property (nonatomic, strong, readonly, nullable) MXMFloor *selectedFloor;

@property (nonatomic, strong, readonly, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `selectedFloor`");

/// Current selected building
@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *selectedBuilding;

@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *building DEPRECATED_MSG_ATTRIBUTE("Please use `selectedBuilding`");

/// Current selected venue
@property (nonatomic, strong, readonly, nullable) MXMGeoVenue *selectedVenue;

/**
 The user's current floor, which is only trusted if `MGLMapView`'s `userTrackingMode` is not `MGLUserTrackingModeNone` value.
  nil when there is no indoor data
 */
@property (nonatomic, strong, readonly, nullable) NSString *userLocationFloor;

/**
 The user's current building, which is only trusted if `MGLMapView`'s `userTrackingMode` is not `MGLUserTrackingModeNone` value.
  nil when there is no indoor data
 */
@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *userLocationBuilding;

/**
 The user's current venue, which is only trusted if `MGLMapView`'s `userTrackingMode` is not `MGLUserTrackingModeNone` value.
  nil when there is no indoor data
 */
@property (nonatomic, strong, readonly, nullable) MXMGeoVenue *userLocationVenue;

/// Returns all the measured buildings visible in the currently bound MGLMapView viewport
@property (nonatomic, strong, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

/// Returns all the measured venues visible in the currently bound MGLMapView viewport
@property (nonatomic, strong, readonly) NSDictionary<NSString *, MXMGeoVenue *> *venues;


/**
 Setting the general map appearance.
 
 @param style Appearance type. Please refer to `MXMStyle` for specific attribute fields.
 */
- (void)setMapSytle:(MXMStyle)style;

/**
 Set up custom map appearance, you can contact us for map appearance customization.
 
 @param styleName Appearance mame
 */
- (void)setMapStyleWithName:(NSString *)styleName;

/**
 Setting the map language.
 
 @param language Map language with options for en, zh-Hant, zh-Hans, ja, ko, default.
 */
- (void)setMapLanguage:(NSString *)language;

/**
 By selecting the floor of the current building, the map will automatically zoom in to that area with a margin of 0.
 
 @param floor The floor name of your choice. When the value passed in is null or invalid, the program does the following: if no buildings are selected, it clears
              the selection of buildings and floors; if some buildings are selected, it restores the previous selection of floors from the history saved after map
              initialization; if there is no history, it selects the floor with the ordinal closest to 0; if there are two such floors, it prefers the positive one.
 */
- (void)selectFloorById:(nullable NSString *)floorId;

- (void)selectFloor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectFloorById:]");

/**
 Select the floor of the currently selected building.
 
 @param floor The floor name of your choice. When the value passed in is null or invalid, the program does the following: if no buildings are selected, it clears
              the selection of buildings and floors; if some buildings are selected, it restores the previous selection of floors from the history saved after map
              initialization; if there is no history, it selects the floor with the ordinal closest to 0; if there are two such floors, it prefers the positive one.
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectFloorById:(nullable NSString *)floorId
               zoomMode:(MXMZoomMode)zoomMode
            edgePadding:(UIEdgeInsets)insets;

- (void)selectFloor:(nullable NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectFloorById:zoomMode:edgePadding:]");

/**
 Selecting a building. When you select a building, the floor will automatically switch to the one that was previously selected and saved in the history after the map
 initialization. If there is no history, it will select the floor that has the closest ordinal to 0. If there are two such floors, it will prefer the positive one.
 
 @param buildingId The ID of the building to be selected. If you pass in null, the currently selected building and floor will be cleared. If you pass in invalid values,
                   nothing will happen.
 */
- (void)selectBuildingById:(nullable NSString *)buildingId;

- (void)selectBuilding:(nullable NSString *)buildingId DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectBuildingById:]");

/**
 Selecting a building. When you select a building, the floor will automatically switch to the one that was previously selected and saved in the history after the map
 initialization. If there is no history, it will select the floor that has the closest ordinal to 0. If there are two such floors, it will prefer the positive one.
 
 @param buildingId The ID of the building to be selected. If you pass in null, the currently selected building and floor will be cleared. If you pass in invalid values,
                   nothing will happen.
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectBuildingById:(nullable NSString *)buildingId
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets;

- (void)selectBuilding:(nullable NSString *)buildingId
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectBuildingById:zoomMode:edgePadding:]");

/**
 
 */
- (void)selectVenueById:(nullable NSString *)venueId;

- (void)selectVenueById:(nullable NSString *)venueId
               zoomMode:(MXMZoomMode)zoomMode
            edgePadding:(UIEdgeInsets)insets;

/**
 Select the building and the floor of that building and the map will automatically zoom in to that area with a margin of 0.
 
 @param buildingId The ID of the building to be selected. If you pass in null, the currently selected building and floor will be cleared. If you pass in invalid values,
                   nothing will happen.
 @param floor The floor name of your choice. When the value passed in is null or invalid, the program does the following: if buildingId is null, it clears
              the selection of building and floor; if buildingId is valid, it restores the previous selection of floors from the history saved after map
              initialization; if there is no history, it selects the floor with the ordinal closest to 0; if there are two such floors, it prefers the positive one.
 */
- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("To be deprecated");

/**
 Select the building and the floor of that building
 
 @param buildingId The ID of the building to be selected. If you pass in null, the currently selected building and floor will be cleared. If you pass in invalid values,
                   nothing will happen.
 @param floor The floor name of your choice. When the value passed in is null or invalid, the program does the following: if buildingId is null, it clears
              the selection of building and floor; if buildingId is valid, it restores the previous selection of floors from the history saved after map
              initialization; if there is no history, it selects the floor with the ordinal closest to 0; if there are two such floors, it prefers the positive one.
 @param zoomMode Zoom method
 @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid
 */
- (void)selectBuilding:(nullable NSString *)buildingId
                 floor:(nullable NSString *)floor
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("To be deprecated");

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



