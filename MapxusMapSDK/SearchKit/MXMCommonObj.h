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
#import <CoreLocation/CLLocation.h>
#import <MapxusMapSDK/MXMultilingualObject.h>


NS_ASSUME_NONNULL_BEGIN

/// `MXMCategory` is a class that encapsulates the details of a category.
@interface MXMCategory : NSObject
/// The key name of the category.
@property (nonatomic, strong) NSString *category;
/// The unique identifier of the category.
@property (nonatomic, strong) NSString *categoryId;
/// A description of the category. This property is optional and can be `nil`.
@property (nonatomic, strong, nullable) NSString *categoryDescription;
/// A map that contains the title of the category in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *titleMap;
/// English name for category
@property (nonatomic, strong, nullable) NSString *title_en DEPRECATED_MSG_ATTRIBUTE("Please use `titleMap.en` instead.");
/// Simplified Chinese name for category
@property (nonatomic, strong, nullable) NSString *title_cn DEPRECATED_MSG_ATTRIBUTE("Please use `titleMap.zh_Hans` instead.");
/// Traditional Chinese for category
@property (nonatomic, strong, nullable) NSString *title_zh DEPRECATED_MSG_ATTRIBUTE("Please use `titleMap.zh_Hant` instead.");
@end



/// `MXMGeoPoint` is a class that encapsulates the geographical coordinates on Earth.
@interface MXMGeoPoint : NSObject
/// The latitude of the geographical point.
@property (nonatomic, assign) double latitude;
/// The longitude of the geographical point.
@property (nonatomic, assign) double longitude;
/// The elevation of the geographical point.
@property (nonatomic, assign) double elevation;

/// A factory method that creates an `MXMGeoPoint` object with the specified latitude and longitude.
///
/// @param lat The latitude of the geographical point.
/// @param lng The longitude of the geographical point.
/// @return An `MXMGeoPoint` object with the specified latitude and longitude.
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng;

/// A factory method that creates an `MXMGeoPoint` object with the specified latitude, longitude, and elevation.
///
/// @param lat The latitude of the geographical point.
/// @param lng The longitude of the geographical point.
/// @param ele The elevation of the geographical point.
/// @return An `MXMGeoPoint` object with the specified latitude, longitude, and elevation.
+ (MXMGeoPoint *)locationWithLatitude:(double)lat longitude:(double)lng elevation:(double)ele;
@end



/// Represents an indoor point.
@interface MXMIndoorPoint : MXMGeoPoint
/// The ID of the building in which the point is located.
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The ID of the floor on which the point is located.
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId` instead.");

/// Factory method to create an MXMIndoorPoint instance.
///
/// @param lat The latitude.
/// @param lng The longitude.
/// @param buildingId The ID of the building where the point is located.
/// @param floorId The ID of the floor where the point is located.
/// @return An instance of MXMIndoorPoint.
+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                              buildingId:(nullable NSString *)buildingId
                                 floorId:(nullable NSString *)floorId;

+ (MXMIndoorPoint *)locationWithLatitude:(double)lat
                               longitude:(double)lng
                                building:(nullable NSString *)buildingId
                                   floor:(nullable NSString *)floor DEPRECATED_MSG_ATTRIBUTE("Please use `+ [MXMIndoorPoint locationWithLatitude:longitude:buildingId:floorId:]` instead.");

@end




///  Represents a rectangular area formed by the intersection of the lines of latitude and longitude of two points.
@interface MXMBoundingBox : NSObject <NSCopying>
/// The latitude of the lower left point.
@property (nonatomic, assign) double min_latitude;
/// The longitude of the lower left point.
@property (nonatomic, assign) double min_longitude;
/// The latitude of the top right point.
@property (nonatomic, assign) double max_latitude;
/// The longitude of the top right point.
@property (nonatomic, assign) double max_longitude;

/// Factory method to create an MXMBoundingBox instance with specified latitude and longitude values.
///
/// @param min_lat The latitude of the lower left point.
/// @param min_lng The longitude of the lower left point.
/// @param max_lat The latitude of the top right point.
/// @param max_lng The longitude of the top right point.
/// @return An instance of MXMBoundingBox.
+ (MXMBoundingBox *)boundingBoxWithMinLatitude:(double)min_lat
                                  minLongitude:(double)min_lng
                                   maxLatitude:(double)max_lat
                                  maxLongitude:(double)max_lng;

/// Factory method to create an MXMBoundingBox instance from an array of MXMGeoPoint instances.
///
/// @param points An array of MXMGeoPoint instances.
/// @return An instance of MXMBoundingBox or nil if the bounding box cannot be created.
+ (nullable MXMBoundingBox *)boundingBoxWithPoints:(NSArray<MXMGeoPoint *> *)points;

/// Checks if a given coordinate is contained within the bounding box.
///
/// @param coordinate The coordinate to check.
/// @param ignoreBoundary Whether to ignore the boundary of the bounding box.
/// @return YES if the coordinate is contained within the bounding box, NO otherwise.
- (BOOL)contains:(CLLocationCoordinate2D)coordinate ignoreBoundary:(BOOL)ignoreBoundary;

@end



/// Represents a building or venue address.
@interface MXMAddress : NSObject <NSCopying>
/// Represents the house number of the address.
@property (nonatomic, strong, nullable) NSString *housenumber;
/// Represents the street name of the address.
@property (nonatomic, strong, nullable) NSString *street;
@end



/// Represents a floor level model. This class ensures that the value of the level is obtained with the correct type.
@interface MXMOrdinal : NSObject <NSCopying>
/// Represents the level values which indicate logical levels above or below ground level. These values do not correspond to any numbering scheme in use by 
/// the building itself. The ground floor is always represented by the value 0. Floors above the ground floor are represented by positive integers, and floors below
/// the ground floor are represented by negative integers. It is erroneous to use the user’s level in a building as an estimate of altitude.
@property (nonatomic, assign) NSInteger level;
@end



/// Represents the details of a floor.
@interface MXMFloor : NSObject <NSCopying>
/// Represents the ID of the floor.
@property (nonatomic, strong) NSString *floorId;
/// Represents the name of the floor.
@property (nonatomic, strong) NSString *code;
/// Represents the level of the floor. If this is `nil`, it means no ordinal information is recorded.
@property (nonatomic, strong, nullable) MXMOrdinal *ordinal;
@end



/// Represents the details of a floor and the information associated with it.
@interface MXMFloorInfo: NSObject
/// Represents the details of the floor.
@property (nonatomic, strong) MXMFloor *floor;
/// Indicates whether the floor has visual map data.
@property (nonatomic, assign) BOOL hasVisualMap;
/// Indicates whether the floor has signal map data.
@property (nonatomic, assign) BOOL hasSignalMap;
@end



///  Represents building information.
@interface MXMBuilding : NSObject
/// A unique identifier for the building in the Mapxus system.
@property (nonatomic, strong) NSString *buildingId;
/// The ID of the venue where the building is located.
@property (nonatomic, strong) NSString *venueId;
/// The map of building names in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;
/// The building name without the venue name.
@property (nonatomic, strong) MXMultilingualObjectString *buildingNameMap;
/// The map of venue names in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *venueNameMap;
/// The map of building addresses in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectAddress *addressMap;
/// The default name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_default DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.Default` instead.");
/// The English name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_en DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.en` instead.");
/// The Simplified Chinese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_cn DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.zh_Hans` instead.");
/// The Traditional Chinese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_zh DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.zh_Hant` instead.");
/// The Japanese name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_ja DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.ja` instead.");
/// This property is The Korean name of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueName_ko DEPRECATED_MSG_ATTRIBUTE("Please use `venueNameMap.ko` instead.");
/// Building's name combined with the name of the venue in default language
@property (nonatomic, strong, nullable) NSString *name_default DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");
/// The name with building name and venue name in English
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");
/// Building name with venue name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");
/// Building name with venue name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");
/// Building name with venue name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");
/// Building name with venue name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ko` instead.");
/// Building address in default language
@property (nonatomic, strong, nullable) MXMAddress *address_default DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.Default` instead.");
/// Building address in English
@property (nonatomic, strong, nullable) MXMAddress *address_en DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.en` instead.");
/// Building address in Simplified Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_cn DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hans` instead.");
/// Building address in Traditional Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_zh DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hant` instead.");
/// Building address in Japanese
@property (nonatomic, strong, nullable) MXMAddress *address_ja DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ja` instead.");
/// Building address in Korean
@property (nonatomic, strong, nullable) MXMAddress *address_ko DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ko` instead.");
/// The category of the building, indicating its classification (e.g., residential, commercial, retail, industrial, transportation, etc.).
@property (nonatomic, strong, nullable) NSString *category;
@property (nonatomic, strong, nullable) NSString *type DEPRECATED_MSG_ATTRIBUTE("Please use `category` instead.");
/// The external rectangular area where the building is located.
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The longitude and latitude of the building name label.
@property (nonatomic, strong, nullable) MXMGeoPoint *labelCenter;
/// All floor information of the building.
@property (nonatomic, strong) NSArray<MXMFloorInfo *> *floors;
/// The default floor ID in this building, which can be used as the basis for selecting the floor by default when the building is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedFloorId;
@property (nonatomic, strong, nullable) NSString *groundFloor DEPRECATED_MSG_ATTRIBUTE("Will be removed");
/// The country where the building is located.
@property (nonatomic, strong, nullable) NSString *country;
/// The region where the building is located.
@property (nonatomic, strong, nullable) NSString *region;
/// The city where the building is located.
@property (nonatomic, strong, nullable) NSString *city;
/// Indicates whether the building has visual map data.
@property (nonatomic, assign) BOOL hasVisualMap;
/// Indicates whether the building has signal map data.
@property (nonatomic, assign) BOOL hasSignalMap;
@end



/// Represents venue information.
@interface MXMVenue : NSObject
/// A unique identifier for the venue in the Mapxus system.
@property (nonatomic, strong) NSString *venueId;
/// The map of venue names in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;
/// The map of venue addresses in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectAddress *addressMap;
/// Venue name in default language
@property (nonatomic, strong, nullable) NSString *name_default DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");
/// Venue name in English
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");
/// Venue name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");
/// Venue name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");
/// Venue name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");
/// Venue name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ko` instead.");
/// Venue address in default language
@property (nonatomic, strong, nullable) MXMAddress *address_default DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.Default` instead.");
/// Venue address in English
@property (nonatomic, strong, nullable) MXMAddress *address_en DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.en` instead.");
/// Venue address in Simplified Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_cn DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hans` instead.");
/// Venue address in Traditional Chinese
@property (nonatomic, strong, nullable) MXMAddress *address_zh DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hant` instead.");
/// Venue address in Japanese
@property (nonatomic, strong, nullable) MXMAddress *address_ja DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ja` instead.");
/// Venue address in Korean
@property (nonatomic, strong, nullable) MXMAddress *address_ko DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ko` instead.");
/// The category of the venue, indicating its classification (e.g., residential, commercial, retail, industrial, transportation, etc.).
@property (nonatomic, strong, nullable) NSString *category;
@property (nonatomic, strong, nullable) NSString *type DEPRECATED_MSG_ATTRIBUTE("Please use `category` instead.");
/// The external rectangular area where the venue is located.
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// The longitude and latitude of the venue name label.
@property (nonatomic, strong, nullable) MXMGeoPoint *labelCenter;
/// All building information of the venue.
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
/// The country where the venue is located.
@property (nonatomic, strong, nullable) NSString *country;
/// The region where the venue is located.
@property (nonatomic, strong, nullable) NSString *region;
/// The default building ID in this venue, which can be used as the basis for selecting the building by default when the venue is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedBuildingId;
/// Indicates whether the venue has visual map data.
@property (nonatomic, assign) BOOL hasVisualMap;
/// Indicates whether the venue has signal map data.
@property (nonatomic, assign) BOOL hasSignalMap;
@end



/// Represents Point of Interest (POI) information.
@interface MXMPOI : NSObject
/// A unique identifier for the POI in the Mapxus system.
@property (nonatomic, strong) NSString *poiId;
/// The ID of the building where the POI is located.
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The ID of the venue where the POI is located.
@property (nonatomic, strong, nullable) NSString *venueId;
/// The floor detail where the POI is located.
@property (nonatomic, strong, nullable) MXMFloor *floor;
/// Longitude and latitude of the POI.
@property (nonatomic, strong, nullable) MXMGeoPoint *location;
/// List of categories to which the POI belongs.
@property (nonatomic, strong) NSArray<NSString *> *category;
/// The description of the POI
@property (nonatomic, strong, nullable) NSString *introduction DEPRECATED_MSG_ATTRIBUTE("Please use `descriptionMap.Default` instead.");
/// The description of the POI in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *descriptionMap;
/// The name of the POI in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;
/// The accessibility detail of the POI in multiple languages.
@property (nonatomic, strong) MXMultilingualObjectString *accessibilityDetailMap;
/// POI name in default language
@property (nonatomic, strong, nullable) NSString *name_default DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");
/// POI name in English
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");
/// POI name in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");
/// POI name in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");
/// POI name in Japanese
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");
/// POI name in Korean
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ko` instead.");
/// Accessibility Information in default language
@property (nonatomic, strong, nullable) NSString *accessibilityDetail DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.Default` instead.");
/// Accessibility Information in English
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_en DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.en` instead.");
/// Accessibility Information in Simplified Chinese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_cn DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.zh_Hans` instead.");
/// Accessibility Information in Traditional Chinese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_zh DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.zh_Hant` instead.");
/// Accessibility Information in Japanese
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ja DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.ja` instead.");
/// Accessibility Information in Korean
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ko DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.ko` instead.");
/// Opening hours of the POI, using the openstreetmap opening_hours format.
@property (nonatomic, strong, nullable) NSString *openingHours;
/// The phone number of the POI.
@property (nonatomic, strong, nullable) NSString *phone;
/// The Email of the POI.
@property (nonatomic, strong, nullable) NSString *email;
/// The website of the POI.
@property (nonatomic, strong, nullable) NSString *website;
/// Distance from the request center, only valid for the center search.
@property (nonatomic, assign) double distance;
/// Clockwise angle of the phone pointing and the line connecting from the POI point to the center of the request.
@property (nonatomic, assign) NSUInteger angle;
@end



/// Represents key instruction for the route.
@interface MXMInstruction : NSObject
/// The ID of the venue where this instruction is located.
@property (nonatomic, strong, nullable) NSString *venueId;
/// The ID of the building where this instruction is located.
@property (nonatomic, strong, nullable) NSString *buildingId;
/// The ID of the floor where this instruction is located.
@property (nonatomic, strong, nullable) NSString *floorId;
@property (nonatomic, strong, nullable) NSString *floor DEPRECATED_MSG_ATTRIBUTE("Please use `floorId` instead.");
/// The ordinal of the floor where this instruction is located.
@property (nonatomic, strong, nullable) MXMOrdinal *ordinal;
/// Name of the road being taken.
@property (nonatomic, strong, nullable) NSString *streetName;
/// Distance of this instruction in metres (m).
@property (nonatomic, assign) double distance;
/// The direction, clockwise of the northward angle is given as between 0 and 360 degrees.
@property (nonatomic, assign) double heading;
/// Command symbols.
@property (nonatomic, assign) MXMRouteSign sign;
/// An array containing the first and last indexes (relative to path[n].points) of the points of this instruction. Indicates which part of the route the instruction matches.
@property (nonatomic, strong) NSArray<NSNumber *> *interval;
/// Describes what the user must do to follow the route. The language depends on the locale parameter.
@property (nonatomic, strong, nullable) NSString *text;
/// Duration of this instruction in ms.
@property (nonatomic, assign) NSUInteger time;
/// Connection type, only returned if sign is `MXMDownstairs` and `MXMUpstairs`, possible values are elevator_customer, elevator_good, escalator, ramp, stairs.
@property (nonatomic, strong, nullable) NSString *type;
@end



/// Represents the coordinates information of the route.
@interface MXMGeometry : NSObject
/// The types of route geometries.
@property (nonatomic, strong, nullable) NSString *type;
/// An array of coordinates for the route.
@property (nonatomic, strong) NSArray<MXMGeoPoint *> *coordinates;
@end



/// Represents the route information.
@interface MXMPath : NSObject
/// The total distance of the route in metres (m).
@property (nonatomic, assign) double distance;
/// The total time spent on the route in milliseconds (ms).
@property (nonatomic, assign) NSUInteger time;
/// The enclosing box for the route.
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;
/// Information on the coordinates of the route.
@property (nonatomic, strong, nullable) MXMGeometry *points;
/// The group of instruction information for the route.
@property (nonatomic, strong) NSArray<MXMInstruction *> *instructions;
@end

NS_ASSUME_NONNULL_END
