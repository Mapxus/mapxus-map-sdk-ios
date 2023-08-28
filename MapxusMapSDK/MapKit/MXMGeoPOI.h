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

/// POI information in tiles
@interface MXMGeoPOI : NSObject <NSCopying>

/// A string that uniquely identifies the POI in the mapxus system.
@property (nonatomic, strong) NSString *identifier;

/// The id of building where the POI is located.
@property (nonatomic, strong, nullable) NSString *buildingId;

/// The floor detail where the POI is located.
@property (nonatomic, strong, nullable) MXMFloor *floor;

/// Longitude and latitude of POI.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// POI name in default language.
@property (nonatomic, strong, nullable) NSString *name;

/// POI name in English.
@property (nonatomic, strong, nullable) NSString *name_en;

/// POI name in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *name_cn;

/// POI name in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *name_zh;

/// POI name in Japanese.
@property (nonatomic, strong, nullable) NSString *name_ja;

/// POI name in Korean.
@property (nonatomic, strong, nullable) NSString *name_ko;

/// Accessibility Information in default language.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail;

/// Accessibility Information in English.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_en;

/// Accessibility Information in Simplified Chinese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_cn;

/// Accessibility Information in Traditional Chinese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_zh;

/// Accessibility Information in Japanese.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ja;

/// Accessibility Information in Korean.
@property (nonatomic, strong, nullable) NSString *accessibilityDetail_ko;

/// List of categories to which POI belongs.
@property (nonatomic, strong) NSArray<NSString *> *category;

@end

NS_ASSUME_NONNULL_END
