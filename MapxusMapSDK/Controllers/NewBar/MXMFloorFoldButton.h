//
//  MXMFloorFoldButton.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXMFloorBarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMFloorFoldButton : UIButton

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *badgeView;

- (void)setFloorBarModel:(MXMFloorBarModel *)model;

@end

NS_ASSUME_NONNULL_END
