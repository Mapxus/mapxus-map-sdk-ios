//
//  MGLStyle+MXMFilter.h
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/11/13.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import <MapxusMapSDK/MXMBorderStyle.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLStyle (MXMFilter)

- (void)MXMlocalizeLabelsIntoLocale:(nullable NSString *)localeLanguage;

- (void)updateSelectedBuildingFillOpacityWithIds:(NSArray<NSString *> *)buildingIds notIn:(BOOL)notIn;
- (void)unMaskBuildingFill;

- (void)filerLevelIds:(NSArray *)levelIds;
- (void)filerRearLevelIds:(NSArray *)levelIds;
- (void)filerPoisOnLevelIds:(NSArray *)levelIds exceptPoiIds:(NSArray *)poiIds;

//- (void)setLevelIdsTransparent:(NSArray *)levelIds;

- (void)outLineLevelBorderStyle:(MXMBorderStyle *)borderStyle;

- (void)outLineLevel:(NSString *)levelId;

- (MGLFillStyleLayer *)copyFillLayerWith:(MGLFillStyleLayer *)orig source:(MGLSource *)source;
- (MGLLineStyleLayer *)copyLineLayerWith:(MGLLineStyleLayer *)orig source:(MGLSource *)source;
- (MGLSymbolStyleLayer *)copySymbolLayerWith:(MGLSymbolStyleLayer *)orig source:(MGLSource *)source;

@end

NS_ASSUME_NONNULL_END
