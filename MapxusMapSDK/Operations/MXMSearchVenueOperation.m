//
//  MXMSearchVenueOperation.m
//  MapxusMapSDK
//
//  Created by guochenghao on 2023/8/7.
//  Copyright © 2023 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMSearchVenueOperation.h"

@interface MXMSearchVenueOperation () <MXMSearchDelegate>

@property (nonatomic, strong) MXMSearchAPI *api;

@end

@implementation MXMSearchVenueOperation

- (void)searchWithVenueId:(NSString *)venueId
{
    MXMVenueSearchRequest *re = [[MXMVenueSearchRequest alloc] init];
    re.venueIds = @[venueId];
    
    [self.api MXMVenueSearch:re];
}

#pragma mark - MXMSearchDelegate

- (void)MXMSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if (self.complateBlock) {
        self.complateBlock(nil);
    }
}

- (void)onVenueSearchDone:(MXMVenueSearchRequest *)request response:(MXMVenueSearchResponse *)response
{
    if (self.complateBlock) {
        self.complateBlock(response.venues.firstObject);
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
