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

/**
 MapxusMap map appearance
 */
typedef NS_ENUM(NSUInteger, MXMStyle) {
    /**
     MAPXUSMAP style
     */
    MXMStyleMAPXUS,
    /**
     COMMON style
     */
    MXMStyleCOMMON,
    /**
     Christmas style
     */
    MXMStyleCHRISTMAS,
    /**
     Halloween style
     */
    MXMStyleHALLOWMAS,
    /**
     MAPPYBEE style
     */
    MXMStyleMAPPYBEE,
};



/**
 Floor controller locations
 */
typedef NS_ENUM(NSInteger, MXMSelectorPosition) {
    /**
     In the middle of the left-hand side of the screen
     */
    MXMSelectorPositionCenterLeft,
    /**
     In the middle of the right-hand side of the screen
     */
    MXMSelectorPositionCenterRight,
    /**
     In the bottom left corner of the screen
     */
    MXMSelectorPositionBottomLeft,
    /**
     In the bottom right corner of the screen
     */
    MXMSelectorPositionBottomRight,
    /**
     In the top left corner of the screen
     */
    MXMSelectorPositionTopLeft,
    /**
     In the top right corner of the screen
     */
    MXMSelectorPositionTopRight,
};


/**
 Zoom method
 */
typedef NS_ENUM(NSInteger, MXMZoomMode) {
    /**
     No zoom
     */
    MXMZoomDisable,
    /**
     Zoom by animation
     */
    MXMZoomAnimated,
    /**
     No animated zoom
     */
    MXMZoomDirect
};


/**
 The floor switch mode.
 */
typedef NS_ENUM(NSInteger, MXMFloorSwitchMode) {
  
  /// Switching floor will synchronize the floor ordinal for all buildings on the same venue.
  MXMSwitchingByVenue,
  
  /// Only the current building’s floor will change.
  MXMSwitchingByBuilding
};


/**
 Routing Instructions
 */
typedef NS_ENUM(NSInteger, MXMRouteSign) {
    /**
     Downstairs
     */
    MXMDownstairs = -100,
    /**
      Make a U-Turn on left
     */
    MXMLeftUTurn = -8,
    /**
     Keep to the left
     */
    MXMKeepLeft = -7,
    /**
     Turn sharp left
     */
    MXMTurnSharpLeft = -3,
    /**
     Turn left
     */
    MXMTurnLeft = -2,
    /**
     Slight left turn
     */
    MXMTurnSlightLeft = -1,
    /**
     Moving forward
     */
    MXMContinueOnStreet = 0,
    /**
     Slight right turn
     */
    MXMTurnSlightRight = 1,
    /**
     Turn right
     */
    MXMTurnRight = 2,
    /**
     Sharp turn to the right
     */
    MXMTurnSharpRight = 3,
    /**
     Complete
     */
    MXMFinish = 4,
    /**
     Walk on the right
     */
    MXMKeepRight = 7,
    /**
     Make a U-Turn on right
     */
    MXMRightUTurn = 8,
    /**
     Upstairs
     */
    MXMUpstairs = 100,
    /**
     Leave the building
     */
    MXMLeaveBuilding = 200,
    /**
     Enter the building
     */
    MXMEnterBuilding = 201,
    /**
     Pass gateline, such as subway gate
     */
    MXMPassGateline = 202,
    /**
     From one building to another building
     */
    MXMThroughConnectingCorridor = 300,
    /**
     Pass area, the area define with the instruction type
     */
    MXMPassArea = 301,
};


#endif /* MXMDefine_h */
