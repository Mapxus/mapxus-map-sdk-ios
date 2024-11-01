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

@implementation MGLMapView (MXMSwizzle)

- (void)setMxmMap:(MapxusMap *)mxmMap
{
    objc_setAssociatedObject(self, @selector(mxmMap), mxmMap, OBJC_ASSOCIATION_ASSIGN);
}

- (MapxusMap *)mxmMap
{
    return objc_getAssociatedObject(self, @selector(mxmMap));
}

- (CLLocation *)lastLocation {
  return objc_getAssociatedObject(self, @selector(lastLocation));
}

- (void)setLastLocation:(CLLocation *)lastLocation {
  objc_setAssociatedObject(self, @selector(lastLocation), lastLocation, OBJC_ASSOCIATION_COPY_NONATOMIC);
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
  // 添加透明level层，解决定位错误问题
  MGLSource *indoorSource = [style sourceWithIdentifier:@"indoor-planet"];
  if (indoorSource) {
    // 添加透明的楼层查找辅助层
    MGLFillStyleLayer *assistantLevelFill = [[MGLFillStyleLayer alloc] initWithIdentifier:@"assistant-mapxus-level-fill" source:indoorSource];
    assistantLevelFill.sourceLayerIdentifier = @"mapxus_level";
    assistantLevelFill.predicate = [NSPredicate predicateWithFormat:@"$geometryType = 'Polygon'"];
    assistantLevelFill.fillOpacity = [NSExpression expressionForConstantValue:@(0)];
    [style addLayer:assistantLevelFill];
    
    // 添加后景layer组
    NSString *bottomBaseLineString = @"mapxus-level-fill";
    NSString *topBaseLineString = @"mapxus-building-name";

    __block NSUInteger bottomIndex = 0;
    __block NSInteger topIndex = 0;
    [style.layers enumerateObjectsUsingBlock:^(__kindof MGLStyleLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj.identifier isEqualToString:bottomBaseLineString]) {
        bottomIndex = idx;
      } else if ([obj.identifier isEqualToString:topBaseLineString]) {
        topIndex = idx;
      }
    }];
    MGLStyleLayer *bottomNextLayer = [style.layers objectAtIndex:bottomIndex];
    NSRange range = NSMakeRange(bottomIndex, topIndex-bottomIndex);
    NSArray *copyOrigList = [style.layers subarrayWithRange:range];
    for (MGLStyleLayer *layer in copyOrigList) {
      MGLStyleLayer *newLayer = nil;
      if ([layer isKindOfClass:[MGLFillStyleLayer class]]) {
        newLayer = [style copyFillLayerWith:(MGLFillStyleLayer *)layer source:indoorSource];
      } else if ([layer isKindOfClass:[MGLLineStyleLayer class]]) {
        newLayer = [style copyLineLayerWith:(MGLLineStyleLayer *)layer source:indoorSource];
      } else if ([layer isKindOfClass:[MGLSymbolStyleLayer class]]) {
        newLayer = [style copySymbolLayerWith:(MGLSymbolStyleLayer *)layer source:indoorSource];
      }
      if (newLayer) {
        [style insertLayer:newLayer belowLayer:bottomNextLayer];
      }
    }
    // --添加后景layer组

    // 插入高亮外框层
    MGLLineStyleLayer *assistantLevelLine = [[MGLLineStyleLayer alloc] initWithIdentifier:@"assistant-mapxus-level-outline" source:indoorSource];
    assistantLevelLine.sourceLayerIdentifier = @"mapxus_level";
    assistantLevelLine.predicate = [NSPredicate predicateWithFormat:@"$geometryType = 'Polygon'"];
    
    MGLStyleLayer *topLayer = [style layerWithIdentifier:topBaseLineString];
    [style insertLayer:assistantLevelLine belowLayer:topLayer];
    [style outLineLevelBorderStyle:mapView.mxmMap.selectedBuildingBorderStyle];
    // --插入高亮外框层
  }
  
  // 创建原始过滤条件列表
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  for (MGLStyleLayer *k in style.layers) {
    // 过滤不需要处理的layer
    if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
      continue;
    }
    NSString *ident = k.identifier;
    if (![ident hasPrefix:@"mapxus"]) {
      continue;
    }
    MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
    dic[ident] = vk.predicate;
  }
  style.originalPredicateDic = dic;
  
  // 加载后全部室内结构隐藏或者重新过滤更换style之前的选择
  [mapView.mxmMap cleanMapSelected];
  // 结束异步operation
  [mapView.mxmMap searchConfigurationInfo];
  // 加载完style后重新设置outdoor
  [mapView.mxmMap walkAroundOutdoor];
  // 修改地图语言
  NSArray *languages = [NSLocale preferredLanguages];
  NSString *currentLanguage = [languages objectAtIndex:0];
  if ([currentLanguage containsString:@"en"]) {
    currentLanguage = @"en";
  } else if ([currentLanguage containsString:@"zh-Hant"]) {
    currentLanguage = @"zh-Hant";
  } else if ([currentLanguage containsString:@"zh-Hans"]) {
    currentLanguage = @"zh-Hans";
  } else if ([currentLanguage containsString:@"ja"]) {
    currentLanguage = @"ja";
  } else if ([currentLanguage containsString:@"ko"]) {
    currentLanguage = @"ko";
  } else {
    currentLanguage = @"default";
  }
  [mapView.mxmMap setMapLanguage:currentLanguage];
  [self hook_mapView:mapView didFinishLoadingStyle:style];
}
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style
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
  // 当curLocation不为nil，lastLocation为nil时，执行函数function；当curLocation不为nil，lastLocation也不为nil时，根据两个点间的距离大于0时执行函数function。
  // 忽略了只有ordinal改变的情况，因为这种场景较少概率发生，发生也会较快修复，只有在模拟时会出现。
  if (userLocation.location != nil &&
      ((mapView.lastLocation == nil) ||
       ([userLocation.location distanceFromLocation:mapView.lastLocation] != 0))) {
    
    if ((mapView.userTrackingMode != MGLUserTrackingModeNone) && userLocation.location.floor) { // 跟随模式且有楼层数据
      CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
      CGPoint locationPoint = [mapView convertCoordinate:coordinate toPointToView:mapView];
      NSArray<MXMLevelModel *> *floorFeatures = [mapView.mxmMap.dataQueryer findOutAssistantFloorFeaturesAtPoint:locationPoint
                                                                                                 pointCoordinate:coordinate];
      NSDictionary *buildingDic = [mapView.mxmMap.dataQueryer findOutBuildingAtPoint:locationPoint];
      MXMSite *info = [mapView.mxmMap.decider decideWithUserLocationLevel:userLocation.location.floor.level
                                                       atPointBuildingDic:buildingDic
                                                     atPointLevelInfoList:floorFeatures];
      if (info) {
        if (![info.floor.code isEqualToString:mapView.mxmMap.userLocationFloor]) {
          [mapView.mxmMap updateUserLocationFloor:info.floor.code];
        }
        if (![info.building.identifier isEqualToString:mapView.mxmMap.userLocationBuilding.identifier]) {
          [mapView.mxmMap updateUserLocationBuilding:info.building];
        }
        if (![info.venue.identifier isEqualToString:mapView.mxmMap.userLocationVenue.identifier]) {
          [mapView.mxmMap updateUserLocationVenue:info.venue];
        }
      }
    } else {
      [mapView.mxmMap updateLocationView];
      if (mapView.mxmMap.userLocationFloor != nil) {
        [mapView.mxmMap updateUserLocationFloor:nil];
      }
      if (mapView.mxmMap.userLocationBuilding != nil) {
        [mapView.mxmMap updateUserLocationBuilding:nil];
      }
      if (mapView.mxmMap.userLocationVenue != nil) {
        [mapView.mxmMap updateUserLocationVenue:nil];
      }
    }
    
  }
  mapView.lastLocation = userLocation.location;
  [self hook_mapView:mapView didUpdateUserLocation:userLocation];
}
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
}


@end
