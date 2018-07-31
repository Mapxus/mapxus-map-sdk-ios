//
//  MXMSearchAPI.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMSearchObj.h"

@protocol MXMSearchDelegate;




@interface MXMSearchAPI : NSObject

/**
 实现了 `MXMSearchDelegate` 协议的类指针
 */
@property (nonatomic, weak) id<MXMSearchDelegate> delegate;

/**
 * @brief 建筑物查询接口
 * @param request 查询选项。具体属性字段请参考 `MXMBuildingSearchRequest` 类。
 */
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request;

/**
 * @brief 建筑内POI信息查询接口
 * @param request 查询选项。具体属性字段请参考 `MXMPOISearchRequest` 类。
 */
- (void)MXMPOISearch:(MXMPOISearchRequest *)request;

/**
 * @brief 建筑物内路线接口
 * @param request 查询选项。具体属性字段请参考 `MXMRouteSearchRequest` 类。
 */
- (void)MXMRouteSearch:(MXMRouteSearchRequest *)request;

@end






/**
 MXMSearchDelegate协议，定义了搜索结果的回调方法，及发生错误时的回调方法。
 */
@protocol MXMSearchDelegate <NSObject>

@optional

/**
 * @brief 请求错误回调方法
 * @param request 查询选项。
 * @param error 错误信息。
 */
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error;

/**
 * @brief 建筑物内路线接口
 * @param request 查询选项。具体属性字段请参考 `MXMBuildingSearchRequest` 类。
 * @param response 查询结果。具体属性字段请参考 `MXMBuildingSearchResponse` 类。
 */
- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response;

/**
 * @brief 建筑物内路线接口
 * @param request 查询选项。具体属性字段请参考 `MXMPOISearchRequest` 类。
 * @param response 查询结果。具体属性字段请参考 `MXMPOISearchResponse` 类。
 */
- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response;

/**
 * @brief 建筑物内路线接口
 * @param request 查询选项。具体属性字段请参考 `MXMRouteSearchRequest` 类。
 * @param response 查询结果。具体属性字段请参考 `MXMRouteSearchResponse` 类。
 */
- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response;

@end
