//
//  MXMBorderStyle.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/5/29.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMBorderStyle : NSObject

/**
 Stroke thickness.
 
 This property is measured in points. And it will pass to `MGLLineStyleLayer.lineWidth` of MapLibre SDK without modification.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *lineWidth;

/**
 The opacity at which the line will be drawn.
 
 This property will pass to `MGLLineStyleLayer.lineOpacity` of MapLibre SDK without modification.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *lineOpacity;

/**
 The color with which the line will be drawn.
 
 This property will pass to `MGLLineStyleLayer.lineColor` of MapLibre SDK without modification.

 The default value of this property is an expression that evaluates to
 `#A5E3FF`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `linePattern` is set to `nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *lineColor;

/**
 Generate the style of the border that will be drawn for the selected building.
 
 The values of the style set are as follows:
 * `lineWidth`: 3
 * `lineOpacity`: 1
 * `lineColor`: #A5E3FF
 */
+ (MXMBorderStyle *)defaultSelectedBuildingBorderStyle;

@end

NS_ASSUME_NONNULL_END
