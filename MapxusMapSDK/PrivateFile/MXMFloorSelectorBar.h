//
//  MXMFloorSelectorBar.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXMFloorSelectorBarDelegate <NSObject>
- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName;
@end

@interface MXMFloorSelectorBar : UIView

@property (nonatomic, weak) id<MXMFloorSelectorBarDelegate> delegate;

- (void)selectRow:(NSString *)selectRow;
- (void)resetItems:(NSArray<NSString *> *)items defaultSelectRow:(NSString *)defaultSelectRow;

@end
