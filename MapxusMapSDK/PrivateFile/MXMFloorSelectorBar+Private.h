//
//  MXMFloorSelectorBar+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/12/29.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMFloorSelectorBar.h"


@protocol MXMFloorSelectorBarDelegate <NSObject>
- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName;
@end

@interface MXMFloorSelectorBar ()

@property (nonatomic, weak) id<MXMFloorSelectorBarDelegate> delegate;

- (void)selectRow:(NSString *)selectRow;
- (void)resetItems:(NSArray<NSString *> *)items defaultSelectRow:(NSString *)defaultSelectRow;

@end

