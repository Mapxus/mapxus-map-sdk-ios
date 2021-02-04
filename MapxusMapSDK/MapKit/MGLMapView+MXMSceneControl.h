//
//  MGLMapView+MXMSceneControl.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/2/2.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "MXMFloorSelectorBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGLMapView (MXMSceneControl)

@property (nonatomic, strong, nullable) id<MXMBuildingSelectorRenderingDelegate> buildingBar;

@property (nonatomic, strong, nullable) id<MXMFloorSelectorRenderingDelegate> floorBar;

@end

NS_ASSUME_NONNULL_END
