//
//  MXMFloorFoldButton.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorFoldButton.h"

@interface MXMFloorFoldButton ()


@end

@implementation MXMFloorFoldButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.clipsToBounds = YES;
    [self configSubviews];
  }
  return self;
}

- (void)setFloorBarModel:(MXMFloorBarModel *)model {
  self.nameLabel.text = model.floor.code;
  self.badgeView.hidden = !model.located;
}

- (void)configSubviews {
  [self addSubview:self.nameLabel];
  [self addSubview:self.badgeView];
  
  [self.nameLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:0].active = YES;
  [self.nameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-8].active = YES;
  [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
  [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
  
  [self.badgeView.widthAnchor constraintEqualToConstant:8].active = YES;
  [self.badgeView.heightAnchor constraintEqualToConstant:8].active = YES;
  [self.badgeView.bottomAnchor constraintEqualToAnchor:self.nameLabel.topAnchor constant:-1].active = YES;
  [self.badgeView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:1].active = YES;
}

- (UILabel *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _nameLabel;
}

- (UIView *)badgeView {
  if (!_badgeView) {
    _badgeView = [[UIView alloc] init];
    _badgeView.hidden = YES;
    _badgeView.layer.cornerRadius = 4;
    _badgeView.layer.masksToBounds = YES;
    _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _badgeView;
}
@end
