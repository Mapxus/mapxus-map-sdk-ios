//
//  MXMSearchFloorOperation.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/8/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMSearchFloorOperation : NSObject

@property (nonatomic, copy) void (^complateBlock)( MXMBuilding * _Nullable building);

- (void)searchWithFloorId:(NSString *)floorId;

@end

NS_ASSUME_NONNULL_END
