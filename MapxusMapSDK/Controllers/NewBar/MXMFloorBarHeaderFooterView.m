//
//  MXMFloorBarHeaderFooterView.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorBarHeaderFooterView.h"
#import "UIImage+MXMSdk.h"

@interface MXMFloorBarHeaderFooterView ()

@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation MXMFloorBarHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    [self configSubviews];
  }
  return self;
}

- (void)useArrowImageViewUp:(BOOL)up {
  NSString *imageName = up ? @"chevron_up" : @"chevron_down";
  self.arrowImgView.image = [UIImage getMXMSdkImage:imageName];
}

+ (NSString *)headerFooterIdentifier {
  return @"MXMFloorBarHeaderFooterView";
}

#pragma mark - UI Create

- (void)configSubviews {
  [self.contentView addSubview:self.arrowImgView];
  [self.arrowImgView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
  [self.arrowImgView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
}

- (UIImageView *)arrowImgView {
  if (!_arrowImgView) {
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _arrowImgView;
}
@end
