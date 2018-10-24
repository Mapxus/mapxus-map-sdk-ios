//
//  MXMPointAnnotation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

/**
 室内专用Annotation
 */
@interface MXMPointAnnotation : MGLPointAnnotation

/// annotation所在楼层
@property (nonatomic, strong) NSString *floor;

/// annotation所在建筑的id
@property (nonatomic, strong) NSString *buildingId;

@end
