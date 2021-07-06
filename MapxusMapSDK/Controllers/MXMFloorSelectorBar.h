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
 * 楼层选择器
 */
@interface MXMFloorSelectorBar : UIView

/// 楼层选择器旁白
@property (nonatomic, copy, nullable) NSString *addVoiceOverLabel DEPRECATED_MSG_ATTRIBUTE("Please use \"accessibilityLabel\" to instead");

/// 选中字体颜色
@property (nonatomic) UIColor *selectFontColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

/// 选中框颜色
@property (nonatomic) UIColor *selectBoxColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];

/// 字体颜色
@property (nonatomic) UIColor *fontColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];

@end

NS_ASSUME_NONNULL_END
