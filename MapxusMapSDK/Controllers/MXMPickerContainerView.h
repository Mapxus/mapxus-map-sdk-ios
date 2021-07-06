//
//  MXMPickerScrollView.h
//  MXMPickerView
//
//  Created by XuQibin on 2017/10/24.
//  Copyright © 2017年 Standards. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXMPickerContainerView;

@protocol MXMPickerContainerViewDateSource <NSObject>

- (NSInteger)numberOfRowsInContainerView:(MXMPickerContainerView *)containerView;

- (UIView *)containerView:(MXMPickerContainerView *)containerView viewForRow:(NSInteger)row reusingView:(UIView *)view;

@end

@protocol MXMPickerContainerViewDelegate <NSObject>

@optional
- (void)containerView:(MXMPickerContainerView *)containerView willSelectRow:(NSUInteger)row;

- (void)containerView:(MXMPickerContainerView *)containerView willDeselectRow:(NSUInteger)row;

- (void)containerView:(MXMPickerContainerView *)containerView didSelectRow:(NSUInteger)row;

- (void)containerViewDidScroll:(MXMPickerContainerView *)containerView;

@end

@interface MXMPickerContainerView : UIView

@property (weak, nonatomic) id<MXMPickerContainerViewDelegate> delegate;

@property (weak, nonatomic) id<MXMPickerContainerViewDateSource> dateSource;

@property (assign, nonatomic) NSUInteger rowHeight;

@property (assign, nonatomic) CGPoint contentOffset;  // default CGPointZero

// info that was fetched and cached from the data source and delegate
@property(assign, readonly, nonatomic) NSInteger numberOfRows;
@property(assign, readonly, nonatomic) NSInteger selectedRow;

@property(strong, readonly, nonatomic) NSArray *visibleItemViews;

- (CGSize)sizeForRow:(NSInteger)row;
- (UIView *)viewForRow:(NSInteger)row;
- (NSInteger)rowForView:(UIView *)view;
- (CGRect)viewRectForRow:(NSInteger)row;

- (void)reloadData;
- (void)reloadDataWithoutLayout;

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;  // scrolls the specified row to center.

@end


@interface MXMPickerContainerCell : UICollectionViewCell

@property (strong, nonatomic) UIView *customView;

@end

