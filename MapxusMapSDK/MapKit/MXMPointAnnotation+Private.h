//
//  MXMPointAnnotation+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/19.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPointAnnotation.h"

@interface MXMPointAnnotation ()

@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, copy) void (^sceneRefreshBlock)(NSString *buildingId, NSString *floor); // 在 annotation 的楼层有变更时调用的 block

@end
