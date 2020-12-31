//
//  MXMPickerView.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2020/12/30.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPickerView.h"

@implementation MXMPickerView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self relayoutSubviews];
}

- (void)relayoutSubviews {
    if (!@available(iOS 14.0, *)) {
        return;
    }
    
    // iOS 14设置UIPickerView选中蒙层的x和width
    for (UIView *v in self.subviews) {
        [self resetViewXAndWidthEqualWithSelf:v];
    }
    // iOS 14查找并设置UIPickerView的子View UIPickerColumnView的frame
    UIView *v = [self getSubViewWithClassName:@"UIPickerColumnView" inView:self];
    v.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    // 在UIPickerColumnView下两层subView设置宽度
    for (UIView *subView in v.subviews) {
        [self resetViewXAndWidthEqualWithSelf:subView];
        for (UIView *ssubView in subView.subviews) {
            [self resetViewXAndWidthEqualWithSelf:ssubView];
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

@end
