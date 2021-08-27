//
//  MXMPickerView.h
//  MXMPickerView
//
//  Created by XuQibin on 2017/6/19.
//  Copyright © 2017年 Standards. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MXMPickerViewDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use '" # instead "' instead")

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,MXMPickerViewSelectionIndicatorStyle) {
    MXMPickerViewSelectionIndicatorStyleNone = 0,
    MXMPickerViewSelectionIndicatorStyleDefault,
    MXMPickerViewSelectionIndicatorStyleDivision,
    MXMPickerViewSelectionIndicatorStyleCustom,
};

@protocol MXMPickerViewDataSource,MXMPickerViewDelegate;

@interface MXMPickerView : UIView

@property(nullable, nonatomic, weak) id<MXMPickerViewDataSource> dataSource;                // default is nil. weak reference
@property(nullable, nonatomic, weak) id<MXMPickerViewDelegate>   delegate;                  // default is nil. weak reference

@property (assign, nonatomic) BOOL forceItemTypeText;

@property(assign, nonatomic) MXMPickerViewSelectionIndicatorStyle   selectionIndicatorStyle;   // default is MXMPickerViewSelectionIndicatorStyleDefault

@property(assign, nonatomic) BOOL showVerticalDivisionLine;

@property (strong, nonatomic) UIColor *selectionIndicatorLineColor;

//go into effect when itemType == MXMPickerViewItemTypeText
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@property (assign, nonatomic) CGFloat spacingOfComponents;//go into effect when components > 1

// info that was fetched and cached from the data source and delegate
@property(nonatomic, readonly) NSInteger numberOfComponents;
- (NSInteger)numberOfRowsInComponent:(NSInteger)component;
- (CGSize)rowSizeForComponent:(NSInteger)component;

// returns the view provided by the delegate via pickerView:viewForRow:forComponent:reusingView:
// or nil if the row/component is not visible or the delegate does not implement
// pickerView:viewForRow:forComponent:reusingView:
- (nullable UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component;

// Reloading whole view or single component
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;

// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;  // scrolls the specified row to center.

- (NSInteger)selectedRowInComponent:(NSInteger)component;                                   // returns selected row. -1 if nothing selected

@end

@protocol MXMPickerViewDataSource<NSObject>
@required

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(MXMPickerView *_Nonnull)pickerView;

// returns the number of rows in each component.
- (NSInteger)pickerView:(MXMPickerView *_Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component;

@optional
//high priority, this method return a view (e.g UILabel) to display the row for the component.
- (UIView *_Nonnull)pickerView:(MXMPickerView *_Nonnull)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;

//low priority, this method return a plain NSString to display the row for the component.
- (nullable NSString *)pickerView:(MXMPickerView *_Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@protocol MXMPickerViewDelegate<NSObject>
@optional

// returns custom selection indicator view when selectionIndicatorStyle =  MXMPickerViewSelectionIndicatorStyleCustom.
- (UIView *_Nonnull)selectionIndicatorViewForPickerView:(MXMPickerView *_Nonnull)pickerView;

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(MXMPickerView *_Nonnull)pickerView widthRatioForComponent:(NSInteger)component;

- (CGFloat)pickerView:(MXMPickerView *_Nonnull)pickerView rowHeightForComponent:(NSInteger)component;

- (void)pickerView:(MXMPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)pickerView:(MXMPickerView *_Nonnull)pickerView willSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)pickerView:(MXMPickerView *_Nonnull)pickerView willDeselectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)pickerView:(MXMPickerView *_Nonnull)pickerView didScroll:(CGPoint)contentOffset inComponent:(NSInteger)component;

@end

NS_ASSUME_NONNULL_END
