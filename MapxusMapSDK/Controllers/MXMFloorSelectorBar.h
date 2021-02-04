//
//  MXMFloorSelectorBar.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXMSceneControlProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 楼层选择器
 */
@interface MXMFloorSelectorBar : UIView <MXMFloorSelectorRenderingDelegate>

@property (nonatomic, weak) id<MXMFloorSelectorDelegate> mxmDelegate;
- (void)selectedBuilding:(MXMGeoBuilding *)building floor:(NSString *)floorName;
- (void)setSelectorHidden:(BOOL)isHidden;

/// 楼层选择器旁白
@property (nonatomic, copy, nullable) NSString *addVoiceOverLabel;

/// 选中框颜色
@property (nonatomic) UIColor *selectBoxColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];

@property (nonatomic) UIColor *barBackgroundColor UI_APPEARANCE_SELECTOR; //default [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];

@property (nonatomic) UIColor *activeFontColor UI_APPEARANCE_SELECTOR;
/// 字体颜色
@property (nonatomic) UIColor *fontColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

- (void)updateConstraintsList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
