//
//  MXMGeoBuilding.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Building information in tiles
 */
@interface MXMGeoBuilding : NSObject

/// building id
@property (nonatomic, strong) NSString *identifier;
/// Building type, indicating the classification of the building, e.g. cathedral, car_park, hospital, office, retail, etc.
@property (nonatomic, strong) NSString *building;
/// The id of venue where the building is located
@property (nonatomic, strong, nullable) NSString *venueId;
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
/// All floors of the building
@property (nonatomic, strong) NSArray<MXMFloor *> *floors;
/// The ground floor of the building
@property (nonatomic, strong, nullable) NSString *groundFloor;
/// Map rendering types, e.g. multipolygon
@property (nonatomic, strong, nullable) NSString *type;

@end

NS_ASSUME_NONNULL_END
