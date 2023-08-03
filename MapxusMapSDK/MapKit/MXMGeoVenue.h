//
//  MXMGeoVenue.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2022/12/14.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Venue information in tiles
 */
@interface MXMGeoVenue : NSObject <NSCopying>

/// A string that uniquely identifies the venue in the mapxus system.
@property (nonatomic, strong) NSString *identifier;

/// Venue type, indicating the classification of the venue, e.g. cathedral, car_park, hospital, office, retail, etc.
@property (nonatomic, strong) NSString *venueType;

/// Venue name in default language.
@property (nonatomic, strong, nullable) NSString *name;

/// Venue name in English.
@property (nonatomic, strong, nullable) NSString *name_en;

/// Venue name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn;

/// Venue name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh;

/// Venue name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja;

/// Venue name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko;

/// Venue address in default language.
@property (nonatomic, strong, nullable) MXMAddress *address;

/// Venue address in English.
@property (nonatomic, strong, nullable) MXMAddress *address_en;

/// Venue address in Simplified Chinese.
@property (nonatomic, strong, nullable) MXMAddress *address_cn;

/// Venue address in Traditional Chinese.
@property (nonatomic, strong, nullable) MXMAddress *address_zh;

/// Venue address in Japanese.
@property (nonatomic, strong, nullable) MXMAddress *address_ja;

/// Venue address in Korean.
@property (nonatomic, strong, nullable) MXMAddress *address_ko;

/// External rectangular area where the venue is located
@property (nonatomic, strong, nullable) MXMBoundingBox *bbox;

/// List of all building ids attributed to this avenue.
@property (nonatomic, strong) NSArray<NSString *> *buildingIds;

/// The default building id in this venue, which can be used as the basis for selecting building by default when venue is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedBuildingId;

@end

NS_ASSUME_NONNULL_END
