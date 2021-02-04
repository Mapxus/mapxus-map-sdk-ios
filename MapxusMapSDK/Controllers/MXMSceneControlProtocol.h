//
//  MXMSceneControlProtocol.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/2/3.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMGeoBuilding.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MapxusMap主类
 */

@protocol MXMBuildingSelectorDelegate <NSObject>

- (void)didSelectBuilding:(nullable NSString *)buildingId;

@end



@protocol MXMBuildingSelectorRenderingDelegate <NSObject>

@property (nonatomic, weak) id<MXMBuildingSelectorDelegate> mxmDelegate;
- (void)refreshBuildingList:(NSArray<MXMGeoBuilding *> *)list;
- (void)selectedBuildig:(MXMGeoBuilding *)building;
- (void)setSelectorHidden:(BOOL)isHidden;

@end





/**
 * MapxusMap主类
 */
@protocol MXMFloorSelectorDelegate <NSObject>

- (void)didSelectFloor:(nullable NSString *)floorName;

@end



@protocol MXMFloorSelectorRenderingDelegate <NSObject>

@property (nonatomic, weak) id<MXMFloorSelectorDelegate> mxmDelegate;
- (void)selectedBuilding:(MXMGeoBuilding *)building floor:(NSString *)floorName;
- (void)setSelectorHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
