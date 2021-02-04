//
//  MGLMapView+MXMSceneControl.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/2/2.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//
static void *kbuildingBar = &kbuildingBar;
static void *kfloorBar = &kfloorBar;

#import <objc/runtime.h>
#import "MGLMapView+MXMSceneControl.h"

@implementation MGLMapView (MXMSceneControl)

- (id<MXMBuildingSelectorRenderingDelegate>)buildingBar {
    return objc_getAssociatedObject(self, kbuildingBar);
}

- (void)setBuildingBar:(id<MXMBuildingSelectorRenderingDelegate>)buildingBar {
    objc_setAssociatedObject(self, kbuildingBar, buildingBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (id<MXMFloorSelectorRenderingDelegate>)floorBar {
    return objc_getAssociatedObject(self, kfloorBar);

}

- (void)setFloorBar:(id<MXMFloorSelectorRenderingDelegate>)floorBar {
    objc_setAssociatedObject(self, kfloorBar, floorBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

@end
