//
//  MXMFloorBarHeaderFooterView.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMFloorBarHeaderFooterView : UITableViewHeaderFooterView

+ (NSString *)headerFooterIdentifier;
- (void)useArrowImageViewUp:(BOOL)up;

@end

NS_ASSUME_NONNULL_END
