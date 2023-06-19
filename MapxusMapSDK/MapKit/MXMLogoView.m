//
//  MXMLogoView.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/5/11.
//

#import "MXMLogoView.h"

@interface MXMLogoView ()
@property (nonatomic, strong) UIImageView *mapxusIcon;
@property (nonatomic, strong) UILabel *mapxusLabel;
@end

@implementation MXMLogoView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.spacing = 8;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFill;
    self.alignment = UIStackViewAlignmentFill;
    [self addViews];
  }
  return self;
}

- (void)addViews {
  [self addArrangedSubview:self.mapxusIcon];
  [self addArrangedSubview:self.mapxusLabel];
  [self.mapxusIcon.widthAnchor constraintEqualToConstant:26.5].active = YES;
  [self.mapxusIcon.heightAnchor constraintEqualToConstant:18.5].active = YES;
}

- (UIImageView *)mapxusIcon {
  if (!_mapxusIcon) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"mapxus_icon" inBundle:bundle compatibleWithTraitCollection:nil];
    _mapxusIcon = [[UIImageView alloc] initWithImage:image];
    _mapxusIcon.userInteractionEnabled = NO;
    _mapxusIcon.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _mapxusIcon;
}

- (UILabel *)mapxusLabel {
  if (!_mapxusLabel) {
    _mapxusLabel = [[UILabel alloc] init];
    _mapxusLabel.text = @"Mapxus";
    _mapxusLabel.font = [UIFont boldSystemFontOfSize:17];
    _mapxusLabel.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
    _mapxusLabel.userInteractionEnabled = NO;
    _mapxusLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _mapxusLabel;
}

@end
