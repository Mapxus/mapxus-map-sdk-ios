//
//  MXMSearchFloorOperation.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/8/14.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchFloorOperation.h"
#import "MXMHttpManager.h"
#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "MXMSearchObj.h"

@implementation MXMSearchFloorOperation

- (void)searchWithFloorId:(NSString *)floorId
{
  NSString *url = [NSString stringWithFormat:@"%@%@%@", MXMAPIHOSTURL,@"/bms/api/v3/buildings/floors/", floorId];
  
  [MXMHttpManager MXMGET:url parameters:nil success:^(NSDictionary *content) {
    if (self.complateBlock) {
      MXMBuildingSearchResponse *response = [MXMBuildingSearchResponse yy_modelWithJSON:content];
      self.complateBlock(response.buildings.firstObject);
    }
  } failure:^(NSError *error) {
    if (self.complateBlock) {
      self.complateBlock(nil);
    }
  }];
  

}

@end
