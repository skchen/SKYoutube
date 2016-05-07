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

static NSString const * kCacheKeyVideoCategories = @"videoCategories";
static NSString const * kCacheKeyMostPopular = @"mostPopular";

@interface SKYoutubeBrowser ()

@property(nonatomic, copy, readonly, nonnull) NSString *key;
@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;
@property(nonatomic, copy, readonly) dispatch_queue_t workerQueue;
@property(nonatomic, copy, readonly) dispatch_queue_t callbackQueue;
@property(nonatomic, copy, readonly, nonnull) NSLocale *locale;

@end

@implementation SKYoutubeBrowser

- (nonnull instancetype)initWithKey:(nonnull NSString *)key andLocale:(nullable NSLocale *)locale {
    self = [super init];
    _key = key;
    _cache = [[NSMutableDictionary alloc] init];
    _workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _callbackQueue = dispatch_get_main_queue();
    
    if(locale) {
        _locale = locale;
    } else {
        _locale = [NSLocale currentLocale];
    }
    
    return self;
}

- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {

    dispatch_async(_workerQueue, ^{
        NSArray *videoCategories = [_cache objectForKey:kCacheKeyVideoCategories];
        
        if( refresh || (!videoCategories) ) {
            SKYoutubeListResponse *response = [SKYoutubeBrowser listVideoCategories:_key part:@"snippet" locale:_locale];
            
            if(response) {
                videoCategories = response.items;
                [_cache setObject:videoCategories forKey:kCacheKeyVideoCategories];
            } else {
                dispatch_async(_callbackQueue, ^{
                    failure([NSError errorWithDomain:@"Unable to get response" code:0 userInfo:nil]);
                });
                return;
            }
        }
        
        dispatch_async(_callbackQueue, ^{
            success(videoCategories);
        });
    });
}

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    const NSString *cacheKey;
    if(category) {
        cacheKey = [NSString stringWithFormat:@"%@%@", kCacheKeyMostPopular, category];
    } else {
        cacheKey = kCacheKeyMostPopular;
    }
    
    dispatch_async(_workerQueue, ^{
        SKYoutubeExtendableList *cachedExtendableList = [_cache objectForKey:cacheKey];
        
        if( refresh || (!cachedExtendableList) ) {
            cachedExtendableList = [[SKYoutubeExtendableList alloc] init];
            [_cache setObject:cachedExtendableList forKey:cacheKey];
        }
        
        if( extend && !cachedExtendableList.finished ) {
            SKYoutubePagedListResponse *response = [SKYoutubeBrowser listVideos:_key part:@"snippet" chart:@"mostPopular" category:category pageSize:50 pageCode:cachedExtendableList.nextPageToken];
            
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

+ (nonnull SKYoutubeListResponse *)listVideoCategories:(nonnull NSString *)key part:(nonnull NSString *)part locale:(nonnull NSLocale *)locale {
    
    NSString *region = [locale objectForKey: NSLocaleCountryCode];
    
    NSDictionary *parameter = @{
                                @"key" : key,
                                @"part" : part,
                                @"regionCode" : region
                                };
    
    return (SKYoutubeListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/videoCategories" andParameter:parameter];
}

+ (nonnull SKYoutubePagedListResponse *)listVideos:(nonnull NSString *)key part:(nonnull NSString *)part chart:(nonnull NSString *)chart category:(nullable NSString *)category pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
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
    
    if(category) {
        [parameter setObject:category forKey:@"videoCategoryId"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/videos" andParameter:parameter];
}

@end
