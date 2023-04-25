//
//  MXMLogoButton.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMLogoButton : UIButton
@property (nonatomic, assign) BOOL collapseCopyright;

- (instancetype)initWithCopyright:(BOOL)collapseCopyright;
@end

NS_ASSUME_NONNULL_END
