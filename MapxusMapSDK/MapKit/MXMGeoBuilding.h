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

/// Building information in tiles
@interface MXMGeoBuilding : NSObject <NSCopying>

/// A string that uniquely identifies the building in the mapxus system.
@property (nonatomic, strong) NSString *identifier;

/// Building category, indicating the classification of the building, e.g. residential, commercial, retail, industrial, transportation, etc.
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *building DEPRECATED_MSG_ATTRIBUTE("Please use `category`");

/// The id of venue where the building is located.
@property (nonatomic, strong) NSString *venueId;

/// Building name in default language.
@property (nonatomic, strong, nullable) NSString *name;

/// Building name in English.
@property (nonatomic, strong, nullable) NSString *name_en;

/// Building name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn;

/// Building name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh;

/// Building name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja;

/// Building name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko;

/// All floors of the building.
@property (nonatomic, strong) NSArray<MXMFloor *> *floors;

@property (nonatomic, strong, nullable) MXMBoundingBox *bbox DEPRECATED_MSG_ATTRIBUTE("Will be removed");

@property (nonatomic, strong, nullable) NSString *groundFloor DEPRECATED_MSG_ATTRIBUTE("Will be removed");

@property (nonatomic, strong, nullable) NSString *type DEPRECATED_MSG_ATTRIBUTE("Will be removed");

/// The default floor id in this building, which can be used as the basis for selecting floor by default when building is selected.
@property (nonatomic, strong, nullable) NSString *defaultDisplayedFloorId;

@property (nonatomic, strong) NSArray<NSString *> *overlapBuildingIds;

@end

NS_ASSUME_NONNULL_END
