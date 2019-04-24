//
//  MXMSearchObj.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

/**
 建筑搜索请求配置类
 
 共有四种搜索模式：
 1.全球搜索，参数组合为 keywords(可选)，offset，page；
 2.指定方形区域内关键字搜索，参数组合为 keywords(可选)，bbox，offset，page；
 3.指定圆形区域内关键字搜索，参数组合为 keywords(可选)，center，distance，offset，page；
 4.指定建筑ID搜索，参数为 buildingIds。
 */
@interface MXMBuildingSearchRequest : NSObject
/// 关键字。目前只支持单个关键字查询
@property (nonatomic, strong) NSString *keywords;
/// 方形搜索区域。bbox与center 二选一进行搜索
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 圆形区域搜索中心。bbox与center 二选一进行搜索
@property (nonatomic, strong) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为km，必须配合center使用
@property (nonatomic, assign) double distance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
/// 查询的建筑id列表。与其他的参数互斥
@property (nonatomic, strong) NSArray *buildingIds;
@end




/**
 建筑搜索结果
 */
@interface MXMBuildingSearchResponse : NSObject
/// 返回结果个数
@property (nonatomic, assign) NSInteger total;
/// 返回的`MXMBuilding`队列
@property (nonatomic, strong) NSArray<MXMBuilding *> *buildings;
@end




/**
 POI分类搜索请求配置类
 
 搜索指定建筑和楼层内所有的POI分类名，floor可不传，不传将搜索整栋建筑。
 */
@interface MXMPOICategorySearchRequest : NSObject
/// 指定搜索建筑id
@property (nonatomic, strong) NSString *buildingId;
/// 指定搜索楼层
@property (nonatomic, strong) NSString *floor;
@end




/**
 POI分类搜索结果
 */
@interface MXMPOICategorySearchResponse : NSObject
/// 分类名列表
@property (nonatomic, strong) NSArray *category;
@end




/**
 POI搜索请求配置类
 
 共有四种搜索模式：
 1.指定建筑与楼层内关键字搜索，参数组合为 keywords(可选)，buildingId，floor(可选)，offset，page，category(可选)；
 2.指定方形区域内关键字搜索，参数组合为 keywords(可选)，bbox，offset，page，category(可选)；
 3.指定圆形区域内关键字搜索，参数组合为 keywords(可选)，center，meterDistance(或distance)，offset，page，category(可选)；
 4.指定建筑ID搜索，参数为 POIIds；
 
 category参考值：
 
 | Key                            | 中文名         |
 | ------------------------------ | -------------- |
 | shop                           | 商店           |
 | restaurant                     | 餐厅           |
 | toilet                         | 厕所           |
 | outdoor                        | 户外           |
 | transport                      | 运输           |
 | parking                        | 停车场         |
 | classroom                      | 教室           |
 | study                          | 自习室         |
 | reading                        | 阅读           |
 | meeting                        | 会议           |
 | computer                       | 电脑室         |
 | auditorium                     | 礼堂           |
 | lab                            | 实验室         |
 | library                        | 图书馆         |
 | function                       | 多功能厅       |
 | media                          | 多媒体室       |
 | security_room                  | 保安室         |
 | prayer_room                    | 祈祷室         |
 | lounge                         | 休息室         |
 | workshop                       | 工作室         |
 | anteroom                       | 接待室         |
 | operating_theater              | 手术室         |
 | therapy_room                   | 治疗室         |
 | consulation_room               | 咨询室         |
 | ward                           | 病房           |
 | dispensary                     | 药房           |
 | examination_room               | 检查室         |
 | cashier                        | 收银处         |
 | registration                   | 挂号处         |
 | huddle_room                    | 小型会议室     |
 | kitchen                        | 厨房           |
 | laboratory                     | 实验室         |
 | lobby                          | 大堂           |
 | mail_room                      | 收发室         |
 | non_public                     | 非公开         |
 | office                         | 办公室         |
 | phone_room                     | 通讯室         |
 | server_room                    | 机房           |
 | shower                         | 淋浴室         |
 | smoking_area                   | 吸烟区         |
 | atm                            | 自动取款机     |
 | customer_service               | 客户服务       |
 | coins_collector                | 投币机         |
 | directory                      | 目录           |
 | fire_hydrant                   | 消防栓         |
 | game_station                   | 游戏站         |
 | mobile_charger                 | 手机充电器     |
 | parcel_locker                  | 包裹储物柜     |
 | recycling_bin                  | 回收站         |
 | storage_locker                 | 储物柜         |
 | telephone                      | 电话           |
 | ticketing                      | 票务           |
 | undefined                      | 未定义的       |
 | vending_machine                | 自动售货机     |
 | waste_bin                      | 垃圾箱         |
 | water_machine                  | 饮水机         |
 | printer                        | 打印机         |
 | scanner                        | 扫描仪         |
 | computer                       | 电脑           |
 | add_value_machine              | 增加价值的机器 |
 | fountain                       | 喷泉           |
 | mini_ktv                       | 小型卡拉ok     |
 | braille_signs                  | 点字指示牌     |
 | doll_machine                   | 娃娃机         |
 | cashier                        | 收银机         |
 | defibrillator                  | 除颤器         |
 | information                    | 指示牌         |
 | mailbox                        | 邮箱           |
 | power_charging_station         | 充电站         |
 | removable_restroom             | 移动式洗手间   |
 | braille_and_tactile_floor_plan | 触觉平面图     |
 | guide_path                     | 引路径         |
 | entry_gate                     | 入闸位         |
 | exit_gate                      | 出闸位         |
 | gate                           | 闸位           |
 | type                           | 门口           |
 | guest_services                 | 客户服务       |
 */
@interface MXMPOISearchRequest : NSObject
/// 关键字。目前只支持单个关键字
@property (nonatomic, strong) NSString *keywords;
/// 建筑id。buildingId，bbox, center 三选一
@property (nonatomic, strong) NSString *buildingId;
/// 搜索楼层。必须配合buildingId使用
@property (nonatomic, strong) NSString *floor;
/// 方形搜索区域。buildingId，bbox, center 三选一
@property (nonatomic, strong) MXMBoundingBox *bbox;
/// 圆形区域搜索中心。buildingId，bbox, center 三选一
@property (nonatomic, strong) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为km，必须配合center使用
@property (nonatomic, assign) double distance DEPRECATED_ATTRIBUTE;
/// 圆形区域搜索半径。单位为m，必须配合center使用
@property (nonatomic, assign) NSUInteger meterDistance;
/// 每页显示多少数据
@property (nonatomic, assign) NSUInteger offset;
/// 页数
@property (nonatomic, assign) NSUInteger page;
/// 要过滤的类别
@property (nonatomic, strong) NSString *category;
/// 查询的POI id列表。与上面的参数互斥
@property (nonatomic, strong) NSArray *POIIds;
@end




/**
 POI搜索结果
 */
@interface MXMPOISearchResponse : NSObject
/// 返回结果个数
@property (nonatomic, assign) NSInteger total;
/// 返回的`MXMPOI`队列
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 给定地图偏转角度，搜索附近POI点并得出POI点相对手机方向的方位
 */
@interface MXMOrientationPOISearchRequest : NSObject
/// 地图正北方向到手机指向的顺时针夹角，取值范围：[0,359]
@property (nonatomic, assign) NSUInteger angle;
/// 距离搜索类型（默认：Point）。Point：查找以center为圆心，distance为半径的圆包含的POI点；Polygon：查找以center为圆心，distance为半径的圆相交房间的POI信息
@property (nonatomic, strong) NSString *distanceSearchType;
/// 建筑ID
@property (nonatomic, strong) NSString *buildingId;
/// 搜索楼层
@property (nonatomic, strong) NSString *floor;
/// 中心点位置
@property (nonatomic, strong) MXMGeoPoint *center;
/// 圆形区域搜索半径。单位为m
@property (nonatomic, assign) NSUInteger distance;
@end




/**
 中心点附近POI搜索结果
 */
@interface MXMOrientationPOISearchResponse : NSObject
/// 返回的`MXMPOI`队列
@property (nonatomic, strong) NSArray<MXMPOI *> *pois;
@end




/**
 路线搜索请求配置
 */
@interface MXMRouteSearchRequest : NSObject
/// 始点建筑
@property (nonatomic, strong) NSString *fromBuilding;
/// 始点建筑楼层
@property (nonatomic, strong) NSString *fromFloor;
/// 始点经度
@property (nonatomic, assign) double fromLon;
/// 始点纬度
@property (nonatomic, assign) double fromLat;
/// 终点建筑
@property (nonatomic, strong) NSString *toBuilding;
/// 终点建筑楼层
@property (nonatomic, strong) NSString *toFloor;
/// 终点经度
@property (nonatomic, assign) double toLon;
/// 终点纬度
@property (nonatomic, assign) double toLat;
/// 返回结果语言版本。可选值为zh-HK,zh-CN,en。默认en
@property (nonatomic, strong) NSString *locale;
/// 终点设置在门前。设置为YES则终点只到POI店门终止
@property (nonatomic, assign) BOOL toDoor;
@end




/**
 路线搜索结果
 */
@interface MXMRouteSearchResponse : NSObject
/// 路线`MXMPath`的队列，不同的路线为不同的规划方案
@property (nonatomic, strong) NSArray<MXMPath *> *paths;
@end








