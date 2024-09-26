//
//  MXMGeoBuilding.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// This class represents building information read from tiles.
@interface MXMGeoBuilding : NSObject <NSCopying>


/// A unique identifier for the building in the Mapxus system.
@property (nonatomic, strong) NSString *identifier;


/// The category of the building, indicating the type of the building (e.g., residential, commercial, retail, industrial, transportation, etc.).
///
/// @discussion
/// The category is the same as the venue to which the building belongs.
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *building DEPRECATED_MSG_ATTRIBUTE("Please use `category` instead.");


/// The ID of the venue where the building is located.
@property (nonatomic, strong) NSString *venueId;


/// The name of the building.
///
/// @discussion
/// This is an `MXMultilingualObject` that stores a multilingual mapping of `NSString` type.
/// This mapping allows us to retrieve the corresponding string value based on different language environments.
@property (nonatomic, strong) MXMultilingualObjectString *nameMap;


/// Building name in default language.
@property (nonatomic, strong, nullable) NSString *name DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.Default` instead.");


/// Building name in English.
@property (nonatomic, strong, nullable) NSString *name_en DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.en` instead.");


/// Building name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hans` instead.");


/// Building name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.zh_Hant` instead.");


/// Building name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");


/// Building name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko DEPRECATED_MSG_ATTRIBUTE("Please use `nameMap.ja` instead.");


/// All floors of the building.
@property (nonatomic, strong) NSArray<MXMFloor *> *floors;

@property (nonatomic, strong, nullable) MXMBoundingBox *bbox DEPRECATED_MSG_ATTRIBUTE("Incomplete figures will be removed.");

@property (nonatomic, strong, nullable) NSString *groundFloor DEPRECATED_MSG_ATTRIBUTE("Will be removed");

@property (nonatomic, strong, nullable) NSString *type DEPRECATED_MSG_ATTRIBUTE("Will be removed");


/// The default floor ID in this building, which can be used as the basis for selecting a floor by default when a building is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedFloorId;

@end

NS_ASSUME_NONNULL_END
