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

/// Represents the parameters for venue search.
///
/// There are four search modes:
/// 1. Global search with the parameter combinations keywords(optional), offset, page.
/// 2. Keyword search within a specified square area, with the parameters keywords(optional), bbox, offset, page.
/// 3. Keyword search in a circular area with the combination of keywords(optional), center, distance, offset, page.
/// 4. Building ID search with the parameter venueIds.
@interface MXMVenueSearchRequest : NSObject
/// Keyword for search. Currently, only single keyword queries are supported.
@property (nonatomic, strong, nullable) NSString *keywords;
/// Square search area.
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The center of the circular area for search.
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. The unit is km, must be used with center.
@property (nonatomic, assign) double distance;
/// The number of results displayed per page. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Page number, starting from 1.
@property (nonatomic, assign) NSUInteger page;
/// List of venue ids to query. The maximum number of venue IDs cannot exceed 10. This is mutually exclusive with other parameters.
@property (nonatomic, strong, nullable) NSArray<NSString *> *venueIds;
@end



/// Represents the results of a venue search.
@interface MXMVenueSearchResponse : NSObject
/// The total number of results.
@property (nonatomic, assign) NSInteger total;
/// A list of `MXMVenue` objects.
@property (nonatomic, strong) NSArray<MXMVenue *> *venues;
@end



/// Represents the parameters for building search.
///
/// There are four search modes:
/// 1. Global search with the parameter combinations keywords(optional), offset, page.
/// 2. Keyword search within a specified square area, with the parameters keywords(optional), bbox, offset, page.
/// 3. Keyword search in a circular area with the combination of keywords(optional), center, distance, offset, page.
/// 4. Building ID search with the parameter buildingIds.
@interface MXMBuildingSearchRequest : NSObject
/// Keyword for search. Currently, only single keyword queries are supported.
@property (nonatomic, strong, nullable) NSString *keywords;
/// Square search area.
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The center of the circular area for search.
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Radius for searching circular areas. The unit is km, must be used with center.
@property (nonatomic, assign) double distance;
/// The number of results displayed per page. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Page number, starting from 1.
@property (nonatomic, assign) NSUInteger page;
/// List of building ids to query. The maximum number of building IDs cannot exceed 10. This is mutually exclusive with other parameters.
@property (nonatomic, strong, nullable) NSArray<NSString *> *buildingIds;
@end



/// Represents the results of a building search.
@interface MXMBuildingSearchResponse : NSObject
/// The total number of results.
@property (nonatomic, assign) NSInteger total;
/// A list of `MXMBuilding` objects.
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
@end



/// Represents the parameters for a Point of Interest (POI) category search.
/// All categories within the specified site will be queried. The first non-null value will be requested, following the order of `floorId`, `buildingId`, and `venueId`.
DEPRECATED_MSG_ATTRIBUTE("Please use `MXMPoiCategoryFloorSearchOption`, `MXMPoiCategoryBuildingSearchOption` or `MXMPoiCategoryVenueSearchOption` instead.")
@interface MXMPOICategorySearchRequest : NSObject
/// Specifies the ID of the floor to search.
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId` instead.");
/// Specifies the ID of the building to search.
@property (nonatomic, strong, nullable) NSString *buildingId;
/// Specifies the ID of the venue to search.
@property (nonatomic, strong, nullable) NSString *venueId;
@end



/// Represents the results of a Point of Interest (POI) category search.
DEPRECATED_MSG_ATTRIBUTE("Please use `MXMPoiCategorySearchResult` instead.")
@interface MXMPOICategorySearchResponse : NSObject
/// A list of `MXMCategory` objects representing the search results.
@property (nonatomic, strong) NSArray<MXMCategory *> *category;
@end



/// Represents the parameters for a Point of Interest (POI) search.
///
/// There are seven search modes:
/// 1. Specify the search within the floor using a combination of parameters. These parameters include `floorId`, `offset`, `page`, `keywords` (optional),
/// `orderBy` (optional), `category` (optional), and `excludeCategories` (optional).
/// Please note that `keywords` and `orderBy` are mutually exclusive. If both are provided, the system will prioritize `keywords` over `orderBy` and take the
/// first non-nil value.
/// Similarly, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over `excludeCategories`
/// and take the first non-nil value.
///
/// 2. Specify the search within the building using a combination of parameters. These parameters include `buildingId`, `offset`, `page`, `keywords` (optional),
/// `orderBy` (optional), `category` (optional), and `excludeCategories` (optional).
/// Please note that `keywords` and `orderBy` are mutually exclusive. If both are provided, the system will prioritize `keywords` over `orderBy` and take the
/// first non-nil value.
/// Similarly, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over `excludeCategories`
/// and take the first non-nil value.
///
/// 3. Specify the search within the venue using a combination of parameters. These parameters include `venueId`, `offset`, `page`, `keywords` (optional),
/// `orderBy` (optional), `category` (optional), and `excludeCategories` (optional).
/// Please note that `keywords` and `orderBy` are mutually exclusive. If both are provided, the system will prioritize `keywords` over `orderBy` and take the
/// first non-nil value.
/// Similarly, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over `excludeCategories`
/// and take the first non-nil value.
///
/// 4. Specify the search within the square area using a combination of parameters. These parameters include `bbox`, `offset`, `page`, `floorId` (optional),
/// `buildingId` (optional), `venueId` (optional), `keywords` (optional), `orderBy` (optional), `category` (optional), and `excludeCategories` (optional).
/// Please note that `floorId`, `buildingId`, and `venueId` are mutually exclusive. If all three are provided, the system will prioritize them in the order of
/// `floorId` -> `buildingId` -> `venueId` and take the first non-nil value.
/// In the same vein, `keywords` and `orderBy` are mutually exclusive. If both are provided, the system will prioritize `keywords` over `orderBy` and take the
/// first non-nil value.
/// Likewise, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over `excludeCategories`
/// and take the first non-nil value.
///
/// 5. Specify the search within a circular area, sorted by two-dimensional spatial distance. This search uses a combination of parameters including `center`,
/// `meterDistance`, `offset`, `page`, `keywords` (optional), `sort` (use `AbsoluteDistance`), `floorId` (optional), `buildingId` (optional),
/// `venueId` (optional), `category` (optional), and `excludeCategories` (optional).
/// Please note that `floorId`, `buildingId`, and `venueId` are mutually exclusive. If all three are provided, the system will prioritize them in the order of
/// `floorId` -> `buildingId` -> `venueId` and take the first non-nil value.
/// Similarly, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over `excludeCategories`
/// and take the first non-nil value.
///
/// 6. Specify the search within a circular area, sorted by route distance. This search uses a combination of parameters: `center`, `ordinal`, `meterDistance`,
/// `offset`, `page`, `keywords` (optional), `sort` (use `ActualDistance`),  `floorId` (optional), `buildingId` (optional), `venueId` (optional),
/// `category` (optional), and `excludeCategories` (optional).
/// Please note that `floorId`, `buildingId`, and `venueId` are mutually exclusive. If all three are provided, the system will prioritize them in the order of
/// `floorId` -> `buildingId` -> `venueId` and take the first non-nil value.
/// Similarly, `category` and `excludeCategories` are mutually exclusive. If both are provided, the system will prioritize `category` over
/// `excludeCategories` and take the first non-nil value.
///
/// 7. Specify the POIId search with the parameters POIIds.
@interface MXMPOISearchRequest : NSObject
/// Keyword for the search. Currently, only single keyword queries are supported.
@property (nonatomic, copy, nullable) NSString *keywords;
/// Specifies the ID of the floor to search in.
@property (nonatomic, copy, nullable) NSString *floorId;
@property (nonatomic, copy, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId` instead.");
/// Specifies the ID of the building to search in.
@property (nonatomic, copy, nullable) NSString *buildingId;
/// Specifies the ID of the venue to search in.
@property (nonatomic, copy, nullable) NSString *venueId;
/// Specifies a rectangular search range using latitude and longitude. The maximum rectangular search area cannot exceed 400 km².
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// Specifies the center of a circular area search.
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// Specifies the actual building height of the location. Pass in the level value of the CLFloor when the sort value is ActualDistance.
@property (nonatomic, assign) NSInteger ordinal;
/// Specifies the radius distance in meters for the POI search. The maximum radius distance cannot exceed 10000m.
@property (nonatomic, assign) NSUInteger meterDistance;
/// Specifies the number of results displayed per page. The default value is 10, and the maximum number cannot exceed 100.
@property (nonatomic, assign) NSUInteger offset;
/// Specifies the page number, starting from 1.
@property (nonatomic, assign) NSUInteger page;
/// Specifies the category to be filtered.
@property (nonatomic, strong, nullable) NSString *category;
/// Specifies a list of POI categories to be excluded. Note that this parameter is mutually exclusive with the parameter `category`.
@property (nonatomic, strong, nullable) NSArray<NSString *> *excludeCategories;
/// Specifies the alignment of search results. AbsoluteDistance is the default value. Options include: AbsoluteDistance (sort by 2D distance) and ActualDistance (sort by route distance).
@property (nonatomic, strong, nullable) NSString *sort;
/// Specifies the sorting mode of returned results. Options include: DefaultName (sort by defaultName of the POI in ascending order).
/// Note that this parameter is mutually exclusive with the parameter `keywords`.
@property (nonatomic, strong, nullable) NSString *orderBy;
/// Specifies a list of POI ids to query. The maximum ID number of buildings cannot exceed 10. This parameter is mutually exclusive with the above parameters.
@property (nonatomic, strong, nullable) NSArray<NSString *> *POIIds;
@end



/// Represents the results of a Point of Interest (POI) search.
@interface MXMPOISearchResponse : NSObject
/// Specifies the total number of results.
@property (nonatomic, assign) NSInteger total;
/// Specifies a list of `MXMPOI` objects representing the search results.
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end



/// This interface is provided to allow developers to conveniently query Points of Interest (POIs) near a location and their orientation relative to the user.
/// The parameters `angle`, `distanceSearchType`, `center`, and `distance` are required. One of the following must also be provided: `floorId`,
/// `buildingId`, or `floorOrdinal`.
///
/// * If floorId is provided, POIs will only be searched for on the specified floor.
/// * If buildingId is provided, POIs will be searched for in all floors of the specified building.
/// * If floorOrdinal is provided, the venue will be determined using center and floorOrdinal, and POIs will be searched for in all buildings of the venue on floors with the same ordinal.
///
/// Please note that distance refers to the two-dimensional straight-line distance on the map during the search process.
@interface MXMOrientationPOISearchRequest : NSObject
/// Clockwise angle from true north of the map to where the phone is pointing, takes values in the range [0,359].
@property (nonatomic, assign) NSUInteger angle;
/// Distance search type (default: Point). Options include: Point (finds POI points contained in a circle with `center` and `distance` as radius),
/// Polygon (finds POI information for rooms intersected by a circle with `center` and `distance` as radius),
/// and Gate (locates POIs whose entrances are situated within the specified search radius).
@property (nonatomic, strong, nullable) NSString *distanceSearchType;
/// The ID of the floor which you want to search in. If it is not nil, the `buildingId` will be disregarded.
@property (nonatomic, copy, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId` instead.");
/// The ID of the building which you want to search in.
@property (nonatomic, strong, nullable) NSString *buildingId;
/// Search for the actual building height of the location, take the level value of the CLFloor.
@property (nonatomic, strong, nullable) NSNumber *floorOrdinal;
/// The center of the circular area search, just use latitude and longitude.
@property (nonatomic, strong, nullable) MXMGeoPoint *center;
/// This parameter is used in the POI orientation search and represents the radius distance in meters. The maximum radius distance cannot exceed 100m.
@property (nonatomic, assign) NSUInteger distance;
@end



/// Represents the results of a Point of Interest (POI) search by OrientationPOISearch.
@interface MXMOrientationPOISearchResponse : NSObject
/// A list of `MXMPOI` objects representing the search results.
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/// This interface provides a route search functionality that supports multi-point navigation, accepting anywhere from 2 to 5 points. Indoor points should be defined
/// using latitude, longitude, floorId, and buildingId. Conversely, outdoor points should be specified using only latitude and longitude.
@interface MXMRouteSearchRequest : NSObject
/// The id of building where the start point is located
@property (nonatomic, strong, nullable) NSString *fromBuildingId DEPRECATED_MSG_ATTRIBUTE("`fromBuildingId` is deprecated");
@property (nonatomic, strong, nullable) NSString *fromBuilding DEPRECATED_MSG_ATTRIBUTE("Please use `fromBuildingId`");
/// The id of floor where the start point is located
@property (nonatomic, strong, nullable) NSString *fromFloorId DEPRECATED_MSG_ATTRIBUTE("`fromFloorId` is deprecated");
@property (nonatomic, strong, nullable) NSString *fromFloor DEPRECATED_MSG_ATTRIBUTE("Please use `fromFloorId`");
/// Starting longitude
@property (nonatomic, assign) double fromLon DEPRECATED_MSG_ATTRIBUTE("`fromLon` is deprecated");
/// Starting latitude
@property (nonatomic, assign) double fromLat DEPRECATED_MSG_ATTRIBUTE("`fromLat` is deprecated");
/// The id of building where the end point is located
@property (nonatomic, strong, nullable) NSString *toBuildingId DEPRECATED_MSG_ATTRIBUTE("`toBuildingId` is deprecated");
@property (nonatomic, strong, nullable) NSString *toBuilding DEPRECATED_MSG_ATTRIBUTE("Please use `toBuildingId`");
/// The id of floor where the end point is located
@property (nonatomic, strong, nullable) NSString *toFloorId DEPRECATED_MSG_ATTRIBUTE("`toFloorId` is deprecated");
@property (nonatomic, strong, nullable) NSString *toFloor DEPRECATED_MSG_ATTRIBUTE("Please use `toFloorId`");
/// Ending longitude
@property (nonatomic, assign) double toLon DEPRECATED_MSG_ATTRIBUTE("`toLon` is deprecated");
/// Ending latitude
@property (nonatomic, assign) double toLat DEPRECATED_MSG_ATTRIBUTE("`toLat` is deprecated");
/// Accepts a minimum of 2 points and a maximum of 5 points. `MXMIndoorPoint` instances are created using only latitude, longitude, buildingId, and floorId.
@property (nonatomic, copy, nullable) NSArray<MXMIndoorPoint *> *points;
/// Navigation method. Optional values are foot, wheelchair, escalator, emergency. The default is foot.
@property (nonatomic, strong, nullable) NSString *vehicle;
/// Returns the result language. Possible values are en, zh-Hans, zh-Hant, ja, ko. The default is en.
@property (nonatomic, strong, nullable) NSString *locale;
/// The end point is set in front of the door. Set to YES to terminate only at the POI shop door
@property (nonatomic, assign) BOOL toDoor DEPRECATED_MSG_ATTRIBUTE("`toDoor` is deprecated");
@end



/// Represents the results of a route search.
@interface MXMRouteSearchResponse : NSObject
/// A list of `MXMIndoorPoint` objects representing the waypoints passed from `MXMRouteSearchRequest`.
@property (nonatomic, strong) NSArray<MXMIndoorPoint *> *wayPointList;
/// A list of `MXMPath` objects, representing different routes for different planning options.
@property (nonatomic, strong) NSArray<MXMPath *> *paths;
@end


NS_ASSUME_NONNULL_END
