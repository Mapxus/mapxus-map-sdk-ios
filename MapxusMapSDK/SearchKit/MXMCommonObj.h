//
//  MXMCommonObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <MapxusMapSDK/MXMDefine.h>


NS_ASSUME_NONNULL_BEGIN

/**
 Category details
 */
@interface MXMCategory : NSObject
/// Category key name
@property (nonatomic, strong) NSString *category;
/// Category id
@property (nonatomic, strong) NSString *categoryId;
/// Description of the category
@property (nonatomic, strong, nullable) NSString *categoryDescription;
/// English name for category
@property (nonatomic, strong, nullable) NSString *title_en;
/// Simplified Chinese name for category
@property (nonatomic, strong, nullable) NSString *title_cn;
/// Traditional Chinese for category
@property (nonatomic, strong, nullable) NSString *title_zh;
@end




/**
 Earth's latitude and longitude coordinates
 */
@interface MXMGeoPoint : NSObject
/// Latitude (vertical)
@property (nonatomic, assign) double latitude;
/// Longitude (horizontal)
@property (nonatomic, assign) double longitude;
/// Elevation (vertical)
@property (nonatomic, assign) double elevation;
/**
 MXMGeoPoint factory methods
 @param lat Latitude (vertical)
 @param lng Longitude (horizontal)
 @return MXMGeoPoint object
 */
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng;
/**
 MXMGeoPoint factory method
 @param lat Latitude (vertical)
 @param lng Longitude (horizontal)
 @param ele Elevation (vertical)
 @return MXMGeoPoint object
 */
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng elevation:(double)ele;
@end




/**
 Indoor point
 */
@interface MXMIndoorPoint : MXMGeoPoint
/// The id of building in which it is located
@property (nonatomic, strong, nullable) NSString *buildingId;

/// The id of floor on which it is located
@property (nonatomic, strong, nullable) NSString *floorId;

@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");

/**
 MXMIndoorPoint factory method
 @param lat Latitude (vertical)
 @param lng Longitude (horizontal)
 @param buildingId The id of building in which it is located
 @param floorId The id of floor on which it is located
 @return MXMIndoorPoint object
 */
+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                              buildingId:(nullable NSString *)buildingId
                                 floorId:(nullable NSString *)floorId;

+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                                building:(nullable NSString *)buildingId
                                   floor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("Please use `+ [MXMIndoorPoint locationWithLatitude:longitude:buildingId:floorId:]`");

@end




/**
 Rectangular area formed by the intersection of the lines of latitude and longitude of two points
 */
@interface MXMBoundingBox : NSObject <NSCopying>
/// Lower left latitude
@property (nonatomic, assign) double min_latitude;
/// Lower left Longitude
@property (nonatomic, assign) double min_longitude;
/// Top right latitude
@property (nonatomic, assign) double max_latitude;
/// Top right Longitude
@property (nonatomic, assign) double max_longitude;
/**
 MXMBoundingBox factory method
 @param min_lat Lower left latitude
 @param min_lng Lower left Longitude
 @param max_lat Top right latitude
 @param max_lng Top right Longitude
 @return MXMBoundingBox object
 */
+ (MXMBoundingBox *)boundingBoxWithMinLatitude:(double)min_lat
                                  minLongitude:(double)min_lng
                                   maxLatitude:(double)max_lat
                                  maxLongitude:(double)max_lng;
@end




/**
 Building address
 */
@interface MXMAddress : NSObject <NSCopying>
/// House number
@property (nonatomic, strong, nullable) NSString *housenumber;
/// Street name
@property (nonatomic, strong, nullable) NSString *street;
@end



/**
 Floor level model, use this class to ensure that the value of level is obtained with the correct type
 */
@interface MXMOrdinal : NSObject <NSCopying>
/// Level values represent logical levels above or below ground level and are not intended to correspond to any numbering scheme in use by the building itself.
/// The ground floor of a building is always represented by the value 0. Floors above the ground floor are represented by positive integers, so a value of 1
/// represents the floor above ground level, a value of 2 represents two floors above ground level, and so on. Floors below the ground floor are represented by
/// corresponding negative integers, with a value of -1 representing the floor immediately below ground level and so on. It is erroneous to use the user’s level in
/// a building as an estimate of altitude.
@property (nonatomic, assign) NSInteger level;
@end



/**
 Floor detail
 */
@interface MXMFloor : NSObject <NSCopying>
/// Floor id
@property (nonatomic, strong) NSString *floorId;
/// Floor name
@property (nonatomic, strong) NSString *code;
/// Floor level, `nil` means no ordinal information is recorded
@property (nonatomic, strong, nullable) MXMOrdinal *ordinal;
@end



/**
 Floor detail and the information associated with it
 */
@interface MXMFloorInfo: NSObject
/// Floor detail
@property (nonatomic, strong) MXMFloor *floor;
/// Whether the floor have visual map data
@property (nonatomic, assign) BOOL hasVisualMap;
/// Whether the floor have signal map data
@property (nonatomic, assign) BOOL hasSignalMap;
@end



/**
 Building information
 */
@interface MXMBuilding : NSObject
/// A string that uniquely identifies the building in the mapxus system.
@property (nonatomic, strong) NSString *buildingId;
/// The id of venue where the building is located
@property (nonatomic, strong) NSString *venueId;
/// The default name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_default;
/// The English name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_en;
/// The Simplified Chinese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_cn;
/// The Traditional Chinese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_zh;
/// The Japanese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_ja;
/// The Korean name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_ko;
/// Building name in default language
@property (nonatomic, strong, nullable) NSString *name_default;
/// Building name in English
@property (nonatomic, strong, nullable) NSString *name_en;
/// Building name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn;
/// Building name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh;
/// Building name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja;
/// Building name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko;
/// Building address in default language
@property (nonatomic, strong, nullable) MXMAddress *address_default;
/// Building address in English
@property (nonatomic, strong, nullable) MXMAddress *address_en;
/// Building address in Simplified Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_cn;
/// Building address in Traditional Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_zh;
/// Building address in Japanese
@property (nonatomic, strong, nullable) MXMAddress *address_ja;
/// Building address in Korean
@property (nonatomic, strong, nullable) MXMAddress *address_ko;
/// Building type, indicating the classification of the building, e.g. residential, commercial, retail, industrial, transportation, etc.
@property (nonatomic, strong, nullable) NSString *type;
/// External rectangular area where the building is located
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The Longitude and Latitude of the building name label
@property (nonatomic, strong, nullable) MXMGeoPoint *labelCenter;
/// All floors information of the building
@property (nonatomic, strong) NSArray<MXMFloorInfo *> *floors;
/// The default floor id in this building, which can be used as the basis for selecting floor by default when building is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedFloorId;
@property (nonatomic, strong, nullable) NSString *groundFloor DEPRECATED_MSG_ATTRIBUTE("Will be removed");
/// The contry where the building is located
@property (nonatomic, strong, nullable) NSString *country;
/// The region where the building is located
@property (nonatomic, strong, nullable) NSString *region;
/// The city where the building is located
@property (nonatomic, strong, nullable) NSString *city;
/// Whether the building have visual map data
@property (nonatomic, assign) BOOL hasVisualMap;
/// Whether the building have signal map data
@property (nonatomic, assign) BOOL hasSignalMap;
@end



/**
 Venue information
 */
@interface MXMVenue : NSObject
/// A string that uniquely identifies the venue in the mapxus system.
@property (nonatomic, strong) NSString *venueId;
/// Venue name in default language
@property (nonatomic, strong, nullable) NSString *name_default;
/// Venue name in English
@property (nonatomic, strong, nullable) NSString *name_en;
/// Venue name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn;
/// Venue name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh;
/// Venue name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja;
/// Venue name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko;
/// Venue address in default language
@property (nonatomic, strong, nullable) MXMAddress *address_default;
/// Venue address in English
@property (nonatomic, strong, nullable) MXMAddress *address_en;
/// Venue address in Simplified Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_cn;
/// Venue address in Traditional Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_zh;
/// Venue address in Japanese
@property (nonatomic, strong, nullable) MXMAddress *address_ja;
/// Venue address in Korean
@property (nonatomic, strong, nullable) MXMAddress *address_ko;
/// Venue type, indicating the classification of the venue, e.g. residential, commercial, retail, industrial, transportation, etc.
@property (nonatomic, strong, nullable) NSString *type;
/// External rectangular area where the venue is located
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The Longitude and Latitude of the venue name label
@property (nonatomic, strong, nullable) MXMGeoPoint *labelCenter;
/// All buildings information of the venue
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
/// The contry where the venue is located
@property (nonatomic, strong, nullable) NSString *country;
/// The region where the venue is located
@property (nonatomic, strong, nullable) NSString *region;
/// The default building id in this venue, which can be used as the basis for selecting building by default when venue is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedBuildingId;
/// Whether the venue have visual map data
@property (nonatomic, assign) BOOL hasVisualMap;
/// Whether the venue have signal map data
@property (nonatomic, assign) BOOL hasSignalMap;
@end



/**
 POI information
 */
@interface MXMPOI : NSObject
/// A string that uniquely identifies the POI in the mapxus system.
@property (nonatomic, strong) NSString *poiId;
/// The id of building where the POI is located
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The id of venue where the POI is located
@property (nonatomic, strong, nullable) NSString *venueId;
/// The floor detail where the POI is located
@property (nonatomic, strong, nullable) MXMFloor *floor;
/// Longitude and latitude of POI
@property (nonatomic, strong, nullable) MXMGeoPoint *location;
/// List of categories to which POI belongs
@property (nonatomic, strong) NSArray<NSString *> *category;
/// Description of POI
@property (nonatomic, strong, nullable) NSString *introduction;
/// The Email of POI
@property (nonatomic, strong, nullable) NSString *email;
/// POI name in default language
@property (nonatomic, strong, nullable) NSString *name_default;
/// POI name in English
@property (nonatomic, strong, nullable) NSString *name_en;
/// POI name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn;
/// POI name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh;
/// POI name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja;
/// POI name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko;
/// Accessibility Information in default language
@property (nonatomic, strong, nullable) NSString *accessibilityDetail;
/// Accessibility Information in English
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_en;
/// Accessibility Information in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_cn;
/// Accessibility Information in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_zh;
/// Accessibility Information in Japanese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ja;
/// Accessibility Information in Korean
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ko;
/// Opening hours
@property (nonatomic, strong, nullable) NSString *openingHours;
/// The phone number of the shop
@property (nonatomic, strong, nullable) NSString *phone;
/// The website of the shop
@property (nonatomic, strong, nullable) NSString *website;
/// Distance from the request centre, only valid for the centre search
@property (nonatomic, assign) double distance;
/// Clockwise angle of the phone pointing and the line connecting from the POI point to the centre of the request
@property (nonatomic, assign) NSUInteger angle;
@end




/**
 Key instruction for the route
 */
@interface MXMInstruction : NSObject
/// The id of the venue in which this instruction is located
@property (nonatomic, strong, nullable) NSString *venueId;
/// The id of the building in which this instruction is located
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The id of the floor in which this instruction is located
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId`");
/// The ordinal of the floor in which this instruction is located
@property (nonatomic, strong, nullable) MXMOrdinal *ordinal;
/// Name of the road being taken
@property (nonatomic, strong, nullable) NSString *streetName;
/// Distance of this instruction in metres (m)
@property (nonatomic, assign) double distance;
/// The direction, clockwise of the northward angle is given as between 0 and 360 degrees
@property (nonatomic, assign) double heading;
/// Command symbols
@property (nonatomic, assign) MXMRouteSign sign;
/// An array containing the first and last indexes (relative to path[n].points) of the points of this instruction. Indicates which part of the route the instruction matches
@property (nonatomic, strong) NSArray<NSNumber *> *interval;
/// Describes what the user must do to follow the route. The language depends on the locale parameter.
@property (nonatomic, strong, nullable) NSString *text;
/// Duration of this instruction in ms
@property (nonatomic, assign) NSUInteger time;
/// Connection type, only returned if sign is `MXMDownstairs` and `MXMUpstairs`, possible values are elevator_customer, elevator_good, escalator, ramp, stairs
@property (nonatomic, strong, nullable) NSString *type;
@end




/**
 The coordinates information of the route
 */
@interface MXMGeometry : NSObject
/// Types of route geometries
@property (nonatomic, strong, nullable) NSString *type;
/// An array of coordinates for the route
@property (nonatomic, strong) NSArray<MXMGeoPoint *> *coordinates;
@end




/**
 Route information
 */
@interface MXMPath : NSObject
/// Total distance of the route in metres (m)
@property (nonatomic, assign) double distance;
/// Total time spent on the route in milliseconds (ms)
@property (nonatomic, assign) NSUInteger time;
/// The enclosing box for the route
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// Information on the coordinates of the route
@property (nonatomic, strong, nullable) MXMGeometry *points;
/// The instruction information group for the route
@property (nonatomic, strong) NSArray<MXMInstruction *> *instructions;
@end

NS_ASSUME_NONNULL_END
