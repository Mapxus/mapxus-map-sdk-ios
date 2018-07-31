//
//  MXMFloorSelectorBar.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar.h"


@interface CellView : UIView
@property (nonatomic, strong) UILabel *cellLabel;
@end

@implementation CellView

- (instancetype)init
{
    self = [super init];
    if (self) {
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
        _cellLabel.textAlignment = NSTextAlignmentCenter;
        _cellLabel.font = [UIFont systemFontOfSize:13];
        _cellLabel.adjustsFontSizeToFitWidth = YES;
        _cellLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
    }
    return _cellLabel;
}
@end

@interface MXMFloorSelectorBar () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@end

@implementation MXMFloorSelectorBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.pickerView];
        [self.pickerView reloadAllComponents];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
    self.pickerView.frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height-20);
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
    return 43;
}
#pragma mark end


#pragma mark - access
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
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
