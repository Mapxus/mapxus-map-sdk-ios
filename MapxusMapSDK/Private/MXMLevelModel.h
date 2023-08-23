//
//  MXMLevelModel.h
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/7/10.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXMLevelModel : NSObject

@property (nonatomic, strong) NSString *levelId;
@property (nonatomic, strong) NSString *refBuildingId;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) MXMOrdinal *ordinal;

@end

NS_ASSUME_NONNULL_END
