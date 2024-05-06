//
//  MXMultilingualObject.h
//  MapxusMapSDK
//
//  Created by guochenghao on 2024/4/28.
//  Copyright © 2024 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXMultilingualObject<ObjectType> : NSObject <NSCopying>

@property (nonatomic, copy, nullable) ObjectType Default;
@property (nonatomic, copy, nullable) ObjectType en;
@property (nonatomic, copy, nullable) ObjectType zh_Hans;
@property (nonatomic, copy, nullable) ObjectType zh_Hant;
@property (nonatomic, copy, nullable) ObjectType ja;
@property (nonatomic, copy, nullable) ObjectType ko;

@end

NS_ASSUME_NONNULL_END
