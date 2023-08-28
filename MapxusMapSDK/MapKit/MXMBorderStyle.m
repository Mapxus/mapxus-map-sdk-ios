//
//  MXMBorderStyle.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/5/29.
//

#import "MXMBorderStyle.h"
#import "JXJsonFunctionDefine.h"

@implementation MXMBorderStyle

- (NSExpression *)lineWidth {
  if (_lineWidth == nil) {
    _lineWidth = [NSExpression expressionForConstantValue:@(1)];
  }
  return _lineWidth;
}

- (NSExpression *)lineColor {
  if (_lineColor == nil) {
    _lineColor = [NSExpression expressionForConstantValue:[UIColor blackColor]];
  }
  return _lineColor;
}

- (NSExpression *)lineOpacity {
  if (_lineOpacity == nil) {
    _lineOpacity = [NSExpression expressionForConstantValue:@(1)];
  }
  return _lineOpacity;
}

+ (MXMBorderStyle *)defaultSelectedBuildingBorderStyle {
  MXMBorderStyle *style = [[MXMBorderStyle alloc] init];
  style.lineWidth = [NSExpression expressionForConstantValue:@(3)];
  style.lineColor = [NSExpression expressionForConstantValue:MXMRGBHex(0xA5E3FF)];
  style.lineOpacity = [NSExpression expressionForConstantValue:@(1)];
  return style;
}

@end
