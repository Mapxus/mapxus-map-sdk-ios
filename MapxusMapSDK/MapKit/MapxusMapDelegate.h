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
@class MXMGeoBuilding;

NS_ASSUME_NONNULL_BEGIN

/**
 MapxusMap的delegate
 */
@protocol MapxusMapDelegate <NSObject>

@optional

/**
 Callback of clicking the map. If `- mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:` or `- mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:` is implemented, there will be no callback of this method.
 
 @param mapView Responding MapxusMap object.
 @param coordinate Coordinates of the clicking position.
 */
- (void)mapView:(MapxusMap *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 Call this interface when clicking POI.
 
 @param mapView Responding MapxusMap object.
 @param poi Information of selected POI. Detailed information can be referred at `MXMIndoorPOI`.
 @param coordinate The latitude and longitude of the real click position, it could be different from poi's coordinate.
 @param floorName The name of the floor which you clicked on. It will be nil if you clicked outdoors.
 @param building The building information which you clicked on. It will be nil if you clicked outdoors.
*/
- (void)mapView:(MapxusMap *)mapView didSingleTappedOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building;

/**
 Clicking on the blank space in the map will call back this interface.
 
 @param mapView Responding MapxusMap object.
 @param coordinate The coordinate point of the blank where you clicked.
 @param floorName The name of the floor which you clicked on. It will be nil if you clicked outdoors.
 @param building The building information which you clicked on. It will be nil if you clicked outdoors.
*/
- (void)mapView:(MapxusMap *)mapView didSingleTappedOnMapBlank:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building;

/**
 It would be callbacked when you long press on the map. And it would not be callbacked if `- mapView:didLongPressedAtCoordinate:onFloor:inBuilding:` is implemented.
 
 @param mapView Responding MapxusMap object.
 @param coordinate Coordinates of the clicking position.
 */
- (void)mapView:(MapxusMap *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 It would be callbacked when you long press on the map.
 
 @param mapView Responding MapxusMap object.
 @param coordinate Coordinates of the clicking position.
 @param floorName The name of the floor which you long press on. It will be nil if you clicked outdoors.
 @param building The building information which you long press on. It will be nil if you clicked outdoors.
 */
- (void)mapView:(MapxusMap *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate onFloor:(nullable NSString *)floorName inBuilding:(nullable MXMGeoBuilding *)building;

/**
 Use this interface when changing selected floor.
 
 @param mapView Responding MapxusMap object.
 @param floorName Floor name of the selected building.
 @param building Building information of the selected building. Detailed information can be referred at `MXMIndoorBuilding`.
 */
- (void)mapView:(MapxusMap *)mapView didChangeFloor:(nullable NSString *)floorName atBuilding:(MXMGeoBuilding *)building;

/**
 Enter/exit indoor scene callback, the same result may be called multiple times
 
 @param mapView Responding MapxusMap object.
 @param flag Enter/exit indoor scene sign，YES:enter；NO:exit
 @param buildingId Enter the building ID of the scene
 @param floor Enter the floor of the scene
 */
- (void)mapView:(MapxusMap *)mapView indoorMapWithIn:(BOOL)flag building:(NSString *)buildingId floor:(nullable NSString *)floor;

@end

NS_ASSUME_NONNULL_END




