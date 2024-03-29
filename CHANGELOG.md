# CHANGELOG

## v6.7.0 (2024-03-29)

### 🎉 New

* Introduced an emergency mode for route search. To use this, pass the string "emergency" in the `vehicle` property of `MXMRouteSearchRequest`.
* Enhanced route planning with a new multi-point navigation feature. Use the `points` property of `MXMRouteSearchRequest` to input up to 5 points for route planning. Please note that `fromBuildingId`, `fromFloorId`, `fromLon`, `fromLat`, `toBuildingId`, `toFloorId`, `toLon`, and `toLat` will be deprecated. In the returned result, the `MXMRouteSign` enum will include `MXMReachedVia` to signify arrival at the via point.
* Improved POI search functionality. You can now use the `orderBy` property of `MXMPOISearchRequest` to sort the returned POI list in ascending order based on "DefaultName".
* Added a feature to exclude unwanted POI types during a POI search. Use the `excludeCategories` property of `MXMPOISearchRequest` to filter out these categories.

### 🐛 Fixes

* Resolved an issue where the floorBar occasionally failed to display floors when minimized.

### 🚀 Optimization

* Enhanced map rendering performance for a smoother user experience.

### ❌ will be deleted soon

* The `toDoor` property in the route planning parameter class `MXMRouteSearchRequest` is set to be deprecated. All routes in the search results will terminate at the POI's door.
