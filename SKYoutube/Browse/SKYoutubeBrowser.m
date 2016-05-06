//
//  SKYoutubeBrowser.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeBrowser.h"

#import "SKYoutubeConnection.h"

#import "SKYoutubeExtendableList.h"

static NSString const * kCacheKeyMostPopular = @"mostPopular";

@interface SKYoutubeBrowser ()

@property(nonatomic, copy, readonly, nonnull) NSString *key;
@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;
@property(nonatomic, copy, readonly) dispatch_queue_t workerQueue;
@property(nonatomic, copy, readonly) dispatch_queue_t callbackQueue;

@end

@implementation SKYoutubeBrowser

- (nonnull instancetype)initWithKey:(nonnull NSString *)key {
    self = [super init];
    _key = key;
    _cache = [[NSMutableDictionary alloc] init];
    _workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _callbackQueue = dispatch_get_main_queue();
    return self;
}

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    dispatch_async(_workerQueue, ^{
        SKYoutubeExtendableList *cachedExtendableList = [_cache objectForKey:kCacheKeyMostPopular];
        
        if( refresh || (!cachedExtendableList) ) {
            cachedExtendableList = [[SKYoutubeExtendableList alloc] init];
            [_cache setObject:cachedExtendableList forKey:kCacheKeyMostPopular];
        }
        
        if( extend && !cachedExtendableList.finished ) {
            SKYoutubePagedListResponse *response = [SKYoutubeBrowser list:_key forPart:@"snippet" inChart:@"mostPopular" withPageSize:50 andPageCode:cachedExtendableList.nextPageToken];
            
            if(response) {
                [cachedExtendableList addObjectsByResponse:response];
            } else {
                dispatch_async(_callbackQueue, ^{
                    failure([NSError errorWithDomain:@"Unable to get response" code:0 userInfo:nil]);
                });
                return;
            }
        }
        
        dispatch_async(_callbackQueue, ^{
            success(cachedExtendableList.objects, cachedExtendableList.finished);
        });
    });
}

+ (nonnull SKYoutubePagedListResponse *)list:(nonnull NSString *)key forPart:(nonnull NSString *)part inChart:(nonnull NSString *)chart withPageSize:(NSUInteger)pageSize andPageCode:(nullable NSString *)pageCode {
    
    NSDictionary *basicParameter = @{
                                @"key" : key,
                                @"part" : part,
                                @"chart" : chart,
                                @"maxResults" : @(pageSize)
                                };
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:basicParameter];
    
    if(pageCode) {
        [parameter setObject:pageCode forKey:@"pageToken"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/videos" andParameter:parameter];
}

@end
