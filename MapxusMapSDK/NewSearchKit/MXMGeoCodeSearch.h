//
//  MXMGeoCodeSearch.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/7/2.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <MapxusMapSDK/MXMSearchBase.h>
#import <MapxusMapSDK/MXMGeoCodeSearchOption.h>
#import <MapxusMapSDK/MXMGeoCodeSearchResult.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MXMGeoCodeSearchDelegate;



/// `MXMGeoCodeSearch` is a class that provides geo search services. It inherits from `MXMSearchBase`.
@interface MXMGeoCodeSearch : MXMSearchBase


/// The `delegate` property is a weak reference to the object that will handle the search results.
/// This object must conform to the `MXMGeoCodeSearchDelegate` protocol.
@property (nonatomic, weak, nullable) id<MXMGeoCodeSearchDelegate> delegate;


/// The `reverseGeoCode:` method retrieves address information based on geographic coordinates.
/// This is an asynchronous function, and it returns results via the `onGetReverseGeoCode:result:error:` method of the `MXMGeoCodeSearchDelegate`.
///
/// @param reverseGeoCodeOption The parameters for the reverse geo search.
/// @return The id of the network request, which can be used to cancel the corresponding task.
- (NSInteger)reverseGeoCode:(MXMReverseGeoCodeSearchOption *)reverseGeoCodeOption;

@end



/// `MXMGeoCodeSearchDelegate` is a protocol that defines the delegate method for receiving reverse geocoding search results.
@protocol MXMGeoCodeSearchDelegate <NSObject>


@optional
/// The `onGetReverseGeoCode:result:error:` method is called when the reverse geocoding search results are available.
/// 
/// @param searcher The `MXMGeoCodeSearch` object that performed the search.
/// @param result The search results, encapsulated in a `MXMReverseGeoCodeSearchResult` object.
/// @param error An `NSError` object that describes any error that occurred during the search.
- (void)onGetReverseGeoCode:(MXMGeoCodeSearch *)searcher
                     result:(nullable MXMReverseGeoCodeSearchResult *)result
                      error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
