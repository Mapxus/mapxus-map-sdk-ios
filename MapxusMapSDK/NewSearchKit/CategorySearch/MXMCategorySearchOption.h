//
//  MXMCategorySearchOption.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// `MXMPoiCategoryFloorSearchOption` encapsulates the parameters for searching POI categories by floor.
@interface MXMPoiCategoryFloorSearchOption : NSObject


/// The ID of the floor to search within.
@property (nonatomic, copy) NSString *floorId;

@end



/// `MXMPoiCategoryBuildingSearchOption` encapsulates the parameters for searching POI categories by building.
@interface MXMPoiCategoryBuildingSearchOption : NSObject


/// The ID of the building to search within.
@property (nonatomic, copy) NSString *buildingId;

@end



/// `MXMPoiCategoryVenueSearchOption` encapsulates the parameters for searching POI categories by venue.
@interface MXMPoiCategoryVenueSearchOption : NSObject


/// The ID of the venue to search within.
@property (nonatomic, copy) NSString *venueId;

@end



/// `MXMPoiCategoryBboxSearchOption` encapsulates the parameters for searching POI categories within a bounding box.
@interface MXMPoiCategoryBboxSearchOption : NSObject


/// The keyword for the search.
@property (nonatomic, copy, nullable) NSString *keyword;


/// The bounding box defining the search area.
@property (nonatomic, copy) MXMBoundingBox *bbox;

@end

NS_ASSUME_NONNULL_END
