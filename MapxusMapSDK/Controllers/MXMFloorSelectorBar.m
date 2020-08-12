//
//  MXMFloorSelectorBar.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar+Private.h"
#import "NSString+Compare.h"


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
        _cellLabel.textColor = [UIColor blackColor];
    }
    return _cellLabel;
}
@end

@interface MXMFloorSelectorBar () <UIPickerViewDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *selectBox;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@end

@implementation MXMFloorSelectorBar


#pragma mark - UIPickerViewAccessibilityDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    NSString *name = @"";
    if (![NSString isEmpty:self.addVoiceOverLabel]) {
        name = self.addVoiceOverLabel;
    }
    return name;
}
#pragma mark end

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 2;
        [self addSubview:self.selectBox];
        [self addSubview:self.pickerView];
        [self.pickerView reloadAllComponents];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 2;
    [self addSubview:self.selectBox];
    [self addSubview:self.pickerView];
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
    [self.pickerView selectRow:r inComponent:0 animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectBox.frame = CGRectMake(0, (self.bounds.size.height-44)/2, self.bounds.size.width, 44);
    self.pickerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    if (@available(iOS 14.0, *)) {
        // iOS 14设置UIPickerView选中蒙层的x和width
        for (UIView *v in self.pickerView.subviews) {
            [self resetViewXAndWidthEqualWithSelf:v];
        }
        // iOS 14查找并设置UIPickerView的子View UIPickerColumnView的frame
        UIView *v = [self getSubViewWithClassName:@"UIPickerColumnView" inView:self.pickerView];
        v.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        // 在UIPickerColumnView下两层subView设置宽度
        for (UIView *subView in v.subviews) {
            [self resetViewXAndWidthEqualWithSelf:subView];
            for (UIView *ssubView in subView.subviews) {
                [self resetViewXAndWidthEqualWithSelf:ssubView];
            }
        }
        
    }
}

- (void)resetViewXAndWidthEqualWithSelf:(UIView *)view {
    CGRect rect = view.frame;
    if ((rect.origin.x != 0) || (rect.size.width != self.bounds.size.width)) {
        rect.origin.x = 0;
        rect.size.width = self.bounds.size.width;
        view.frame = rect;
    }
}

//如果找到了就返回找到的view，没找到的话，就返回nil
- (UIView *)getSubViewWithClassName:(NSString *)className inView:(UIView *)inView {
    //判空处理
    if( !inView  ||  !inView.subviews.count ||  !className.length) return nil;
    //最终找到的view，找不到的话，就直接返回一个nil
    UIView*foundView =nil;
    //循环递归进行查找
    for(UIView *view in inView.subviews) {
        //如果view是当前要查找的view，就直接赋值并终止循环递归，最终返回
        if([view isKindOfClass:NSClassFromString(className)]) {
            foundView = view;
            break;
        }
        //如果当前view不是要查找的view的话，就在递归查找当前view的subviews
        foundView = [self getSubViewWithClassName:className inView:view];
        //如果找到了，则终止循环递归，最终返回
        if (foundView) break;
    }
    return foundView;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *name = @"";
    if (self.dataSourceArr.count > row) {
        name = self.dataSourceArr[row];
    }
    CellView *aView = [[CellView alloc] init];
    aView.cellLabel.text = name;
    return aView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSourceArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *name = @"";
    if (self.dataSourceArr.count > row) {
        name = self.dataSourceArr[row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(floorSelectorBarDidSelectFloor:)]) {
        [self.delegate floorSelectorBarDidSelectFloor:name];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 42;
}
#pragma mark end


#pragma mark - access
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
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
        _selectBox.backgroundColor = [UIColor colorWithRed:0.29 green:0.69 blue:0.83 alpha:1];
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
#pragma mark end

@end
