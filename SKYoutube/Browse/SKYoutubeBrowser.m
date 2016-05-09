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

static NSString * const kCacheKeyGuideCategories = @"guideCategories";
static NSString * const kCacheKeySearch = @"search";
static NSString * const kCacheKeyVideoCategories = @"videoCategories";
static NSString * const kCacheKeyMostPopular = @"mostPopular";

typedef SKYoutubePagedListResponse* (^SKExtendableListRequest)(NSString * _Nullable pageCode);
typedef SKYoutubeListResponse* (^SKListRequest)(void);

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

- (void)listGuideCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {
    [self youtubeList:refresh cacheKey:kCacheKeyGuideCategories request:^SKYoutubeListResponse *{
        return [SKYoutubeBrowser listGuideCategories:_key part:@"snippet" locale:_locale];
    } success:success failure:failure];
}

- (void)listChannels:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [self cacheKeyWithElements:2, kCacheKeySearch, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listChannels:_key part:@"snippet" category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)searchVideos:(BOOL)refresh extend:(BOOL)extend query:(nullable NSString *)query category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [self cacheKeyWithElements:3, kCacheKeySearch, query, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser searchVideos:_key query:query part:@"snippet" category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    [self youtubeList:refresh cacheKey:kCacheKeyVideoCategories request:^SKYoutubeListResponse *{
        return [SKYoutubeBrowser listVideoCategories:_key part:@"snippet" locale:_locale];
    } success:success failure:failure];
}

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [self cacheKeyWithElements:2, kCacheKeyMostPopular, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listVideos:_key part:@"snippet" chart:@"mostPopular" category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)youtubeList:(BOOL)refresh cacheKey:(NSString *)cacheKey request:(SKListRequest)request success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    dispatch_async(_workerQueue, ^{
        NSArray *cachedList = [_cache objectForKey:cacheKey];
        
        if( refresh || (!cachedList) ) {
            SKYoutubeListResponse *response = request();
            
            if(response) {
                cachedList = response.items;
                [_cache setObject:cachedList forKey:kCacheKeyVideoCategories];
            } else {
                dispatch_async(_callbackQueue, ^{
                    failure([NSError errorWithDomain:@"Unable to get response" code:0 userInfo:nil]);
                });
                return;
            }
        }
        
        dispatch_async(_callbackQueue, ^{
            success(cachedList);
        });
    });
}

- (void)youtubePagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(NSString *)cacheKey request:(SKExtendableListRequest)request success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure {

    dispatch_async(_workerQueue, ^{
        SKYoutubeExtendableList *cachedExtendableList = [_cache objectForKey:cacheKey];
        
        if( refresh || (!cachedExtendableList) ) {
            cachedExtendableList = [[SKYoutubeExtendableList alloc] init];
            [_cache setObject:cachedExtendableList forKey:cacheKey];
        }
        
        if( extend && !cachedExtendableList.finished ) {
            SKYoutubePagedListResponse *response = request(cachedExtendableList.nextPageToken);
            
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


- (nonnull NSString *)cacheKeyWithElements:(NSUInteger)numberOfElements, ... {
    NSMutableString *newContentString = [NSMutableString string];
    
    va_list args;
    va_start(args, numberOfElements);
    for(int i=0; i<numberOfElements; i++) {
        if(i>0) {
            [newContentString appendString:@"/"];
        }
        
        NSString *arg = va_arg(args, NSString*);
        if(arg) {
            [newContentString appendString:arg];
        }
    }
    va_end(args);
    
    return newContentString;
}

+ (nonnull SKYoutubeListResponse *)listGuideCategories:(nonnull NSString *)key part:(nonnull NSString *)part locale:(nonnull NSLocale *)locale {
    
    NSString *region = [locale objectForKey: NSLocaleCountryCode];
    
    NSDictionary *parameter = @{
                                @"key" : key,
                                @"part" : part,
                                @"regionCode" : region
                                };
    
    return (SKYoutubeListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/guideCategories" andParameter:parameter];
}

+ (nonnull SKYoutubePagedListResponse *)listChannels:(nonnull NSString *)key part:(nonnull NSString *)part category:(nullable NSString *)category pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
    NSDictionary *basicParameter = @{
                                     @"key" : key,
                                     @"part" : part,
                                     @"type" : @"video",
                                     @"maxResults" : @(pageSize)
                                     };
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:basicParameter];
    
    if(pageCode) {
        [parameter setObject:pageCode forKey:@"pageToken"];
    }
    
    if(category) {
        [parameter setObject:category forKey:@"categoryId"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/channels" andParameter:parameter];
}

+ (nonnull SKYoutubePagedListResponse *)searchVideos:(nonnull NSString *)key query:(nullable NSString *)query part:(nonnull NSString *)part category:(nullable NSString *)category pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
    NSDictionary *basicParameter = @{
                                     @"key" : key,
                                     @"part" : part,
                                     @"type" : @"video",
                                     @"maxResults" : @(pageSize)
                                     };
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:basicParameter];
    
    if(pageCode) {
        [parameter setObject:pageCode forKey:@"pageToken"];
    }
    
    if(category) {
        [parameter setObject:category forKey:@"videoCategoryId"];
    }
    
    if(query) {
        [parameter setObject:query forKey:@"q"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/search" andParameter:parameter];
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
