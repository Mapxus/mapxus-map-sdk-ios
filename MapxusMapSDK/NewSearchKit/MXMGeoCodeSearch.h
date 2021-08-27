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
 geo search services
 */
@interface MXMGeoCodeSearch : MXMSearchBase
/// Handle to the object which processing result
@property (nonatomic, weak, nullable) id<MXMGeoCodeSearchDelegate> delegate;

/**
 Get address information based on geographic coordinates
 
 Asynchronous function, return results in MXMGeoCodeSearchDelegate's onGetReverseGeoCode:result:error:notification
 @param reverseGeoCodeOption Reverse geo search parameters
 @return The id of the network request, which can be used to cancel the corresponding task
 */
- (NSInteger)reverseGeoCode:(MXMReverseGeoCodeSearchOption *)reverseGeoCodeOption;

@end

/**
 Search delegate for search results
 */
@protocol MXMGeoCodeSearchDelegate <NSObject>
@optional
/**
 Return reverse geocoding search results
 @param searcher Search by
 @param result Search results
 @param error Error message
 */
- (void)onGetReverseGeoCode:(MXMGeoCodeSearch *)searcher result:(nullable MXMReverseGeoCodeSearchResult *)result error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
