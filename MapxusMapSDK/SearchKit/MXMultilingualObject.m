//
//  MXMultilingualObject.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/4/28.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMultilingualObject.h"

@implementation MXMultilingualObject

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
  MXMultilingualObject * copyedModel = [[self.class allocWithZone:zone] init];
  copyedModel.Default = self.Default;
  copyedModel.en = self.en;
  copyedModel.zh_Hans = self.zh_Hans;
  copyedModel.zh_Hant = self.zh_Hant;
  copyedModel.ja = self.ja;
  copyedModel.ko = self.ko;
  copyedModel.fil = self.fil;
  copyedModel._id = self._id;
  copyedModel.pt = self.pt;
  copyedModel.th = self.th;
  copyedModel.vi = self.vi;
  copyedModel.ar = self.ar;
  return copyedModel;
}

@end
