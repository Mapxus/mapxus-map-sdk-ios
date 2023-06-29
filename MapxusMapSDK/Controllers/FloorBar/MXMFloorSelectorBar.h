//
//  MXMFloorSelectorBar.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MXMFloorSelectorBar : UIView

/**
 Floor selector bar folded state.
 
 When the floor selector needs to be folded, set to YES, otherwise set to NO, the default value is NO.
 */
@property (nonatomic, assign) BOOL isFolded;

/**
 The font color that indicates the selected floor on the floor selector bar.
 
 Default color is 0xFFFFFF.
 */
@property (nonatomic, strong) UIColor *selectFontColor UI_APPEARANCE_SELECTOR;

/**
 The box color that indicates the selected floor on the floor selector bar.
 
 Default color is 0x074769.
 */
@property (nonatomic, strong) UIColor *selectBoxColor UI_APPEARANCE_SELECTOR;

/**
 The font color that indicates the unselected floor on the floor selector bar.
 
 Default color is 0x8C8C8C.
 */
@property (nonatomic, strong) UIColor *fontColor UI_APPEARANCE_SELECTOR;

/**
 The box color that indicates the unselected floor on the floor selector bar.
 
 Default color is 0xFFFFFF.
 */
@property (nonatomic, strong) UIColor *boxColor UI_APPEARANCE_SELECTOR;

/**
 Rounded corner radius of floor selector bar.
 
 The default radius is 8.
 */
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 Maximum number of visible floors for floor selector bar.
 
 The default number is 5.
 */
@property (nonatomic, assign) NSUInteger maxVisibleFloors UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
