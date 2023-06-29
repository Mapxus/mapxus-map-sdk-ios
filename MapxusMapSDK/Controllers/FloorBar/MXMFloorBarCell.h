//
//  MXMFloorBarCell.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXMFloorBarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMFloorBarCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *badgeView;

+ (NSString *)cellIdentifier;
- (void)refresh:(MXMFloorBarModel *)data;

@end

NS_ASSUME_NONNULL_END
