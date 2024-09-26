//
//  MXMCategorySearch.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/9/3.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <MapxusMapSDK/MXMSearchBase.h>
#import <MapxusMapSDK/MXMCategorySearchOption.h>
#import <MapxusMapSDK/MXMCategorySearchResult.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MXMCategorySearchDelegate;



/// The `MXMCategorySearch` class is used for category search. It inherits from `MXMSearchBase`.
@interface MXMCategorySearch : MXMSearchBase


/// The `delegate` property is a weak reference to the object that will handle the search results and error information.
/// This object must conform to the `MXMCategorySearchDelegate` protocol.
@property (nonatomic, weak, nullable) id<MXMCategorySearchDelegate> delegate;


/// Searches POI categories by floor option. 
/// This is an asynchronous function, and it returns results via the `- [categorySearcher:didReceivePoiCategoryWithResult:error:]` method of
/// the `MXMCategorySearchDelegate`.
///
/// @param floorOption The floor search option.
/// @return The id of the network request, which can be used to cancel the corresponding task.
- (NSInteger)searchPoiCategoriesByFloor:(MXMPoiCategoryFloorSearchOption *)floorOption;


/// Searches POI categories by building option. 
/// This is an asynchronous function, and it returns results via the `- [categorySearcher:didReceivePoiCategoryWithResult:error:]` method of
/// the `MXMCategorySearchDelegate`.
///
/// @param buildingOption The building search option.
/// @return The id of the network request, which can be used to cancel the corresponding task.
- (NSInteger)searchPoiCategoriesByBuilding:(MXMPoiCategoryBuildingSearchOption *)buildingOption;


/// Searches POI categories by venue option.
/// This is an asynchronous function, and it returns results via the `- [categorySearcher:didReceivePoiCategoryWithResult:error:]` method of
/// the `MXMCategorySearchDelegate`.
///
/// @param venueOption The venue search option.
/// @return The id of the network request, which can be used to cancel the corresponding task.
- (NSInteger)searchPoiCategoriesByVenue:(MXMPoiCategoryVenueSearchOption *)venueOption;


/// Searches POI categories in a bounding box.
/// This is an asynchronous function, and it returns results via the `- [categorySearcher:didReceivePoiCategoryInBoundingBoxWithResult:error:]`
/// method of the `MXMCategorySearchDelegate`.
///
/// @param bboxOption The bounding box search option.
/// @return The id of the network request, which can be used to cancel the corresponding task.
- (NSInteger)searchPoiCategoriesInBoundingBox:(MXMPoiCategoryBboxSearchOption *)bboxOption;

@end



/// `MXMCategorySearchDelegate` is a protocol that defines the delegate methods for category search results.
@protocol MXMCategorySearchDelegate <NSObject>


@optional
/// Called when the category searcher receives a POI category result.
/// - Parameters:
///   - categorySearcher: The category searcher object.
///   - searchResult: The POI category search result.
///   - error:  An `NSError` object that describes any error that occurred during the search.
- (void)categorySearcher:(MXMCategorySearch *)categorySearcher
  didReceivePoiCategoryWithResult:(nullable MXMPoiCategorySearchResult *)searchResult
                   error:(nullable NSError *)error;


/// Called when the category searcher receives a POI category result within a bounding box.
/// - Parameters:
///   - categorySearcher: The category searcher object.
///   - searchResult: The POI category bounding box search result.
///   - error:  An `NSError` object that describes any error that occurred during the search.
- (void)categorySearcher:(MXMCategorySearch *)categorySearcher
  didReceivePoiCategoryInBoundingBoxWithResult:(nullable MXMPoiCategoryBboxSearchResult *)searchResult
                   error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
