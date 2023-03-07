//
//  MXMFloorSelectorBar+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/12/29.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar.h"
#import "MXMCommonObj.h"


@protocol MXMFloorSelectorBarDelegate <NSObject>
- (void)floorSelectorBarDidSelectFloor:(MXMFloor *)floor floorNameFromBuilding:(BOOL)isBuilding;
@end

@interface MXMFloorSelectorBar ()

@property (nonatomic, weak) id<MXMFloorSelectorBarDelegate> delegate;
@property (nonatomic, assign) BOOL floorNameFromBuilding;

- (void)selectRow:(MXMFloor *)floor;
- (void)resetItems:(NSArray<MXMFloor *> *)items defaultSelectRow:(MXMFloor *)defaultFloor;

@end

