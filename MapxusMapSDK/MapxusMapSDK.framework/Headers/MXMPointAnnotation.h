//
//  MXMPointAnnotation.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>

@interface MXMPointAnnotation : MGLPointAnnotation

@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *buildingId;

@end
