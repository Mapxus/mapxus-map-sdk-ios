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
- (void)filterMXMAnnotationsWithBuilding:(NSString *)buildingId floor:(nullable NSString *)floor indoorState:(BOOL)isIndoor
{
    NSMutableArray *MXMAnns = [NSMutableArray array];
    for (MXMPointAnnotation *ann in self.mxmPointAnnotations) {
        ann.hidden = [self decideShouldBeHiddenWithAnnotation:ann Building:buildingId floor:floor indoorState:isIndoor];
        ann.hidden ? nil : [MXMAnns addObject:ann];
    }
    // 找交集
    NSMutableSet *all = [NSMutableSet setWithArray:self.mapView.annotations];
    NSMutableSet *mxms = [NSMutableSet setWithArray:self.mxmPointAnnotations];
    [all intersectSet:mxms];
    NSArray *intersection = all.allObjects;
    // 移除公共部分
    [self.mapView removeAnnotations:intersection];
    // 添加不隐藏的marker
    [self.mapView addAnnotations:MXMAnns];
}

- (BOOL)decideShouldBeHiddenWithAnnotation:(MXMPointAnnotation *)ann Building:(NSString *)buildingId floor:(nullable NSString *)floor indoorState:(BOOL)isIndoor
{
    if (isIndoor &&
        [ann.buildingId isEqualToString:buildingId] &&
        ann.floor &&
        floor &&
        ![ann.floor isEqualToString:floor]) {
        return YES;
    } else {
        return NO;
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
