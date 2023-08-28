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

/**
 Reverse geo search result
 */
@interface MXMReverseGeoCodeSearchResult : NSObject

/// The information of the floor where you are located
@property (nonatomic, strong) MXMFloor *floor;

/// The information of the building where you are located, returning only the buildingId and name information.
@property (nonatomic, strong) MXMBuilding *building;

/// The information of the venue where you are located, returning only the venueId and name information.
@property (nonatomic, strong) MXMVenue *venue;

@end

NS_ASSUME_NONNULL_END
