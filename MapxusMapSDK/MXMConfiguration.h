//
//  MXMConfiguration.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMDefine.h"

/**
 MapxusMap初始化配置，优先级由上往下减弱
 */
@interface MXMConfiguration : NSObject

@property (nonatomic) MXMStyle defaultStyle;

@property (nonatomic, copy) NSString *buildingId;
@property (nonatomic, copy) NSString *floor;

@property (nonatomic, copy) NSString *poiId;

@end
