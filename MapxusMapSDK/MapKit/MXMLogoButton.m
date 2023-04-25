//
//  MXMLogoButton.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/5/11.
//

#import "MXMLogoButton.h"
#import "MXMLogoView.h"

@interface MXMLogoButton ()
@property (nonatomic, strong) MXMLogoView *logoView;
@end

@implementation MXMLogoButton

- (instancetype)initWithCopyright:(BOOL)collapseCopyright {
  self = [super init];
  if (self) {
    self.collapseCopyright = collapseCopyright;
  }
  return self;
}

- (void)setCollapseCopyright:(BOOL)collapseCopyright {
  _collapseCopyright = collapseCopyright;
  [self layoutView:collapseCopyright];
}

- (void)layoutView:(BOOL)newType {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  if (newType) {
    if (self.logoView.superview) {
      [self.logoView removeFromSuperview];
    }
    UIImage *image = [UIImage imageNamed:@"copyrightInfo" inBundle:bundle compatibleWithTraitCollection:nil];
    [self setImage:image forState:UIControlStateNormal];
  } else {
    [self setImage:nil forState:UIControlStateNormal];
    [self addSubview:self.logoView];
    [self.leftAnchor constraintEqualToAnchor:self.logoView.leftAnchor].active = YES;
    [self.rightAnchor constraintEqualToAnchor:self.logoView.rightAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.logoView.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.logoView.bottomAnchor].active = YES;
  }

}

- (MXMLogoView *)logoView {
  if (!_logoView) {
    _logoView = [[MXMLogoView alloc] init];
    _logoView.userInteractionEnabled = NO;
    _logoView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _logoView;
}

@end
