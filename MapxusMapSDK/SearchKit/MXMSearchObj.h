//
//  MXMSearchObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Building search parameters

 There are four search modes.
 1. global search with the parameter combinations keywords(optional), offset, page.
 2. Specify a keyword search within a specified square area, with the parameters keywords(optional), bbox, offset, page.
 3. Specify a keyword search in a circular area with the combination of keywords(optional), center, distance, offset, page.
 4. Specify building ID search with the parameter buildingIds.
 */
@interface MXMBuildingSearchRequest : NSObject
/// Keyword. Currently only single keyword queries are supported
@property (nonatomic, strong, nullable) NSString *keywords;
/// Square search area
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. Unit is km, must be used with center
@property (nonatomic, assign) double distance;
/// The number of data to display per page
@property (nonatomic, assign) NSUInteger offset;
/// Page number
@property (nonatomic, assign) NSUInteger page;
/// List of building ids to query. Mutually exclusive with other parameters
@property (nonatomic, strong, nullable) NSArray<NSString *> *buildingIds;
@end




/**
 Building search results
 */
@interface MXMBuildingSearchResponse : NSObject
/// The total number of results
@property (nonatomic, assign) NSInteger total;
/// `MXMBuilding` list
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
@end




/**
 POI category search parameters
 
 Search for all POI categories in a given building and floor, floor can be left out, otherwise the whole building will be searched
 */
@interface MXMPOICategorySearchRequest : NSObject
/// Specify search building id
@property (nonatomic, strong, nullable) NSString *buildingId;
/// Specify search floor name
@property (nonatomic, strong, nullable) NSString *floor;
@end




/**
 POI category search results
 */
@interface MXMPOICategorySearchResponse : NSObject
/// `MXMCategory` list
@property (nonatomic, strong) NSArray<MXMCategory *> *category;
@end




/**
 POI search parameters
 
 There are five search modes.
 1. specify the keyword search within the building and floor, with the parameter combinations keywords(optional), buildingId, floor(optional), offset, page, category(optional).
 2. Specify the keyword search in the square area with the combination keywords(optional), bbox, offset, page, category(optional).
 3. Specify a keyword search within a circular region, sorted by two-dimensional spatial distance, with the parameter combinations keywords(optional), center, meterDistance(or distance), offset, page, category(optional).
 4. specify a keyword search within a circular area, sorted by route distance, with the parameter combinations keywords(optional), center, ordinal, buildingId, sort, meterDistance(or distance), offset, page, category(optional).
 5. specifying a buildingId search with the parameters POIIds.
 */
@interface MXMPOISearchRequest : NSObject
/// Keyword. Currently only single keyword queries are supported
@property (nonatomic, strong, nullable) NSString *keywords;
/// The id of building which you want to search in
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The name of floor which you want to search on
@property (nonatomic, strong, nullable) NSString *floor;
/// Square search area
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. Unit is km, must be used with center
@property (nonatomic, assign) double distance DEPRECATED_ATTRIBUTE;
/// Radius for searching circular areas. Unit is m, must be used with center
@property (nonatomic, assign) NSUInteger meterDistance;
/// The number of data to display per page
@property (nonatomic, assign) NSUInteger offset;
/// Page number
@property (nonatomic, assign) NSUInteger page;
/// Category to be filtered
@property (nonatomic, strong, nullable) NSString *category;
/// Sort by: AbsoluteDistance: Sort by 2D distance [default]; ActualDistance: Sort by route distance
@property (nonatomic, strong, nullable) NSString *sort;
/// Search for the actual building height of the location, take the level value of the CLFloor and pass in the value when the sort value is ActualDistance
@property (nonatomic, assign) NSInteger ordinal;
/// The list of POI ids to query. Mutually exclusive with the above parameters
@property (nonatomic, strong, nullable) NSArray<NSString *> *POIIds;
@end




/**
 POI search results
 */
@interface MXMPOISearchResponse : NSObject
/// The total number of results
@property (nonatomic, assign) NSInteger total;
/// `MXMPOI` list
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 Given the map deflection angle, search for nearby POI points and derive the orientation of the POI points with respect to the direction of the phone
 */
@interface MXMOrientationPOISearchRequest : NSObject
/// Clockwise angle from true north of the map to where the phone is pointing, takes values in the range [0,359]
@property (nonatomic, assign) NSUInteger angle;
/// Distance search type (default: Point). Point: finds POI points contained in a circle with center and distance as radius; polygon: finds POI information for rooms intersected by a circle with center and distance as radius
@property (nonatomic, strong, nullable) NSString *distanceSearchType;
/// The id of building which you want to search in
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The name of floor which you want to search on
@property (nonatomic, strong, nullable) NSString *floor;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. Unit is m
@property (nonatomic, assign) NSUInteger distance;
@end




/**
 POI search results by OrientationPOISearch
 */
@interface MXMOrientationPOISearchResponse : NSObject
/// `MXMPOI` list
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 Route search parameters
 */
@interface MXMRouteSearchRequest : NSObject
/// The id of building where the start point is located
@property (nonatomic, strong, nullable) NSString *fromBuilding;
/// The name of floor where the start point is located
@property (nonatomic, strong, nullable) NSString *fromFloor;
/// Starting longitude
@property (nonatomic, assign) double fromLon;
/// Starting latitude
@property (nonatomic, assign) double fromLat;
/// The name of floor where the end point is located
@property (nonatomic, strong, nullable) NSString *toBuilding;
/// The name of floor where the end point is located
@property (nonatomic, strong, nullable) NSString *toFloor;
/// Ending longitude
@property (nonatomic, assign) double toLon;
/// Ending latitude
@property (nonatomic, assign) double toLat;
/// Navigation method. Optional values are foot, wheelchair. foot by default
@property (nonatomic, strong, nullable) NSString *vehicle;
/// Returns the result language. Possible values are en, zh-Hans, zh-Hant, ja, ko. en by default
@property (nonatomic, strong, nullable) NSString *locale;
/// The end point is set in front of the door. Set to YES to terminate only at the POI shop door
@property (nonatomic, assign) BOOL toDoor;
@end




/**
 Route search results
 */
@interface MXMRouteSearchResponse : NSObject
/// WayPoint list which you pass from `MXMRouteSearchRequest`
@property (nonatomic, strong) NSArray<MXMIndoorPoint *> *wayPointList;
/// List for `MXMPath`, different routes for different planning options
@property (nonatomic, strong) NSArray<MXMPath *> *paths;
@end


NS_ASSUME_NONNULL_END
