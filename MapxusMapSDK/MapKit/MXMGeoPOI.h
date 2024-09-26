//
//  MXMGeoPOI.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// This class represents Point of Interest (POI) information read from tiles.
@interface MXMGeoPOI : NSObject <NSCopying>


/// A unique identifier for the POI in the Mapxus system.
@property (nonatomic, strong) NSString *identifier;


/// The ID of the building where the POI is located.
@property (nonatomic, strong, nullable) NSString *buildingId;


/// The floor detail where the POI is located.
@property (nonatomic, strong, nullable) MXMFloor *floor;


/// The longitude and latitude coordinates of the POI.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


/// The name of the POI.
///
/// @discussion
/// This is an `MXMultilingualObject` that stores a multilingual mapping of `NSString` type.
/// This mapping allows us to retrieve the corresponding string value based on different language environments.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;


/// The accessibility details of the POI.
///
/// @discussion
/// This is an `MXMultilingualObject` that stores a multilingual mapping of `NSString` type.
/// This mapping allows us to retrieve the corresponding string value based on different language environments.
@property (nonatomic, strong) MXMultilingualObjectString *accessibilityDetailMap;


/// POI name in default language.
@property (nonatomic, strong, nullable) NSString *name DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");


/// POI name in English.
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");


/// POI name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");


/// POI name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");


/// POI name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");


/// POI name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ko` instead.");


/// Accessibility Information in default language.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.Default` instead.");


/// Accessibility Information in English.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_en DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.en` instead.");


/// Accessibility Information in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_cn DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.zh_Hans` instead.");


/// Accessibility Information in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_zh DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.zh_Hant` instead.");


/// Accessibility Information in Japanese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ja DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.ja` instead.");


/// Accessibility Information in Korean.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ko DEPRECATED_MSG_ATTRIBUTE("Please use `accessibilityDetailMap.ko` instead.");


/// A list of categories to which the POI belongs.
@property (nonatomic, strong) NSArray<NSString *> *category;

@end

NS_ASSUME_NONNULL_END
