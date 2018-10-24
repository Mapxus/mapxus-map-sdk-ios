//
//  MXMDefine.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/9/28.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#ifndef MXMDefine_h
#define MXMDefine_h

/**
 MapxusMap地图外观
 */
typedef NS_ENUM(NSUInteger, MXMStyle) {
    /**
     默认类型
     */
    MXMStyleCOMMON,
    /**
     圣诞节风格
     */
    MXMStyleCHRISTMAS,
    /**
     万圣节风格
     */
    MXMStyleHALLOWMAS,
    /**
     MAPPYBEE风格
     */
    MXMStyleMAPPYBEE,
    /**
     蒂芙尼蓝风格
     */
    MXMStyleMAPXUS,
};



/**
 楼层控制器位置
 */
typedef NS_ENUM(NSInteger, MXMSelectorPosition) {
    /**
     楼层控制器在左边
     */
    MXMSelectorPositionCenterLeft,
    /**
     楼层控制器在右边
     */
    MXMSelectorPositionCenterRight,
    /**
     楼层控制器在左下角
     */
    MXMSelectorPositionBottomLeft,
    /**
     楼层控制器在右下角
     */
    MXMSelectorPositionBottomRight,
    /**
     楼层控制器在左上角
     */
    MXMSelectorPositionTopLeft,
    /**
     楼层控制器在右上角
     */
    MXMSelectorPositionTopRight,
};


#endif /* MXMDefine_h */
