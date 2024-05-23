//
//  MXMDefine.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#ifndef MXMDefine_h
#define MXMDefine_h
#import <Foundation/Foundation.h>

/// MapxusMap map appearance
typedef NS_ENUM(NSUInteger, MXMStyle) {
  /// MAPXUSMAP style
  MXMStyleMAPXUS,
  /// COMMON style
  MXMStyleCOMMON,
  /// Christmas style
  MXMStyleCHRISTMAS,
  /// Halloween style
  MXMStyleHALLOWMAS,
  /// MAPPYBEE style
  MXMStyleMAPPYBEE,
};


/// Floor controller locations
typedef NS_ENUM(NSInteger, MXMSelectorPosition) {
  /// In the middle of the left-hand side of the screen
  MXMSelectorPositionCenterLeft,
  /// In the middle of the right-hand side of the screen
  MXMSelectorPositionCenterRight,
  /// In the bottom left corner of the screen
  MXMSelectorPositionBottomLeft,
  /// In the bottom right corner of the screen
  MXMSelectorPositionBottomRight,
  /// In the top left corner of the screen
  MXMSelectorPositionTopLeft,
  /// In the top right corner of the screen
  MXMSelectorPositionTopRight,
};


/// Zoom method indicating whether to modify the camera of the map
typedef NS_ENUM(NSInteger, MXMZoomMode) {
  /// No zoom, i.e., the camera of the map remains unchanged
  MXMZoomDisable,
  /// Zoom by animation, i.e., the camera of the map is modified with an animation
  MXMZoomAnimated,
  /// No animated zoom, i.e., the camera of the map is modified directly without an animation
  MXMZoomDirect
};


/// The mode for switching floors.
typedef NS_ENUM(NSInteger, MXMFloorSwitchMode) {
  /// When the user switches the floor of the selected building, the floors of the other buildings in the same venue will also switch to the same ordinal.
  MXMSwitchedByVenue,
  /// Only the floor of the selected building will change.
  MXMSwitchedByBuilding
};


/// Routing Instructions
typedef NS_ENUM(NSInteger, MXMRouteSign) {
  /// Indicates going downstairs
  MXMDownstairs = -100,
  /// Indicates making a U-Turn to the left
  MXMLeftUTurn = -8,
  /// Indicates keeping to the left
  MXMKeepLeft = -7,
  /// Indicates making a sharp left turn
  MXMTurnSharpLeft = -3,
  /// Indicates making a left turn
  MXMTurnLeft = -2,
  /// Indicates making a slight left turn
  MXMTurnSlightLeft = -1,
  /// Indicates moving forward
  MXMContinueOnStreet = 0,
  /// Indicates making a slight right turn
  MXMTurnSlightRight = 1,
  /// Indicates making a right turn
  MXMTurnRight = 2,
  /// Indicates making a sharp right turn
  MXMTurnSharpRight = 3,
  /// Indicates reaching the destination
  MXMFinish = 4,
  /// Indicates arrival at a waypoint
  MXMReachedVia = 5,
  /// Indicates keeping to the right
  MXMKeepRight = 7,
  /// Indicates making a U-Turn to the right
  MXMRightUTurn = 8,
  /// Indicates going upstairs
  MXMUpstairs = 100,
  /// Indicates being on the road by shuttle bus
  MXMShuttleBus = 104,
  /// Indicates waiting for the shuttle bus
  MXMShuttleBusWaiting = 105,
  /// Indicates being at a shuttle bus station
  MXMShuttleBusStation = 106,
  /// Indicates getting off at a shuttle bus station
  MXMShuttleBusEndTrip = 107,
  /// Indicates leaving a building
  MXMLeaveBuilding = 200,
  /// Indicates entering a building
  MXMEnterBuilding = 201,
  /// Indicates passing a gate line, such as a subway gate
  MXMPassGateline = 202,
  /// Indicates moving from one building to another through a connecting corridor
  MXMThroughConnectingCorridor = 300,
  /// Indicates passing an area, the area is defined with the instruction type
  MXMPassArea = 301,
};


#endif /* MXMDefine_h */
