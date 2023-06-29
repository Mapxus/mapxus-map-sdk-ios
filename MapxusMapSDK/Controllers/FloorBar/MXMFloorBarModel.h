//
//  MXMFloorBarModel.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/6/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMFloorBarModel : NSObject

@property (nonatomic, strong) MXMFloor *floor;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL located;

@end

NS_ASSUME_NONNULL_END
