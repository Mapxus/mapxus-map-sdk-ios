//
//  MXMBuildingSelectorButton.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/2/3.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXMSceneControlProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMBuildingSelectorButton : UIButton <MXMBuildingSelectorRenderingDelegate>

@property (nonatomic, weak) id<MXMBuildingSelectorDelegate> mxmDelegate;
- (void)refreshBuildingList:(NSArray<MXMGeoBuilding *> *)list;
- (void)selectedBuildig:(MXMGeoBuilding *)building;
- (void)setSelectorHidden:(BOOL)isHidden;

- (void)updateConstraintsList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
