//
//  MXMPointAnnotation.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPointAnnotation+Private.h"

@implementation MXMPointAnnotation

static void *MXMFloorContext = &MXMFloorContext;
static void *MXMFloorIdContext = &MXMFloorIdContext;

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(floor)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:MXMFloorContext];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(floorId)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:MXMFloorIdContext];
  }
  return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  if (context == MXMFloorIdContext && [keyPath isEqualToString:NSStringFromSelector(@selector(floorId))]) {
    if (self.sceneRefreshBlock) {
      self.sceneRefreshBlock(self.buildingId, nil, self.floorId);
    }
  } else if (context == MXMFloorContext && [keyPath isEqualToString:NSStringFromSelector(@selector(floor))]) {
    if (self.sceneRefreshBlock) {
      self.sceneRefreshBlock(self.buildingId, self.floor, nil);
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(floor)) context:MXMFloorContext];
  [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(floorId)) context:MXMFloorIdContext];
}

@end
