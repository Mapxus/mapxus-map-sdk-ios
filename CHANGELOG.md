# CHANGELOG

## v6.8.0 (2024-05-27)

### 🎉 New

* In the `MXMBuilding` class, a new return attribute called `buildingNameMap` has been introduced. This multilingual object differs from `nameMap` in its value. Specifically, while `nameMap` incorporates the venue name in its value, `buildingNameMap` does not include venue name.

### 📝 Changes

* Update the display effect of the outdoor map in the `MXMStyleMAPXUS` style.

* Moved the definition of `MXMParamErrorDomain` to the MXMErrorDefined.h file in MapxusBaseSDK.

* `MXMPOI` will no longer return information about the 'description' in fuzzy searches. Information about the 'description' will only be returned when searching through the POI ID, and it will be stored using the `descriptionMap`.

* The multilingual attributes are stored using the generic type `MXMultilingualObject`.

| Class | Deprecated function/parameter | New function/parameter |
| --- | --- | --- |
| MXMGeoVenue | name | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
|  | address | addressMap.Default |
|  | address_en | addressMap.en |
|  | address_cn | addressMap.zh_Hans |
|  | address_zh | addressMap.zh_Hant |
|  | address_ja | addressMap.ja |
|  | address_ko | addressMap.ko |
| MXMGeoBuilding | name | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
| MXMGeoPOI | name | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
|  | accessibilityDetail | accessibilityDetailMap.Default |
|  | accessibilityDetail_en | accessibilityDetailMap.en |
|  | accessibilityDetail_cn | accessibilityDetailMap.zh_Hans |
|  | accessibilityDetail_zh | accessibilityDetailMap.zh_Hant |
|  | accessibilityDetail_ja | accessibilityDetailMap.ja |
|  | accessibilityDetail_ko | accessibilityDetailMap.ko |
| MXMCategory | title_en | titleMap.en |
|  | title_cn | titleMap.zh_Hans |
|  | title_zh | titleMap.zh_Hant |
| MXMVenue | name_default | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
|  | address_default | addressMap.Default |
|  | address_en | addressMap.en |
|  | address_cn | addressMap.zh_Hans |
|  | address_zh | addressMap.zh_Hant |
|  | address_ja | addressMap.ja |
|  | address_ko | addressMap.ko |
| MXMBuilding | venueName_default | venueNameMap.Default |
|  | venueName_en | venueNameMap.en |
|  | venueName_cn | venueNameMap.zh_Hans |
|  | venueName_zh | venueNameMap.zh_Hant |
|  | venueName_ja | venueNameMap.ja |
|  | venueName_ko | venueNameMap.ko |
|  | name_default | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
|  | address_default | addressMap.Default |
|  | address_en | addressMap.en |
|  | address_cn | addressMap.zh_Hans |
|  | address_zh | addressMap.zh_Hant |
|  | address_ja | addressMap.ja |
|  | address_ko | addressMap.ko |
| MXMPOI | name_default | nameMap.Default |
|  | name_en | nameMap.en |
|  | name_cn | nameMap.zh_Hans |
|  | name_zh | nameMap.zh_Hant |
|  | name_ja | nameMap.ja |
|  | name_ko | nameMap.ko |
|  | accessibilityDetail | accessibilityDetailMap.Default |
|  | accessibilityDetail_en | accessibilityDetailMap.en |
|  | accessibilityDetail_cn | accessibilityDetailMap.zh_Hans |
|  | accessibilityDetail_zh | accessibilityDetailMap.zh_Hant |
|  | accessibilityDetail_ja | accessibilityDetailMap.ja |
|  | accessibilityDetail_ko | accessibilityDetailMap.ko |
|  | introduction | descriptionMap.Default |
