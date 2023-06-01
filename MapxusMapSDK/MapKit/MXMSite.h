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

@interface MXMSite : NSObject

/// The information of the floor at this site.
@property (nonatomic, strong) MXMFloor *floor;

/// The information of the floor at the site.
@property (nonatomic, strong) MXMGeoBuilding *building;

/// The information of the floor at the site.
@property (nonatomic, strong) MXMGeoVenue *venue;

@end

NS_ASSUME_NONNULL_END
