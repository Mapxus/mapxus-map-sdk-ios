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

/// MapxusMap is a class designed for managing indoor maps.
@interface MapxusMap : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// MapxusMap initialisation function.
/// @param mapView Bind MGLMapView as a map rendering tool.
- (instancetype)initWithMapView:(MGLMapView *)mapView;

/// MapxusMap initialisation function.
/// @param mapView Bind MGLMapView as a map rendering tool.
/// @param configuration Initialization parameters, see `MXMConfiguration` for details.
- (instancetype)initWithMapView:(MGLMapView *)mapView configuration:(nullable MXMConfiguration *)configuration;

/// Event callback agent for MapxusMap.
@property (nonatomic, weak, nullable) id<MapxusMapDelegate> delegate;

/// Building selection button. When tile data with multiple buildings is retrieved in the mapview's viewport, it will be displayed.
@property (nonatomic, strong, readonly) UIButton *buildingSelectButton;

/// Floor selector bar. When tile data with selected floor is retrieved in the mapview's viewport, it will be displayed.
@property (nonatomic, strong, readonly) MXMFloorSelectorBar *floorBar;

/// Keep the map controls, which include the `buildingSelectButton` and `floorBar`, consistently hidden, default is NO.
@property (nonatomic, assign) BOOL indoorControllerAlwaysHidden;

/// Set the position of the map controls, which include the `buildingSelectButton` and `floorBar`, default is `MXMSelectorPositionCenterLeft`.
@property (nonatomic, assign) MXMSelectorPosition selectorPosition;

/// Set the margin of the Mapxus logo from the bottom of the mapView, you can only pass 0 or a positive number, passing a negative number will reset it to 0
@property (nonatomic, assign) CGFloat logoBottomMargin;

/// Set the margin of the Open Street Source from the bottom of the mapView, you can only pass in 0 or a positive number, passing in a negative number will reset
/// it to 0.
@property (nonatomic, assign) CGFloat openStreetSourceBottomMargin;

/// If the attribution has been set to YES, an ‘(i)’ button will appear in the left corner of the map. If the attribution has been set to NO, two logo buttons will appear
/// in the bottom corners of the map.   The default is NO.
@property (nonatomic, assign) BOOL collapseCopyright;

/// The style of the border that will be drawn for the selected building.
/// @discussion The default value of this property is an MXMBorderStyle that evaluates
/// to `+ [MXMBorderStyle defaultSelectedBuildingBorderStyle]`. Set this
/// property to `nil` to reset it to the default style.
@property (nonatomic, strong, null_resettable) MXMBorderStyle *selectedBuildingBorderStyle;

/// Whether the outdoor map is displayed.
@property (nonatomic, assign) BOOL outdoorHidden;

/// The function of click on the map to switch the building, the default is YES.
@property (nonatomic, assign) BOOL gestureSwitchingBuilding;

/// When auto switch mode is on, the building is moved to the centre of the view and the building is automatically selected to show its internal structure. The
/// default is YES.
@property (nonatomic, assign) BOOL autoChangeBuilding;

/// Set the floor switch mode.
/// @discussion If attribution has been set to `MXMSwitchingByVenue`, switching floor will synchronize the floor ordinal for all buildings on the same venue;
/// If the attribution has been set to `MXMSwitchingByBuilding`, only the current building’s floor will change. The default is `MXMSwitchingByVenue`.
@property (nonatomic, assign) MXMFloorSwitchMode floorSwitchMode;

@property (nonatomic, assign) BOOL maskNonSelectedSite;

/// Detailed information about the currently selected floor. If the object is nil, it means no floor is selected.
@property (nonatomic, strong, readonly, nullable) MXMFloor *selectedFloor;

@property (nonatomic, strong, readonly, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `selectedFloor`");

/// The ID of the building where the currently selected floor is located. You can look up the tile information in the `buildings` dictionary or
/// retrieve the details through the building search interface. If `selectedFloor` is nil, the property will also be set to nil.
@property (nonatomic, strong, readonly, nullable) NSString *selectedBuildingId;

@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *building DEPRECATED_MSG_ATTRIBUTE("Please use `selectedBuildingId`");

/// The ID of the venue where the currently selected floor is located. You can look up the tile information in the `venues` dictionary or
/// retrieve the details through the venue search interface. If `selectedFloor` is nil, the property will also be set to nil.
@property (nonatomic, strong, readonly, nullable) NSString *selectedVenueId;

/// Detailed information about the floor where the user is currently positioned, which is only trusted if `MGLMapView`'s `userTrackingMode` is
/// not `MGLUserTrackingModeNone` value. nil when there is no indoor data.
@property (nonatomic, strong, readonly, nullable) NSString *userLocationFloor;

/// Detailed information about the building where the user is currently positioned, which is only trusted if `MGLMapView`'s `userTrackingMode` is
/// not `MGLUserTrackingModeNone` value. nil when there is no indoor data.
@property (nonatomic, strong, readonly, nullable) MXMGeoBuilding *userLocationBuilding;

/// Detailed information about the venue where the user is currently positioned, which is only trusted if `MGLMapView`'s `userTrackingMode` is
/// not `MGLUserTrackingModeNone` value. nil when there is no indoor data
@property (nonatomic, strong, readonly, nullable) MXMGeoVenue *userLocationVenue;

/// A compilation of all buildings, derived from the tile data of the current mapview viewport.
@property (nonatomic, strong, readonly) NSDictionary<NSString *, MXMGeoBuilding *> *buildings;

///  A compilation of all venues, derived from the tile data of the current mapview viewport.
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

/// Selects the specified floorId.
/// @param floorId The ID of the floor.
///
/// @discussion The map will be animated to zoom to that area with a margin of 0.
/// When the floorId passed in is nil, will clean the selected. When the floorId passed in is invalid, there will be no action.
- (void)selectFloorById:(nullable NSString *)floorId;

- (void)selectFloor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectFloorById:]");

/// Selects the specified floorId, with the zoom mode which you want.
/// @param floorId The ID of the floor.
/// @param zoomMode Zoom method.
/// @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid.
///
/// @discussion When the floorId passed in is nil, will clean the selected. When the floorId passed in is invalid, there will be no action.
- (void)selectFloorById:(nullable NSString *)floorId
               zoomMode:(MXMZoomMode)zoomMode
            edgePadding:(UIEdgeInsets)insets;

- (void)selectFloor:(nullable NSString *)floor
           zoomMode:(MXMZoomMode)zoomMode
        edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectFloorById:zoomMode:edgePadding:]");

/// Selects the building by buildingId.
/// @param buildingId The ID of the building.
///
/// @discussion The map will be animated to zoom to that area with a margin of 0.
/// When the buildingId passed in is nil, will clean the selected. When the buildingId passed in is invalid, there will be no action.
/// When you select a building, the floor will automatically switch to the one that was previously selected and saved in the history after map initialization.
/// If there is no history, the floor will be set to the `defaultDisplayedFloorId` of the building. If `defaultDisplayedFloorId` is nil,
/// then the floor with the closest ordinal to 0 will be chosen. If there are two such floors, the positive one will be preferred.
- (void)selectBuildingById:(nullable NSString *)buildingId;

- (void)selectBuilding:(nullable NSString *)buildingId DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectBuildingById:]");

/// Selects the building by buildingId, with the zoom mode which you want.
/// - Parameters:
///   - buildingId: The ID of the building.
///   - zoomMode: Zoom method.
///   - insets: Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid.
///
/// @discussion When the buildingId passed in is nil, will clean the selected. When the buildingId passed in is invalid, there will be no action.
/// When you select a building, the floor will automatically switch to the one that was previously selected and saved in the history after map initialization.
/// If there is no history, the floor will be set to the `defaultDisplayedFloorId` of the building. If `defaultDisplayedFloorId` is nil,
/// then the floor with the closest ordinal to 0 will be chosen. If there are two such floors, the positive one will be preferred.
- (void)selectBuildingById:(nullable NSString *)buildingId
                  zoomMode:(MXMZoomMode)zoomMode
               edgePadding:(UIEdgeInsets)insets;

- (void)selectBuilding:(nullable NSString *)buildingId
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("Please use - [MapxusMap selectBuildingById:zoomMode:edgePadding:]");


/// Selects the venue by venueId.
/// @param venueId The ID of the venue.
///
/// @discussion The map will be animated to zoom to that area with a margin of 0.
/// When the venueId passed in is nil, will clean the selected. When the venueId passed in is invalid, there will be no action.
/// When you select a venue, the floor will automatically switch to the one that was previously selected and saved in the history after map initialization.
/// If there is no history, the building from the venue will be selected first. The `defaultDisplayedBuildingId` of the venue will be checked to see
/// if it is not nil. If it is nil, the first building in the list of buildings in the venue will be selected. The floor will then be set to the `defaultDisplayedFloorId`
/// of the building. If `defaultDisplayedFloorId` is nil, then the floor with the closest ordinal to 0 will be chosen. If there are two such floors, the positive
/// one will be preferred.
- (void)selectVenueById:(nullable NSString *)venueId;

/// Selects the venue by venueId, with the zoom mode which you want.
/// @param venueId The ID of the venue.
/// @param zoomMode Zoom method.
/// @param insets Zoom to fit the margins, if zoomMode is `MXMZoomDisable` then the value passed in is invalid.
/// @discussion When the venueId passed in is nil, will clean the selected. When the venueId passed in is invalid, there will be no action.
/// When you select a venue, the floor will automatically switch to the one that was previously selected and saved in the history after map initialization.
/// If there is no history, the building from the venue will be selected first. The `defaultDisplayedBuildingId` of the venue will be checked to see
/// if it is not nil. If it is nil, the first building in the list of buildings in the venue will be selected. The floor will then be set to the `defaultDisplayedFloorId`
/// of the building. If `defaultDisplayedFloorId` is nil, then the floor with the closest ordinal to 0 will be chosen. If there are two such floors, the positive
/// one will be preferred.
- (void)selectVenueById:(nullable NSString *)venueId
               zoomMode:(MXMZoomMode)zoomMode
            edgePadding:(UIEdgeInsets)insets;

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("To be deprecated");

- (void)selectBuilding:(nullable NSString *)buildingId
                 floor:(nullable NSString *)floor
              zoomMode:(MXMZoomMode)zoomMode
           edgePadding:(UIEdgeInsets)insets DEPRECATED_MSG_ATTRIBUTE("To be deprecated");

/// An array of indoor annotations that have been added to the current mapview
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



