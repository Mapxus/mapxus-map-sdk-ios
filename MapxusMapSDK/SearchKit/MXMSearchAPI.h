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



/// The `MXMSearchAPI` interface manages the search functionality.
@interface MXMSearchAPI : NSObject


/// A pointer to an object that implements the `MXMSearchDelegate` protocol.
@property (nonatomic, weak, nullable) id<MXMSearchDelegate> delegate;


/// This method is the venue search interface.
///
/// @param request The query options. Refer to the `MXMVenueSearchRequest` class for specific property fields.
- (void)MXMVenueSearch:(MXMVenueSearchRequest *)request;


/// This method is the building search interface.
///
///@param request The query options. Refer to the `MXMBuildingSearchRequest` class for specific property fields.
- (void)MXMBuildingSearch:(MXMBuildingSearchRequest *)request;


/// This method is the in-building POI category search interface.
///
/// @param request The query options. Refer to the `MXMPOICategorySearchRequest` class for specific property fields.
- (void)MXMPOICategorySearch:(MXMPOICategorySearchRequest *)request;


/// This method is the in-building POI information search interface.
///
/// @param request The query options. Refer to the `MXMPOISearchRequest` class for specific property fields.
- (void)MXMPOISearch:(MXMPOISearchRequest *)request;


/// This method is the interface to search for nearby POI points within the building and derive the orientation of the POI point in relation to the mobile phone.
///
/// @param request The query options. Refer to the `MXMOrientationPOISearchRequest` class for specific property fields.
- (void)MXMOrientationPOISearch:(MXMOrientationPOISearchRequest *)request;


/// This method is the in-building route search interface.
///
/// @param request The query options. Refer to the `MXMRouteSearchRequest` class for specific property fields.
- (void)MXMRouteSearch:(MXMRouteSearchRequest *)request;

@end



/// The MXMSearchDelegate protocol defines the callback methods for search results and when an error occurs.
@protocol MXMSearchDelegate <NSObject>


@optional
/// This method is a callback for request errors.
///
/// @param request The query options.
/// @param error The error message.
- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error;


/// This method is a callback for venue queries.
///
/// @param request The query options. Refer to the `MXMVenueSearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMVenueSearchResponse` class for specific property fields.
- (void)onVenueSearchDone:(MXMVenueSearchRequest *)request response:(MXMVenueSearchResponse *)response;


/// This method is a callback for building queries.
///
/// @param request The query options. Refer to the `MXMBuildingSearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMBuildingSearchResponse` class for specific property fields.
- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response;


/// This method is a callback for POI category queries within buildings.
///
/// @param request The query options. Refer to the `MXMPOICategorySearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMPOICategorySearchResponse` class for specific property fields.
- (void)onPOICategorySearchDone:(MXMPOICategorySearchRequest *)request response:(MXMPOICategorySearchResponse *)response;


/// This method is a callback for POI queries within the building.
///
/// @param request The query options. Refer to the `MXMPOISearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMPOISearchResponse` class for specific property fields.
- (void)onPOISearchDone:(MXMPOISearchRequest *)request response:(MXMPOISearchResponse *)response;


/// This method is a callback for searching for nearby POI points within a building and deriving the orientation of the POI point in relation to the direction of the phone.
///
/// @param request The query options. Refer to the `MXMOrientationPOISearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMOrientationPOISearchResponse` class for specific property fields.
- (void)onOrientationPOISearchDone:(MXMOrientationPOISearchRequest *)request response:(MXMOrientationPOISearchResponse *)response;


/// This method is a callback for in-building route queries.
///
/// @param request The query options. Refer to the `MXMRouteSearchRequest` class for specific property fields.
/// @param response The query results. Refer to the `MXMRouteSearchResponse` class for specific property fields.
- (void)onRouteSearchDone:(MXMRouteSearchRequest *)request response:(MXMRouteSearchResponse *)response;

@end

NS_ASSUME_NONNULL_END
