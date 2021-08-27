//
//  MXMFloorSelectorBar.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Floor selector
 */
@interface MXMFloorSelectorBar : UIView

/// Floor selector voice-over
@property (nonatomic, copy, nullable) NSString *addVoiceOverLabel DEPRECATED_MSG_ATTRIBUTE("Please use \"accessibilityLabel\" to instead");

/// Select font colour
@property (nonatomic, strong) UIColor *selectFontColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

/// Checkbox colour
@property (nonatomic, strong) UIColor *selectBoxColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];

/// Font colour
@property (nonatomic, strong) UIColor *fontColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];

@end

NS_ASSUME_NONNULL_END
