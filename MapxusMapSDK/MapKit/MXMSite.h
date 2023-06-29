//
//  MXMSite.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/1.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>
#import <MapxusMapSDK/MXMGeoVenue.h>
#import <MapxusMapSDK/MXMGeoBuilding.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Specify the details of a location
 */
@interface MXMSite : NSObject

/**
 The information of the floor at this site.
 */
@property (nonatomic, strong) MXMFloor *floor;

/**
 The information of the building at this site.
 */
@property (nonatomic, strong) MXMGeoBuilding *building;

/**
 The information of the venue at this site.
 */
@property (nonatomic, strong) MXMGeoVenue *venue;

@end

NS_ASSUME_NONNULL_END
