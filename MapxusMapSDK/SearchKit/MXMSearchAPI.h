//
//  MXMSearchAPI.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/17.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapxusMapSDK/MXMSearchObj.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MXMSearchDelegate;


/**
 Search Interface Manager
 */
@interface MXMSearchAPI : NSObject

/**
 Pointer to an object that implements the `MXMSearchDelegate` protocol
 */
@property (nonatomic, weak, nullable) id<MXMSearchDelegate> delegate;

/**
 * @brief Venue search interface
 * @param request Query options. Please refer to the `MXMVenueSearchRequest` class for specific property fields.
 */
- (void)MXMVenueSearch:(MXMVenueSearchRequest *)request;

/**
 * @brief Building search interface
 * @param request Query options. Please refer to the `MXMBuildingSearchRequest` class for specific property fields.
 */
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request;

/**
 * @brief In-building POI category search interface
 * @param request Query options. Please refer to the `MXMPOICategorySearchRequest` class for specific property fields.
 */
- (void)MXMPOICategorySearch:(MXMPOICategorySearchRequest *)request;

/**
 * @brief In-building POI information search interface
 * @param request Query options. Please refer to the `MXMPOISearchRequest` class for specific property fields.
 */
- (void)MXMPOISearch:(MXMPOISearchRequest *)request;

/**
 * @brief Interface to search for nearby POI points within the building and derive the orientation of the POI point in relation to the mobile phone
 * @param request Query options. Please refer to the `MXMOrientationPOISearchRequest` class for specific property fields.
 */
- (void)MXMOrientationPOISearch:(MXMOrientationPOISearchRequest *)request;

/**
 * @brief In-building route search interface
 * @param request Query options. Please refer to the `MXMRouteSearchRequest` class for specific property fields.
 */
- (void)MXMRouteSearch:(MXMRouteSearchRequest *)request;

@end






/**
 The MXMSearchDelegate protocol, which defines the callback methods for search results and when an error occurs.
 */
@protocol MXMSearchDelegate <NSObject>

@optional

/**
 * @brief Request error callback method
 * @param request Query options
 * @param error Error message
 */
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error;

/**
 * @brief Venue query callback methods
 * @param request Query options. Please refer to the `MXMVenueSearchRequest` class for specific property fields.
 * @param response Query results. Please refer to the `MXMVenueSearchResponse` class for specific property fields.
 */
- (void)onVenueSearchDone:(MXMVenueSearchRequest *)request response:(MXMVenueSearchResponse *)response;

/**
 * @brief Building query callback methods
 * @param request Query options. Please refer to the `MXMBuildingSearchRequest` class for specific property fields.
 * @param response Query results. Please refer to the `MXMBuildingSearchResponse` class for specific property fields.
 */
- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response;

/**
 * @brief Callback methods for POI category queries within buildings
 * @param request Query options. Please refer to the `MXMPOICategorySearchRequest` class for specific property fields.
 * @param response Query results. Please refer to the `MXMPOICategorySearchResponse` class for the specific property fields.
 */
- (void)onPOICategorySearchDone:(MXMPOICategorySearchRequest *)request response:(MXMPOICategorySearchResponse *)response;

/**
 * @brief Callback methods for POI queries within the building
 * @param request Query options. Please refer to the `MXMPOISearchRequest` class for specific property fields.
 * @param response The result of the query. Please refer to the `MXMPOISearchResponse` class for specific property fields.
 */
- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response;

/**
 * @brief Callback method for searching for nearby POI points within a building and deriving the orientation of the POI point in relation to the direction of the phone
 * @param request Query options. Please refer to the `MXMOrientationPOISearchRequest` class for specific property fields.
 * @param response The result of the query. Please refer to the `MXMOrientationPOISearchResponse` class for specific property fields.
 */
- (void)onOrientationPOISearchDone:(MXMOrientationPOISearchRequest *)request response:(MXMOrientationPOISearchResponse *)response;

/**
 * @brief In-building route callback method
 * @param request Query options. Please refer to the `MXMRouteSearchRequest` class for specific property fields.
 * @param response Query results. Please refer to the `MXMRouteSearchResponse` class for the specific property fields.
 */
- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response;

@end

NS_ASSUME_NONNULL_END
