//
//  MXMFloorBarCell.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorBarCell.h"

@interface MXMFloorBarCell ()


@end

@implementation MXMFloorBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configSubviews];
  }
  return self;
}

- (void)refresh:(MXMFloorBarModel *)data {
  self.nameLabel.text = data.floor.code;
  self.badgeView.hidden = !data.located;
  self.nameLabel.font = data.selected ? [UIFont boldSystemFontOfSize:15] : [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (NSString *)cellIdentifier {
  return @"MXMFloorBarCell";
}

#pragma mark - UI Create

- (void)configSubviews {
  [self.contentView addSubview:self.nameLabel];
  [self.contentView addSubview:self.badgeView];
  
  [self.nameLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.leadingAnchor constant:0].active = YES;
  [self.nameLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
  [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
  [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
  
  [self.badgeView.widthAnchor constraintEqualToConstant:8].active = YES;
  [self.badgeView.heightAnchor constraintEqualToConstant:8].active = YES;
  [self.badgeView.bottomAnchor constraintEqualToAnchor:self.nameLabel.topAnchor constant:-1].active = YES;
  [self.badgeView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:1].active = YES;
}

- (UILabel *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
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
