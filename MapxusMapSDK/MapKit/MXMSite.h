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

/// This class represents a specific location, known as a site.
@interface MXMSite : NSObject


/// The floor information for this site.
@property (nonatomic, strong) MXMFloor *floor;


/// The building information for this site.
@property (nonatomic, strong) MXMGeoBuilding *building;


/// The venue information for this site.
@property (nonatomic, strong) MXMGeoVenue *venue;

@end

NS_ASSUME_NONNULL_END
