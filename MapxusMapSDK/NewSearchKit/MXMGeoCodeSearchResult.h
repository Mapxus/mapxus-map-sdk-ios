//
//  MXMGeoCodeSearchResult.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

/// `MXMReverseGeoCodeSearchResult` is a class that encapsulates the results of a reverse geocoding search.
@interface MXMReverseGeoCodeSearchResult : NSObject


/// The `floor` property represents the floor where the user is currently located.
/// It is an instance of the `MXMFloor` class.
@property (nonatomic, strong) MXMFloor *floor;


/// The `building` property represents the building where the user is currently located.
/// It is an instance of the `MXMBuilding` class.
/// This property only returns the `buildingId` and `nameMap` of the building.
@property (nonatomic, strong) MXMBuilding *building;


/// The `venue` property represents the venue where the user is currently located.
/// It is an instance of the `MXMVenue` class.
/// This property only returns the `venueId` and `nameMap` of the venue.
@property (nonatomic, strong) MXMVenue *venue;

@end

NS_ASSUME_NONNULL_END
