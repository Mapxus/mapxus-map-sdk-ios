//
//  MXMFloorSelectorBar.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar+Private.h"
#import "MXMFloorBarCell.h"
#import "MXMFloorBarHeaderFooterView.h"
#import "UIImage+MXMSdk.h"
#import "JXJsonFunctionDefine.h"
#import "MXMSDKBundle.h"

static CGFloat cellHeight = 50.0;
static CGFloat cellWidth = 50.0;
static CGFloat headerFooterHeight = 35.0;


@implementation MXMFloorSelectorBar

+ (void)initialize {
  [MXMFloorSelectorBar appearance].selectFontColor = MXMRGBHex(0xFFFFFF);
  [MXMFloorSelectorBar appearance].selectBoxColor = MXMRGBHex(0x074769);
  [MXMFloorSelectorBar appearance].fontColor = MXMRGBHex(0x8C8C8C);
  [MXMFloorSelectorBar appearance].boxColor = MXMRGBHex(0xFFFFFF);
  [MXMFloorSelectorBar appearance].locationPointColor = MXMRGBHex(0x2073EC);
  [MXMFloorSelectorBar appearance].cornerRadius = 8;
  [MXMFloorSelectorBar appearance].maxVisibleFloors = 5;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initialization];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initialization];
}

- (void)initialization {
  self.accessibilityLabel = MXMLocalizedString(@"Level switcher");
  self.backgroundColor = [UIColor clearColor];
  
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowRadius = 2;
  self.layer.shadowOffset = CGSizeMake(2, 2);
  self.layer.shadowOpacity = 0.4;
  
  self.isFolded = NO;
  [self configSubviews];
}

- (void)refershList:(NSArray<MXMFloorBarModel *> *)models refBuildingId:(NSString *)buildingId {
  self.refBuildingId = buildingId;
  self.dataList = models;
  self.tableHeight.constant = [self getTableViewHeight];
  [self.tableView reloadData];
  for (MXMFloorBarModel *model in models) {
    if (model.selected) {
      NSUInteger index = [models indexOfObject:model];
      [self moveCellToVisibleArea:index];
      break;
    }
  }
  if (@available(iOS 13.0, *)) {
    // 系统版本是13.0或更高
  } else {
    // 系统版本低于13.0
    // 防止在iOS12.5.7系统中，更新列表后的cell错位
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (self.dataList.count > 0 &&
          self.dataList.count <= self.maxVisibleFloors) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
      }
    });
  }
}

- (void)selectFloorIndex:(NSUInteger)index {
  self.selectedRow = index;
  for (MXMFloorBarModel *model in self.dataList) {
    model.selected = NO;
  }
  if (index < self.dataList.count) {
    MXMFloorBarModel *model = self.dataList[index];
    model.selected = YES;
    [self.floorFoldButton setFloorBarModel:model];
  }
  [self.tableView reloadData];
  [self moveCellToVisibleArea:index];
}

//标记楼层
- (void)localOnFloorIndex:(NSUInteger)index {
  for (MXMFloorBarModel *model in self.dataList) {
    model.located = NO;
  }
  if (index < self.dataList.count) {
    MXMFloorBarModel *model = self.dataList[index];
    model.located = YES;
  }
  [self.tableView reloadData];
}

- (void)moveCellToVisibleArea:(NSUInteger)index {
  // 防止在iOS12.5.7系统中，点击列表时不断跳动
  if (self.dataList.count <= self.maxVisibleFloors) {
    return;
  }
  
  // 防止越界
  if (index >= 0 && index < self.dataList.count) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    if (CGRectIsEmpty(cellRect)) {
      return;
    }
    
    // 在不可视范围才跳转
    if ((self.tableView.contentOffset.y > cellRect.origin.y - headerFooterHeight) ||
        (self.tableView.contentOffset.y + self.tableView.frame.size.height - cellRect.size.height - headerFooterHeight * 2 < cellRect.origin.y)) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.row < [self.tableView numberOfRowsInSection:indexPath.section]) {
          [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
      });
    }
  }
}

- (CGFloat)getTableViewHeight {
  CGFloat height = 0;
  if (self.dataList.count > self.maxVisibleFloors) {
    height += 2 * 35;
    height += self.maxVisibleFloors * cellHeight;
  } else {
    height += self.dataList.count * cellHeight;
  }
  return height;
}

- (void)clickOnCancelButton {
  self.isFolded = YES;
}

- (void)clickOnFoldButton {
  self.isFolded = NO;
}

#pragma mark - Accessibility

//- (BOOL)isAccessibilityElement {
//  return YES;
//}
//
//- (UIAccessibilityTraits)accessibilityTraits {
//  return UIAccessibilityTraitAdjustable|UIAccessibilityTraitAllowsDirectInteraction;
//}
//
//- (void)accessibilityIncrement {
//  if (self.selectedRow > 0) {
//    NSInteger r = self.selectedRow - 1;
//    [self selectFloorIndex:r];
//  }
//}
//
//- (void)accessibilityDecrement {
//  if (self.selectedRow < self.dataList.count-1) {
//    NSInteger r = self.selectedRow + 1;
//    [self selectFloorIndex:r];
//  }
//}
//
//- (void)updateAccessibilityValueWithRowString:(NSString *)rowString {
//    NSUInteger c = self.dataList.count;
//    NSUInteger t = self.selectedRow + 1;
//    NSString *valueFormat = MXMLocalizedString(@"%1$@, %2$lu of %3$lu");
//    self.accessibilityValue = [NSString stringWithFormat:valueFormat, rowString, (unsigned long)t, (unsigned long)c];
//}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MXMFloorBarCell *cell = [tableView dequeueReusableCellWithIdentifier:[MXMFloorBarCell cellIdentifier]];
  if (!cell) {
    cell = [[MXMFloorBarCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:[MXMFloorBarCell cellIdentifier]];
  }
  if (indexPath.row < self.dataList.count) {
    MXMFloorBarModel *model = self.dataList[indexPath.row];
    cell.contentView.backgroundColor = model.selected ? self.selectBoxColor : self.boxColor;
    cell.nameLabel.textColor = model.selected ? self.selectFontColor : self.fontColor;
    cell.badgeView.backgroundColor = self.locationPointColor;
    [cell refresh:model];
  }
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.dataList.count > self.maxVisibleFloors) {
    MXMFloorBarHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MXMFloorBarHeaderFooterView headerFooterIdentifier]];
    view.contentView.backgroundColor = self.boxColor;
    [view useArrowImageViewUp:YES];
    return view;
  }
  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (self.dataList.count > self.maxVisibleFloors) {
    MXMFloorBarHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MXMFloorBarHeaderFooterView headerFooterIdentifier]];
    view.contentView.backgroundColor = self.boxColor;
    [view useArrowImageViewUp:NO];
    return view;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.dataList.count > self.maxVisibleFloors) {
    return headerFooterHeight;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (self.dataList.count > self.maxVisibleFloors) {
    return headerFooterHeight;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return  self.dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // 如果选中行已经和回调的一致，则回调不传递出去
  if (self.selectedRow == indexPath.row) {
    return;
  }
  [self selectFloorIndex:indexPath.row];
  if (indexPath.row < self.dataList.count) {
    MXMFloorBarModel *model = self.dataList[indexPath.row];
    //    [self updateAccessibilityValueWithRowString:model.floor.code];
    if (self.delegate && [self.delegate respondsToSelector:@selector(floorSelectorBarDidSelectFloor:)]) {
      [self.delegate floorSelectorBarDidSelectFloor:model.floor];
    }
  }
}

#pragma mark - setter

- (void)setIsFolded:(BOOL)isFolded {
  _isFolded = isFolded;
  self.cancelButton.hidden = isFolded;
  self.tableView.hidden = isFolded;
  self.floorFoldButton.hidden = !isFolded;
}

- (void)setSelectFontColor:(UIColor *)selectFontColor {
  _selectFontColor = selectFontColor;
  if (_tableView) {
    [_tableView reloadData];
  }
  if (_floorFoldButton) {
    _floorFoldButton.nameLabel.textColor = selectFontColor;
  }
}

- (void)setSelectBoxColor:(UIColor *)selectBoxColor {
  _selectBoxColor = selectBoxColor;
  if (_tableView) {
    [_tableView reloadData];
  }
  if (_floorFoldButton) {
    _floorFoldButton.backgroundColor = selectBoxColor;
  }
}

- (void)setFontColor:(UIColor *)fontColor {
  _fontColor = fontColor;
  if (_tableView) {
    [_tableView reloadData];
  }
}

- (void)setBoxColor:(UIColor *)boxColor {
  _boxColor = boxColor;
  if (_tableView) {
    [_tableView reloadData];
  }
}

- (void)setLocationPointColor:(UIColor *)locationPointColor {
  _locationPointColor = locationPointColor;
  if (_tableView) {
    [_tableView reloadData];
  }
  if (_floorFoldButton) {
    _floorFoldButton.badgeView.backgroundColor = locationPointColor;
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  if (_floorFoldButton) {
    _floorFoldButton.layer.cornerRadius = cornerRadius;
  }
  if (_tableView) {
    _tableView.layer.cornerRadius = cornerRadius;
  }
}

- (void)setMaxVisibleFloors:(NSUInteger)maxVisibleFloors {
  _maxVisibleFloors = maxVisibleFloors;
  self.tableHeight.constant = [self getTableViewHeight];
  if (_tableView) {
    [_tableView reloadData];
  }
}



#pragma mark - UI Create

- (void)configSubviews {
  [self addSubview:self.stackView];
  [self.stackView addArrangedSubview:self.cancelButton];
  [self.stackView addArrangedSubview:self.tableView];
  [self.stackView addArrangedSubview:self.floorFoldButton];
  
  self.tableHeight = [self.tableView.heightAnchor constraintEqualToConstant:[self getTableViewHeight]];
  
  NSArray *layouts = @[
    [self.cancelButton.heightAnchor constraintEqualToConstant:44],
    self.tableHeight,
    [self.floorFoldButton.heightAnchor constraintEqualToConstant:cellHeight],
    [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    [self.stackView.widthAnchor constraintEqualToConstant:cellWidth]
  ];
  
  [NSLayoutConstraint activateConstraints:layouts];
}

- (UIStackView *)stackView {
  if (!_stackView) {
    _stackView = [[UIStackView alloc] init];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.spacing = 5;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _stackView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = self.cornerRadius;
    _tableView.bounces = NO;
    _tableView.clipsToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
      _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
      // Fallback on earlier versions
    }
    if (@available(iOS 15.0, *)) {
      _tableView.sectionHeaderTopPadding = 0;
    }
    [_tableView registerClass:[MXMFloorBarCell class] forCellReuseIdentifier:[MXMFloorBarCell cellIdentifier]];
    [_tableView registerClass:[MXMFloorBarHeaderFooterView class]
forHeaderFooterViewReuseIdentifier:[MXMFloorBarHeaderFooterView headerFooterIdentifier]];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _tableView;
}

- (UIButton *)cancelButton {
  if (!_cancelButton) {
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setImage:[UIImage getMXMSdkImage:@"floorbar_cancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(clickOnCancelButton) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _cancelButton;
}

- (MXMFloorFoldButton *)floorFoldButton {
  if (!_floorFoldButton) {
    _floorFoldButton = [[MXMFloorFoldButton alloc] init];
    [_floorFoldButton addTarget:self action:@selector(clickOnFoldButton) forControlEvents:UIControlEventTouchUpInside];
    _floorFoldButton.translatesAutoresizingMaskIntoConstraints = NO;
    _floorFoldButton.layer.cornerRadius = self.cornerRadius;
  }
  return _floorFoldButton;
}
@end
