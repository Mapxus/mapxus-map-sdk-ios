//
//  MXMGeoVenue.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2022/12/14.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMGeoVenue : NSObject <NSCopying>

@property (nonatomic, strong) NSString *identifier;
/// Building type, indicating the classification of the building, e.g. cathedral, car_park, hospital, office, retail, etc.
@property (nonatomic, strong) NSString *venueType;
/// Building name in default language
@property (nonatomic, strong, nullable) NSString *name;
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
@property (nonatomic, strong, nullable) MXMAddress *address;
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

@property (nonatomic, strong) NSArray<NSString *> *buildingIds;

@property (nonatomic, strong, nullable) NSString *defaultDisplayedBuildingId;

@end

NS_ASSUME_NONNULL_END
