//
//  MXMAnnotationsHolder.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/26.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMAnnotationsHolder.h"
#import "MXMPointAnnotation+Private.h"

@interface MXMAnnotationsHolder ()

@property (nonatomic, weak) MGLMapView *mapView;

@end


@implementation MXMAnnotationsHolder

- (instancetype)initWithMapView:(MGLMapView *)mapView
{
  self = [super init];
  if (self) {
    self.mapView = mapView;
  }
  return self;
}

- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
  [self.mxmPointAnnotations addObjectsFromArray:annotations];
  [self.mapView addAnnotations:annotations];
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
  // 找交集
  NSMutableSet *all = [NSMutableSet setWithArray:self.mapView.annotations];
  NSMutableSet *mxms = [NSMutableSet setWithArray:annotations];
  [all intersectSet:mxms];
  NSArray *intersection = all.allObjects;
  [self.mapView removeAnnotations:intersection];
  [self.mxmPointAnnotations removeObjectsInArray:annotations];
}

// annotation过滤
- (void)filterMXMAnnotationsWithBuilding:(nullable NSString *)buildingId
                                   floor:(nullable NSString *)floor
                                 floorId:(nullable NSString *)floorId
                             indoorState:(BOOL)isIndoor {
  NSMutableArray *hiddenAnn = [NSMutableArray array];
  NSMutableArray *noHiddenAnn = [NSMutableArray array];
  for (MXMPointAnnotation *ann in self.mxmPointAnnotations) {
    ann.hidden = [self decideShouldBeHiddenWithAnnotation:ann
                                               buildingId:buildingId
                                                  floorId:floorId
                                                    floor:floor
                                              indoorState:isIndoor];
    ann.hidden ? [hiddenAnn addObject:ann] : [noHiddenAnn addObject:ann];
  }
  // 找交集
  NSMutableSet *showingAnnSet = [NSMutableSet setWithArray:self.mapView.annotations];
  NSMutableSet *hiddenAnnSet = [NSMutableSet setWithArray:hiddenAnn];
  NSMutableSet *noHiddenAnnSet = [NSMutableSet setWithArray:noHiddenAnn];
  
  [hiddenAnnSet intersectSet:showingAnnSet];
  [noHiddenAnnSet minusSet:showingAnnSet];
  
  // 移除公共部分
  [self.mapView removeAnnotations:hiddenAnnSet.allObjects];
  // 添加不隐藏的marker
  [self.mapView addAnnotations:noHiddenAnnSet.allObjects];
}

- (BOOL)decideShouldBeHiddenWithAnnotation:(MXMPointAnnotation *)ann
                                buildingId:(nullable NSString *)buildingId
                                   floorId:(nullable NSString *)floorId
                                     floor:(nullable NSString *)floor
                               indoorState:(BOOL)isIndoor
{
  // 只要buildingId或者floor为空，则为室外marker，室外marker会一直显示
  if (ann.floorId) {
    // 室内marker分成当前在室外和室内两种情况
    if (isIndoor) {
      // 在室内在只显示当前选中building,floor的marker
      if ([ann.floorId isEqualToString:floorId]) {
        return NO;
      } else {
        return YES;
      }
    } else {
      // 在室外隐藏所有室内marker
      return YES;
    }
  }
  
  if (ann.buildingId == nil || ann.floor == nil) {
    return NO;
  }
  // 室内marker分成当前在室外和室内两种情况
  if (isIndoor) {
    // 在室内在只显示当前选中building,floor的marker
    if ([ann.buildingId isEqualToString:buildingId] && [ann.floor isEqualToString:floor]) {
      return NO;
    } else {
      return YES;
    }
  } else {
    // 在室外隐藏所有室内marker
    return YES;
  }
}

#pragma mark - access

- (NSMutableArray *)mxmPointAnnotations
{
  if (!_mxmPointAnnotations) {
    _mxmPointAnnotations = [NSMutableArray array];
  }
  return _mxmPointAnnotations;
}

@end
