//
//  MXMSearchBuildingOperation2.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/21.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMSearchAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMSearchBuildingOperation2 : NSObject

@property (nonatomic, copy) void (^complateBlock)( MXMBuilding * _Nullable building);

- (void)searchWithBuildingId:(NSString *)buildingId;

@end

NS_ASSUME_NONNULL_END
