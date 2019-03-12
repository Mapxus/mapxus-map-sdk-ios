//
//  MXMSearchBuildingOperation2.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2019/3/21.
//  Copyright © 2019 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchBuildingOperation2.h"

@interface MXMSearchBuildingOperation2 () <MXMSearchDelegate>

@property (nonatomic, strong) MXMSearchAPI *api;

@end

@implementation MXMSearchBuildingOperation2

- (void)searchWithBuildingId:(NSString *)buildingId
{
    MXMBuildingSearchRequest *re = [[MXMBuildingSearchRequest alloc] init];
    re.buildingIds = @[buildingId];
    
    [self.api MXMBuildingSearch:re];
}

#pragma mark - MXMSearchDelegate

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if (self.complateBlock) {
        self.complateBlock(nil);
    }
}

- (void)onBuildingSearchDone:(MXMBuildingSearchRequest *)request response:(MXMBuildingSearchResponse *)response
{
    if (self.complateBlock) {
        self.complateBlock(response.buildings.firstObject);
    }
}


#pragma mark - access

- (MXMSearchAPI *)api
{
    if (!_api) {
        _api = [[MXMSearchAPI alloc] init];
        _api.delegate = self;
    }
    return _api;
}

@end
