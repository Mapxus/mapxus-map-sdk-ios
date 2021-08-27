//
//  MXMGeoCodeSearchResult.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Reverse geo search result
 */
@interface MXMReverseGeoCodeSearchResult : NSObject
/// Query for information about the building in which the location is located, returning only the buildingId and name information
@property (nonatomic, strong) MXMBuilding *building;
/// The information of the floor where you are located
@property (nonatomic, strong) MXMFloor *floor;
@end

NS_ASSUME_NONNULL_END
