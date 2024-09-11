//
//  MXMCategorySearchResult.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// `MXMPoiCategorySearchResult` is a class designed to encapsulate the results obtained from a POI category search.
@interface MXMPoiCategorySearchResult : NSObject


/// An array of `MXMCategory` objects that represents the search outcomes.
@property (nonatomic, strong) NSArray<MXMCategory *> *categoryResults;

@end



/// `MXMPoiCategoryVenueInfoEx` stores a category object and also holds the ID and name of the venue where this category is present.
@interface MXMPoiCategoryVenueInfoEx : NSObject


/// The category of the POI.
@property (nonatomic, strong) MXMCategory *category;


/// The ID of the venue within which the POI category is present.
@property (nonatomic, strong) NSString *venueId;


/// A multilingual map of venue names within which the POI category is present.
@property (nonatomic, strong) MXMultilingualObject<NSString *> *venueNameMap;

@end



/// Represents the results of a POI category search within a bounding box.
@interface MXMPoiCategoryBboxSearchResult : NSObject


/// An array of `MXMPoiCategoryVenueInfoEx` objects that represent the search results within the bounding box.
@property (nonatomic, strong) NSArray<MXMPoiCategoryVenueInfoEx *> *categoryVenueInfoExResults;

@end

NS_ASSUME_NONNULL_END
