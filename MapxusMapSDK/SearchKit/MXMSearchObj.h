//
//  MXMSearchObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Venue search parameters

 There are four search modes.
 1. global search with the parameter combinations keywords(optional), offset, page.
 2. Specify a keyword search within a specified square area, with the parameters keywords(optional), bbox, offset, page.
 3. Specify a keyword search in a circular area with the combination of keywords(optional), center, distance, offset, page.
 4. Specify building ID search with the parameter venueIds.
 */
@interface MXMVenueSearchRequest : NSObject
/// Keyword. Currently only single keyword queries are supported
@property (nonatomic, strong, nullable) NSString *keywords;
/// Square search area
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. Unit is km, must be used with center
@property (nonatomic, assign) double distance;
/// The number displayed per page in the results. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Page number, start from 1
@property (nonatomic, assign) NSUInteger page;
/// List of venue ids to query, the maximum ID number of venues can not exceed 10. Mutually exclusive with other parameters
@property (nonatomic, strong, nullable) NSArray<NSString *> *venueIds;
@end




/**
 Venue search results.
 */
@interface MXMVenueSearchResponse : NSObject
/// The total number of results.
@property (nonatomic, assign) NSInteger total;
/// `MXMVenue` list.
@property (nonatomic, strong) NSArray<MXMVenue *> *venues;
@end




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
/// The number displayed per page in the results. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Page number, start from 1
@property (nonatomic, assign) NSUInteger page;
/// List of building ids to query, the maximum ID number of buildings can not exceed 10. Mutually exclusive with other parameters
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
 
 If a floorId is provided, the buildingId will be disregarded, and all categories associated with that floor will be queried. Conversely, if a buildingId is provided, all
 categories within that building will be queried.
 */
@interface MXMPOICategorySearchRequest : NSObject
/// Specify search floor ID
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");
/// Specify search building ID
@property (nonatomic, strong, nullable) NSString *buildingId;
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
 1. specify the keyword search within the floor, with the parameter combinations keywords(optional), floorId, offset, page, category(optional).
 2. specify the keyword search within the building, with the parameter combinations keywords(optional), buildingId, offset, page, category(optional).
 3. Specify the keyword search in the square area with the combination keywords(optional), bbox, offset, page, category(optional).
 4. Specify a keyword search within a circular region, sorted by two-dimensional spatial distance, with the parameter combinations keywords(optional), center, meterDistance(or distance), offset, page, category(optional).
 5. specify a keyword search within a circular area, sorted by route distance, with the parameter combinations keywords(optional), center, ordinal, buildingId, sort, meterDistance(or distance), offset, page, category(optional).
 6. specifying a buildingId search with the parameters POIIds.
 */
@interface MXMPOISearchRequest : NSObject
/// Keyword. Currently only single keyword queries are supported
@property (nonatomic, copy, nullable) NSString *keywords;
/// The ID of floor which you want to search in
@property (nonatomic, copy, nullable) NSString *floorId;
@property (nonatomic, copy, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");
/// The ID of building which you want to search in
@property (nonatomic, copy, nullable) NSString *buildingId;
/// Enter latitude and longitude to form a rectangular search range. The maximum rectangular search area cannot exceed  400 km².
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// This parameter is used in the POI  search and represents the radius distance in meters. The maximum radius distance cannot exceed 10000m.
@property (nonatomic, assign) NSUInteger meterDistance;
/// The number displayed per page in the results. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Page number, start from 1
@property (nonatomic, assign) NSUInteger page;
/// Category to be filtered
@property (nonatomic, strong, nullable) NSString *category;
/// Sort by: AbsoluteDistance: Sort by 2D distance [default]; ActualDistance: Sort by route distance
@property (nonatomic, strong, nullable) NSString *sort;
/// Search for the actual building height of the location, take the level value of the CLFloor and pass in the value when the sort value is ActualDistance
@property (nonatomic, assign) NSInteger ordinal;
/// The list of POI ids to query, the maximum ID number of buildings can not exceed 10. Mutually exclusive with the above parameters
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
/// The ID of floor which you want to search in, if it is not nil, the buildingId will be disregarded.
@property (nonatomic, copy, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");
/// The ID of building which you want to search in
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The centre of circular area search
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// This parameter is used in the POI orientation search and represents the radius distance in meters. The maximum radius distance cannot exceed 100m.
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
@property (nonatomic, strong, nullable) NSString *fromBuildingId;
@property (nonatomic, strong, nullable) NSString *fromBuilding DEPRECATED_MSG_ATTRIBUTE("Please use `fromBuildingId`");
/// The id of floor where the start point is located
@property (nonatomic, strong, nullable) NSString *fromFloorId;
@property (nonatomic, strong, nullable) NSString *fromFloor DEPRECATED_MSG_ATTRIBUTE("Please use `fromFloorId`");
/// Starting longitude
@property (nonatomic, assign) double fromLon;
/// Starting latitude
@property (nonatomic, assign) double fromLat;
/// The id of building where the end point is located
@property (nonatomic, strong, nullable) NSString *toBuildingId;
@property (nonatomic, strong, nullable) NSString *toBuilding DEPRECATED_MSG_ATTRIBUTE("Please use `toBuildingId`");
/// The id of floor where the end point is located
@property (nonatomic, strong, nullable) NSString *toFloorId;
@property (nonatomic, strong, nullable) NSString *toFloor DEPRECATED_MSG_ATTRIBUTE("Please use `toFloorId`");
/// Ending longitude
@property (nonatomic, assign) double toLon;
/// Ending latitude
@property (nonatomic, assign) double toLat;
/// Navigation method. Optional values are foot, wheelchair, escalator. foot by default
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
