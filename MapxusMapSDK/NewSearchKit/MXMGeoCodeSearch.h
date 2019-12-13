//
//  MXMGeoCodeSearch.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchBase.h"
#import "MXMGeoCodeSearchOption.h"
#import "MXMGeoCodeSearchResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MXMGeoCodeSearchDelegate;

/**
 geo搜索服务
 */
@interface MXMGeoCodeSearch : MXMSearchBase
/// 检索模块的Delegate
@property (nonatomic, weak, nullable) id<MXMGeoCodeSearchDelegate> delegate;

/**
 根据地理坐标获取地址信息
 异步函数，返回结果在MXMGeoCodeSearchDelegate的onGetReverseGeoCode:result:error:通知
 @param reverseGeoCodeOption 反geo检索信息类
 @return 网络请求的 id，可用于取消对应task
 */
- (NSInteger)reverseGeoCode:(MXMReverseGeoCodeSearchOption *)reverseGeoCodeOption;

@end

/**
 搜索delegate，用于获取搜索结果
 */
@protocol MXMGeoCodeSearchDelegate <NSObject>
@optional
/**
 返回反地理编码搜索结果
 @param searcher 搜索对象
 @param result 搜索结果
 @param error 错误信息
 */
- (void)onGetReverseGeoCode:(MXMGeoCodeSearch *)searcher result:(nullable MXMReverseGeoCodeSearchResult *)result error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
