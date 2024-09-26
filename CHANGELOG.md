# CHANGELOG

## v6.11.0 (2024-09-27)

### 🎉 New

* Added a method `- [MXMCategorySearch searchPoiCategoriesInBoundingBox:]` to query all POI categories within a specified bounding box that contain specified keywords.

* Added support for fil, id, pt, th, vi, and ar languages in the `MXMultilingualObject` class.

### 📝 Changes

* Replaced `- [MXMSearchAPI MXMPOICategorySearch:]` with `- [MXMCategorySearch searchPoiCategoriesByFloor:]`, `- [MXMCategorySearch searchPoiCategoriesByBuilding:]`, and `- [MXMCategorySearch searchPoiCategoriesByVenue:]` for indoor POI category queries.

### ❌ will be deleted soon

* `MapxusMap.floorSwitchMode` will be removed, and always switch according to the venue.
