//
//  MXMFloorSelectorBar.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar+Private.h"
#import "NSString+Compare.h"
#import "MXMPickerView.h"



@interface CellView : UIView
@property (nonatomic, strong) UILabel *cellLabel;
@end

@implementation CellView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cellLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cellLabel.frame = self.bounds;
}

- (UILabel *)cellLabel
{
    if (!_cellLabel) {
        _cellLabel = [[UILabel alloc] init];
        _cellLabel.backgroundColor = [UIColor clearColor];
        _cellLabel.textAlignment = NSTextAlignmentCenter;
        _cellLabel.font = [UIFont systemFontOfSize:28];
        _cellLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _cellLabel;
}

@end




@interface MXMFloorSelectorBar () <MXMPickerViewDataSource, MXMPickerViewDelegate>//, UIPickerViewAccessibilityDelegate>
@property (nonatomic, strong) MXMPickerView *pickerView;
@property (nonatomic, strong) UIView *selectBox;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation MXMFloorSelectorBar


//#pragma mark - UIPickerViewAccessibilityDelegate
//- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
//{
//    NSString *name = @"";
//    if (![NSString isEmpty:self.addVoiceOverLabel]) {
//        name = self.addVoiceOverLabel;
//    }
//    return name;
//}
//#pragma mark end

+ (void)initialize {
    [MXMFloorSelectorBar appearance].selectFontColor = [UIColor blackColor];
    [MXMFloorSelectorBar appearance].selectBoxColor = [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];
    [MXMFloorSelectorBar appearance].fontColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
}

- (void)initialization {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2;
    [self addSubview:self.selectBox];
    [self addSubview:self.pickerView];
    self.pickerView.forceItemTypeText = NO;
//    self.pickerView.selectedTextColor = self.selectFontColor;
//    self.pickerView.textColor = self.fontColor;
//    self.pickerView.font = [UIFont systemFontOfSize:28];
    self.pickerView.selectionIndicatorStyle = MXMPickerViewSelectionIndicatorStyleNone;
    [self.pickerView reloadAllComponents];
}

- (void)selectRow:(NSString *)selectRow
{
    if ([self.dataSourceArr containsObject:selectRow]) {
        [self resetItems:nil defaultSelectRow:selectRow];
    }
}

- (void)resetItems:(NSArray<NSString *> *)items defaultSelectRow:(NSString *)defaultSelectRow
{
    if (items) {
        [self.dataSourceArr removeAllObjects];
        [self.dataSourceArr addObjectsFromArray:items];
        [self.pickerView reloadAllComponents];
    }
    NSInteger r = 0;
    if (defaultSelectRow) {
        r = [self.dataSourceArr indexOfObject:defaultSelectRow];
    }
    self.selectedRow = r;
    [self.pickerView selectRow:r inComponent:0 animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectBox.frame = CGRectMake(0, (self.bounds.size.height-44)/2, self.bounds.size.width, 44);
    self.pickerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    // 优化以去除离屏渲染
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}


#pragma mark - MXMPickerViewDataSource, MXMPickerViewDelegate

- (UIView *_Nonnull)pickerView:(MXMPickerView *_Nonnull)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    NSString *name = @"";
    if (self.dataSourceArr.count > row) {
        name = self.dataSourceArr[row];
    }
    CellView *aView = (CellView *)view;
    if (aView == nil) {
        aView = [[CellView alloc] init];
    }
    aView.cellLabel.text = name;
    aView.cellLabel.textColor = (self.selectedRow == row) ? self.selectFontColor : self.fontColor;
    return aView;
}

- (void)pickerView:(MXMPickerView *)pickerView willSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CellView *label = (CellView *)[pickerView viewForRow:row forComponent:component];
    label.cellLabel.textColor = self.selectFontColor;
}

- (void)pickerView:(MXMPickerView *)pickerView willDeselectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CellView *label = (CellView *)[pickerView viewForRow:row forComponent:component];
    label.cellLabel.textColor = self.fontColor;
}

//- (NSString *)pickerView:(MXMPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *name = @"";
//    if (self.dataSourceArr.count > row) {
//        name = self.dataSourceArr[row];
//    }
//    return name;
//}

- (NSInteger)numberOfComponentsInPickerView:(MXMPickerView *_Nonnull)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(MXMPickerView *_Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSourceArr.count;
}

- (void)pickerView:(MXMPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
    NSString *name = @"";
    if (self.dataSourceArr.count > row) {
        name = self.dataSourceArr[row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(floorSelectorBarDidSelectFloor:)]) {
        [self.delegate floorSelectorBarDidSelectFloor:name];
    }
}

- (CGFloat)pickerView:(MXMPickerView *)pickerView widthRatioForComponent:(NSInteger)component {
    return 1;
}

- (CGFloat)pickerView:(MXMPickerView *_Nonnull)pickerView rowHeightForComponent:(NSInteger)component
{
    return 42;
}
#pragma mark end


#pragma mark - access
- (MXMPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[MXMPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor clearColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)selectBox
{
    if (!_selectBox) {
        _selectBox = [[UIView alloc] init];
    }
    return _selectBox;
}

- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (void)setSelectFontColor:(UIColor *)selectFontColor {
    _selectFontColor = selectFontColor;
    if (_pickerView) {
        [_pickerView reloadAllComponents];
    }
}

- (void)setSelectBoxColor:(UIColor *)selectBoxColor {
    _selectBoxColor = selectBoxColor;
    if (_selectBox) {
        _selectBox.backgroundColor = selectBoxColor;
    }
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    if (_pickerView) {
        [_pickerView reloadAllComponents];
    }
}
#pragma mark end

@end
