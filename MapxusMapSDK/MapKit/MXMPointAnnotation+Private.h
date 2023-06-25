//
//  MXMPointAnnotation+Private.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/19.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPointAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMPointAnnotation ()

@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, copy, nullable) void (^sceneRefreshBlock)( NSString * _Nullable buildingId, NSString * _Nullable floor, NSString * _Nullable floorId); // 在 annotation 的楼层有变更时调用的 block

@end

NS_ASSUME_NONNULL_END
