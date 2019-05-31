//
//  MGLMapView+MXMSwizzle.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <objc/runtime.h>

#import "MGLMapView+MXMSwizzle.h"
#import "MapxusMap+Private.h"
#import "MGLStyle+MXMFilter.h"

static void *mapKey = &mapKey;

@implementation MGLMapView (MXMSwizzle)

- (void)setMxmMap:(MapxusMap *)mxmMap
{
    objc_setAssociatedObject(self, &mapKey, mxmMap, OBJC_ASSOCIATION_ASSIGN);
}

- (MapxusMap *)mxmMap
{
    return objc_getAssociatedObject(self, &mapKey);
}

+ (void)load
{
    static dispatch_once_t mxmOnceToken;
    dispatch_once(&mxmOnceToken, ^{
        SEL oldSelector = @selector(setDelegate:);
        SEL newSelector = @selector(hook_setDelegate:);
        Method oldMethod = class_getInstanceMethod([self class], oldSelector);
        Method newMethod = class_getInstanceMethod([self class], newSelector);
        
        // 若未实现代理方法，则先添加代理方法
        BOOL isSuccess = class_addMethod([self class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        if (isSuccess) {
            class_replaceMethod([self class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod));
        } else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)hook_setDelegate:(id<MGLMapViewDelegate>)delegate
{
    [self exchangeFinishLoadingStyleWithDelegate:delegate];
    [self exchangeFinishRenderingFrameWithDelegate:delegate];
    [self exchangeWillStartLoadingMapWithDelegate:delegate];
    [self exchangeDidfinishLoadingMapWithDelegate:delegate];
    [self exchangeDidFailLoadingMapWithDelegate:delegate];
    [self exchangeRegionDidChangeWithDelegate:delegate];
    [self exchangeMapViewDidBecomeIdleWithDelegate:delegate];
    [self exchangeDidUpdateUserLocationWithDelegate:delegate];
    [self hook_setDelegate:delegate];
}


- (void)exchangeFinishLoadingStyleWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapView:didFinishLoadingStyle:);
    SEL newSelector = @selector(hook_mapView:didFinishLoadingStyle:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style
{
    // 结束异步operation
    [mapView.mxmMap searchConfigurationInfo];
    // 加载完style后重新设置outdoor
    [mapView.mxmMap walkAroundOutdoor];
    // 修改地图语言
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    [style MXMlocalizeLabelsIntoLocale:currentLanguage];
    [self hook_mapView:mapView didFinishLoadingStyle:style];
}
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style
{
}


- (void)exchangeFinishRenderingFrameWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapViewDidFinishRenderingFrame:fullyRendered:);
    SEL newSelector = @selector(hook_mapViewDidFinishRenderingFrame:fullyRendered:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapViewDidFinishRenderingFrame:(MGLMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (!mapView.mxmMap.mapViewDidFinishLoadingMap) {
        // 查找中心矩形可见Building
        [mapView.mxmMap automaticAnalyseOfIndoorData];
    }
    [self hook_mapViewDidFinishRenderingFrame:mapView fullyRendered:fullyRendered];
}
- (void)mapViewDidFinishRenderingFrame:(MGLMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
}


- (void)exchangeWillStartLoadingMapWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapViewWillStartLoadingMap:);
    SEL newSelector = @selector(hook_mapViewWillStartLoadingMap:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapViewWillStartLoadingMap:(MGLMapView *)mapView
{
    mapView.mxmMap.mapViewDidFinishLoadingMap = NO;
    mapView.mxmMap.decider.isMapReload = YES;
    [self hook_mapViewWillStartLoadingMap:mapView];
}
- (void)mapViewWillStartLoadingMap:(MGLMapView *)mapView
{
}


- (void)exchangeDidfinishLoadingMapWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapViewDidFinishLoadingMap:);
    SEL newSelector = @selector(hook_mapViewDidFinishLoadingMap:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
    mapView.mxmMap.mapViewDidFinishLoadingMap = YES;
    // 查找中心矩形可见Building
    [mapView.mxmMap automaticAnalyseOfIndoorData];
    [self hook_mapViewDidFinishLoadingMap:mapView];
}
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
}


- (void)exchangeDidFailLoadingMapWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapViewDidFailLoadingMap:withError:);
    SEL newSelector = @selector(hook_mapViewDidFailLoadingMap:withError:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapViewDidFailLoadingMap:(MGLMapView *)mapView withError:(NSError *)error
{
    mapView.mxmMap.mapViewDidFinishLoadingMap = YES;
    [self hook_mapViewDidFailLoadingMap:mapView withError:error];
}
- (void)mapViewDidFailLoadingMap:(MGLMapView *)mapView withError:(NSError *)error
{
}


- (void)exchangeRegionDidChangeWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapView:regionDidChangeAnimated:);
    SEL oldLongSelector = @selector(mapView:regionDidChangeWithReason:animated:);
    
    SEL newSelector = @selector(hook_mapView:regionDidChangeAnimated:);
    SEL newLongSelector = @selector(hook_mapView:regionDidChangeWithReason:animated:);
    
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldLongMethod_del = class_getInstanceMethod([delegate class], oldLongSelector);
    
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    Method newLongMethod = class_getInstanceMethod([self class], newLongSelector);
    
    // 先判断有哪个方法
    if (oldLongMethod_del) {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newLongSelector, class_getMethodImplementation([delegate class], oldLongSelector), method_getTypeEncoding(oldLongMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldLongSelector, class_getMethodImplementation([self class], newLongSelector), method_getTypeEncoding(newLongMethod));
        }
    } else if (oldMethod_del) {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    } else {
        // 若未实现代理方法，则先添加代理方法
        BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        if (isSuccess) {
            class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
        }
    }
}
- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // 如果delegate两个方法都没有实现，需要先把本方法添加到delegate里，再实现交换
}
- (void)hook_mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // 查找中心矩形可见Building
    [mapView.mxmMap automaticAnalyseOfIndoorData];
    [self hook_mapView:mapView regionDidChangeAnimated:animated];
}
- (void)hook_mapView:(MGLMapView *)mapView regionDidChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated
{
    // 查找中心矩形可见Building
    [mapView.mxmMap automaticAnalyseOfIndoorData];
    [self hook_mapView:mapView regionDidChangeWithReason:reason animated:animated];
}


- (void)exchangeMapViewDidBecomeIdleWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapViewDidBecomeIdle:);
    SEL newSelector = @selector(hook_mapViewDidBecomeIdle:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapViewDidBecomeIdle:(MGLMapView *)mapView
{
    // 查找中心矩形可见Building
    if (!mapView.mxmMap.regionBecomeIdle) {
        mapView.mxmMap.regionBecomeIdle = YES;
        [mapView.mxmMap idleAutomaticAnalyseOfIndoorData];
    }
    [self hook_mapViewDidBecomeIdle:mapView];
}
- (void)mapViewDidBecomeIdle:(MGLMapView *)mapView
{
}


- (void)exchangeDidUpdateUserLocationWithDelegate:(id<MGLMapViewDelegate>)delegate
{
    SEL oldSelector = @selector(mapView:didUpdateUserLocation:);
    SEL newSelector = @selector(hook_mapView:didUpdateUserLocation:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}
- (void)hook_mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
    if ((mapView.userTrackingMode != MGLUserTrackingModeNone) && userLocation.location.floor) { // 跟随模式且有楼层数据
        CGPoint locationPoint = [mapView convertCoordinate:userLocation.location.coordinate toPointToView:mapView];
        NSDictionary *buildingDic = [mapView.mxmMap.dataQueryer findOutBuildingAtPoint:locationPoint];
        MXMIndoorMapInfo *info = [mapView.mxmMap.decider decideWithUserLocationLevel:userLocation.location.floor.level atPointBuildingDic:buildingDic];
        if (info) {
            if (![info.floor isEqualToString:mapView.mxmMap.userLocationFloor]) {
                mapView.mxmMap.userLocationFloor = info.floor;
            }
            if (![info.building.identifier isEqualToString:mapView.mxmMap.userLocationBuilding.identifier]) {
                mapView.mxmMap.userLocationBuilding = info.building;
            }
        }
    } else {
        [mapView.mxmMap updageLocationView];
        if (mapView.mxmMap.userLocationFloor != nil) {
            mapView.mxmMap.userLocationFloor = nil;
        }
        if (mapView.mxmMap.userLocationBuilding != nil) {
            mapView.mxmMap.userLocationBuilding = nil;
        }
    }
    [self hook_mapView:mapView didUpdateUserLocation:userLocation];
}
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
}


@end
