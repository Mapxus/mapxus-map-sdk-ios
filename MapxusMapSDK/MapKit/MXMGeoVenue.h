//
//  MXMGeoVenue.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2022/12/14.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// This class represents venue information read from tiles.
@interface MXMGeoVenue : NSObject <NSCopying>


/// A unique identifier for the venue in the Mapxus system.
@property (nonatomic, strong) NSString *identifier;


/// The category of the venue, indicating the type of the building (e.g., residential, commercial, retail, industrial, transportation, etc.).
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *venueType DEPRECATED_MSG_ATTRIBUTE("Please use `category` instead.");


/// The name of the venue.
///
/// @discussion
/// This is an `MXMultilingualObject` that stores a multilingual mapping of `NSString` type.
/// This mapping allows us to retrieve the corresponding string value based on different language environments.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;


/// The address of the venue.
///
/// @discussion
/// This is an `MXMultilingualObject` that stores a multilingual mapping of `MXMAddress` type.
/// This mapping allows us to retrieve the corresponding address value based on different language environments.
@property (nonatomic, strong) MXMultilingualObjectAddress *addressMap;


/// Venue name in default language.
@property (nonatomic, strong, nullable) NSString *name DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");


/// Venue name in English.
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");


/// Venue name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");


/// Venue name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");


/// Venue name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");


/// Venue name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ko` instead.");


/// Venue address in default language.
@property (nonatomic, strong, nullable) MXMAddress *address DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.Default` instead.");


/// Venue address in English.
@property (nonatomic, strong, nullable) MXMAddress *address_en DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.en` instead.");


/// Venue address in Simplified Chinese.
@property (nonatomic, strong, nullable) MXMAddress *address_cn DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hans` instead.");


/// Venue address in Traditional Chinese.
@property (nonatomic, strong, nullable) MXMAddress *address_zh DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.zh_Hant` instead.");


/// Venue address in Japanese.
@property (nonatomic, strong, nullable) MXMAddress *address_ja DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ja` instead.");


/// Venue address in Korean.
@property (nonatomic, strong, nullable) MXMAddress *address_ko DEPRECATED_MSG_ATTRIBUTE("Please use `addressMap.ko` instead.");

@property (nonatomic, strong, nullable) MXMBoundingBox *bbox DEPRECATED_MSG_ATTRIBUTE("Incomplete figures will be removed.");


/// A list of all building IDs associated with this venue.
@property (nonatomic, strong) NSArray<NSString *> *buildingIds;


/// The default building ID in this venue, which can be used as the basis for selecting a building by default when a venue is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedBuildingId;

@end

NS_ASSUME_NONNULL_END
