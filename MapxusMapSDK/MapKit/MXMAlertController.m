//
//  MXMAlertController.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/4/21.
//

#import "MXMAlertController.h"
#import "MXMLogoView.h"

@interface MXMAlertController ()
@property (nonatomic, strong) UIView *boxShadow;
@property (nonatomic, strong) UIView *box;

@property (nonatomic, strong) MXMLogoView *mapxusView;
@property (nonatomic, strong) UIButton *mapxusBtn;

@property (nonatomic, strong) UILabel *osmLabel;
@property (nonatomic, strong) UIButton *osmBtn;

@property (nonatomic, strong) UIView *cancelShadow;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSLayoutConstraint *bottomLayout;
@end


@implementation MXMAlertController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
  
  [self addViews];
  [self createConstraints];
}

- (void)addViews {
  [self.mapxusBtn addSubview:self.mapxusView];
  [self.osmBtn addSubview:self.osmLabel];
  
  [self.box addSubview:self.mapxusBtn];
  [self.box addSubview:self.osmBtn];
  
  [self.view addSubview:self.boxShadow];
  [self.view addSubview:self.box];
  [self.view addSubview:self.cancelShadow];
  [self.view addSubview:self.cancelBtn];
}

- (void)createConstraints {
  NSLayoutConstraint *boxCenterX = [self.box.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
  boxCenterX.priority = UILayoutPriorityDefaultHigh;
  
  NSLayoutConstraint *boxWidth = [self.box.widthAnchor constraintEqualToConstant:359];
  boxWidth.priority = UILayoutPriorityDefaultHigh;

  NSLayoutConstraint *boxLeading = [self.box.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:8];
  boxLeading.priority = UILayoutPriorityRequired;
  
  NSLayoutConstraint *boxTrailing = [self.box.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-8];
  boxLeading.priority = UILayoutPriorityRequired;
  
  NSArray *sameConstraints = @[
    boxCenterX,
    boxWidth,
    boxLeading,
    boxTrailing,
    [self.box.heightAnchor constraintEqualToConstant:113],
    
    [self.boxShadow.centerXAnchor constraintEqualToAnchor:self.box.centerXAnchor],
    [self.boxShadow.centerYAnchor constraintEqualToAnchor:self.box.centerYAnchor],
    [self.boxShadow.widthAnchor constraintEqualToAnchor:self.box.widthAnchor],
    [self.boxShadow.heightAnchor constraintEqualToAnchor:self.box.heightAnchor],
    
    [self.cancelBtn.topAnchor constraintEqualToAnchor:self.box.bottomAnchor constant:10],
    [self.cancelBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [self.cancelBtn.heightAnchor constraintEqualToConstant:56],
    [self.cancelBtn.widthAnchor constraintEqualToAnchor:self.box.widthAnchor],
    
    [self.cancelShadow.centerXAnchor constraintEqualToAnchor:self.cancelBtn.centerXAnchor],
    [self.cancelShadow.centerYAnchor constraintEqualToAnchor:self.cancelBtn.centerYAnchor],
    [self.cancelShadow.widthAnchor constraintEqualToAnchor:self.cancelBtn.widthAnchor],
    [self.cancelShadow.heightAnchor constraintEqualToAnchor:self.cancelBtn.heightAnchor],
    
    [self.mapxusBtn.topAnchor constraintEqualToAnchor:self.box.topAnchor],
    [self.mapxusBtn.leftAnchor constraintEqualToAnchor:self.box.leftAnchor],
    [self.mapxusBtn.rightAnchor constraintEqualToAnchor:self.box.rightAnchor],
    [self.mapxusBtn.heightAnchor constraintEqualToConstant:56],
    
    [self.osmBtn.bottomAnchor constraintEqualToAnchor:self.box.bottomAnchor],
    [self.osmBtn.leftAnchor constraintEqualToAnchor:self.box.leftAnchor],
    [self.osmBtn.rightAnchor constraintEqualToAnchor:self.box.rightAnchor],
    [self.osmBtn.heightAnchor constraintEqualToConstant:56],
    
    [self.mapxusView.centerXAnchor constraintEqualToAnchor:self.mapxusBtn.centerXAnchor],
    [self.mapxusView.centerYAnchor constraintEqualToAnchor:self.mapxusBtn.centerYAnchor],

    [self.osmLabel.centerXAnchor constraintEqualToAnchor:self.osmBtn.centerXAnchor],
    [self.osmLabel.centerYAnchor constraintEqualToAnchor:self.osmBtn.centerYAnchor],
  ];
  
  if (@available(iOS 11.0, *)) {
    self.bottomLayout = [self.box.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-200];
  } else {
    // Fallback on earlier versions
    self.bottomLayout = [self.box.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor constant:-200];
  }
  
  NSMutableArray *mCompactConstraints = [NSMutableArray array];
  [mCompactConstraints addObject:self.bottomLayout];
  [mCompactConstraints addObjectsFromArray:sameConstraints];
  
  [NSLayoutConstraint activateConstraints:mCompactConstraints];
}

+ (void)presentAlert {
  UIViewController *rootVC = [MXMAlertController getKeyWindow].rootViewController;
  MXMAlertController *alert = [[MXMAlertController alloc] init];
  alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
  [rootVC presentViewController:alert animated:YES completion:nil];
}

+ (nullable UIWindow *)getKeyWindow {
  if (@available(iOS 13.0, *)) {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
      if (scene.activationState == UISceneActivationStateForegroundActive) {
        for (UIWindow *window in scene.windows) {
          if (window.isKeyWindow) {
            return window;
          }
        }
      }
    }
  } else {
    return [UIApplication sharedApplication].delegate.window;
  }
  return nil;
}

- (void)clickOnMapxusBtn {
  [self dismissViewControllerAnimated:NO completion:nil];
  if (@available(iOS 10.0, *)) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MAPXUS_COPYRIGHT_URL] options:@{} completionHandler:nil];
  } else {
    // Fallback on earlier versions
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MAPXUS_COPYRIGHT_URL]];
  }
}

- (void)clickOnOsmBtn {
  [self dismissViewControllerAnimated:NO completion:nil];
  if (@available(iOS 10.0, *)) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ABOUT_SOURCE_URL] options:@{} completionHandler:nil];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ABOUT_SOURCE_URL]];
  }
}

- (void)clickOnCancelBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)boxShadow {
  if (!_boxShadow) {
    _boxShadow = [[UIView alloc] init];
    _boxShadow.backgroundColor = [UIColor whiteColor];
    _boxShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    _boxShadow.layer.shadowOffset = CGSizeMake(0, 5);
    _boxShadow.layer.cornerRadius = 12;
    _boxShadow.layer.shadowRadius = 4;
    _boxShadow.layer.shadowOpacity = 0.2;
    _boxShadow.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _boxShadow;
}

- (UIView *)box {
  if (!_box) {
    _box = [[UIView alloc] init];
    _box.layer.cornerRadius = 12;
    _box.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    _box.clipsToBounds = YES;
    _box.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _box;
}

- (MXMLogoView *)mapxusView {
  if (!_mapxusView) {
    _mapxusView = [[MXMLogoView alloc] init];
    _mapxusView.userInteractionEnabled = NO;
    _mapxusView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _mapxusView;
}

- (UIButton *)mapxusBtn {
  if (!_mapxusBtn) {
    _mapxusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapxusBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_mapxusBtn addTarget:self action:@selector(clickOnMapxusBtn) forControlEvents:UIControlEventTouchUpInside];
    _mapxusBtn.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _mapxusBtn;
}

- (UILabel *)osmLabel {
  if (!_osmLabel) {
    _osmLabel = [[UILabel alloc] init];
    _osmLabel.text = SOURCE_COPYRIGHT_TITLE;
    _osmLabel.font = [UIFont boldSystemFontOfSize:17];
    _osmLabel.textColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1];
    _osmLabel.userInteractionEnabled = NO;
    _osmLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _osmLabel;
}

- (UIButton *)osmBtn {
  if (!_osmBtn) {
    _osmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _osmBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_osmBtn addTarget:self action:@selector(clickOnOsmBtn) forControlEvents:UIControlEventTouchUpInside];
    _osmBtn.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _osmBtn;
}

- (UIButton *)cancelBtn {
  if (!_cancelBtn) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *cancelStr = NSLocalizedStringFromTableInBundle(@"Cancel", @"Localizable", bundle, nil);

    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    [_cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:32/255.0 green:115/255.0 blue:236/255.0 alpha:1]
                     forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _cancelBtn.layer.cornerRadius = 12;
    _cancelBtn.clipsToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(clickOnCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _cancelBtn;
}

- (UIView *)cancelShadow {
  if (!_cancelShadow) {
    _cancelShadow = [[UIView alloc] init];
    _cancelShadow.backgroundColor = [UIColor whiteColor];
    _cancelShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    _cancelShadow.layer.shadowOffset = CGSizeMake(0, 5);
    _cancelShadow.layer.cornerRadius = 12;
    _cancelShadow.layer.shadowRadius = 4;
    _cancelShadow.layer.shadowOpacity = 0.2;
    _cancelShadow.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _cancelShadow;
}


@end
