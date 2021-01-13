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
     MAPXUSMAP_v2风格
     */
    MXMStyleMAPXUS_V2,
    /**
     MAPXUSMAP风格
     */
    MXMStyleMAPXUS,
    /**
     通用风格
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


/**
 缩放方式
 */
typedef NS_ENUM(NSInteger, MXMZoomMode) {
    /**
     不缩放
     */
    MXMZoomDisable,
    /**
     通过动画缩放
     */
    MXMZoomAnimated,
    /**
     无动画缩放
     */
    MXMZoomDirect
};


/**
 路由指令
 */
typedef NS_ENUM(NSInteger, MXMRouteSign) {
    /**
     下楼
     */
    MXMDownstairs = -100,
    /**
     靠左行
     */
    MXMKeepLeft = -7,
    /**
     向左急转
     */
    MXMTurnSharpLeft = -3,
    /**
     向左转
     */
    MXMTurnLeft = -2,
    /**
     轻微转左
     */
    MXMTurnSlightLeft = -1,
    /**
     继续向前
     */
    MXMContinueOnStreet = 0,
    /**
     轻微右转
     */
    MXMTurnSlightRight = 1,
    /**
     向右转
     */
    MXMTurnRight = 2,
    /**
     向右急转
     */
    MXMTurnSharpRight = 3,
    /**
     完成
     */
    MXMFinish = 4,
    /**
     到达途经点
     */
    MXMReachedVia = 5,
    /**
     使用环形路
     */
    MXMUseRoundabout = 6,
    /**
     靠右行
     */
    MXMKeepRight = 7,
    /**
     下楼
     */
    MXMUpstairs = 100,
};


#endif /* MXMDefine_h */
