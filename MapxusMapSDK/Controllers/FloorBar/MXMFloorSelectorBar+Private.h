//
//  MXMFloorSelectorBar+Private.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/16.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#ifndef MXMFloorSelectorBar_Private_h
#define MXMFloorSelectorBar_Private_h

#import <MapxusMapSDK/MXMFloorSelectorBar.h>
#import <MapxusMapSDK/MXMCommonObj.h>
#import "MXMFloorBarModel.h"
#import "MXMFloorFoldButton.h"

@protocol MXMFloorSelectorBarDelegate <NSObject>
- (void)floorSelectorBarDidSelectFloor:(MXMFloor *)floor;
@end

@interface MXMFloorSelectorBar () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) MXMFloorFoldButton *floorFoldButton;

@property (nonatomic, strong) NSLayoutConstraint *tableHeight;
@property (nonatomic, strong) NSArray<MXMFloorBarModel *> *dataList;
@property (nonatomic, strong) NSString *refBuildingId;
@property (nonatomic, weak) id<MXMFloorSelectorBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedRow;

- (void)refershList:(NSArray<MXMFloorBarModel *> *)models refBuildingId:(NSString *)buildingId;
- (void)selectFloorIndex:(NSUInteger)index;
- (void)localOnFloorIndex:(NSUInteger)index;

/**
 
 */
@property (nonatomic, strong) UIColor *locationPointColor UI_APPEARANCE_SELECTOR;

@end


#endif /* MXMFloorSelectorBar_Private_h */
