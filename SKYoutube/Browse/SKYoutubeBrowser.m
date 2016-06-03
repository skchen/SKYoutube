//
//  SKYoutubeBrowser.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeBrowser.h"

#import "SKYoutubeConnection.h"
#import "SKYoutubeResource.h"
#import "SKYoutubePagedList.h"

static NSString * const kCacheKeyGuideCategories = @"guideCategories";
static NSString * const kCacheKeySearch = @"search";
static NSString * const kCacheKeyPlaylist = @"playlist";
static NSString * const kCacheKeyPlaylistItem = @"playlistItems";
static NSString * const kCacheKeyVideoCategories = @"videoCategories";
static NSString * const kCacheKeyMostPopular = @"mostPopular";

typedef SKYoutubePagedListResponse* (^SKExtendableListRequest)(NSString * _Nullable pageCode);
typedef SKYoutubeListResponse* (^SKListRequest)(void);

@interface SKYoutubeBrowser ()

@property(nonatomic, copy, readonly, nonnull) NSString *key;
@property(nonatomic, copy, readonly, nonnull) NSLocale *locale;

@end

@implementation SKYoutubeBrowser

- (nonnull instancetype)initWithKey:(nonnull NSString *)key andLocale:(nullable NSLocale *)locale {
    self = [super init];
    _key = key;
    
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

- (void)listChannels:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [SKCachedAsync cacheKeyWithElements:2, kCacheKeySearch, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listChannels:_key part:@"snippet" category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)listPlaylists:(BOOL)refresh extend:(BOOL)extend channel:(nonnull SKYoutubeResource *)channel success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [SKCachedAsync cacheKeyWithElements:2, kCacheKeyPlaylist, channel.id];

    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listPlaylists:_key part:@"snippet" channelId:channel.id pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)searchVideos:(BOOL)refresh extend:(BOOL)extend query:(nullable NSString *)query channel:(nullable NSString *)channel category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [SKCachedAsync cacheKeyWithElements:4, kCacheKeySearch, query, channel, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser searchVideos:_key query:query part:@"snippet" channel:channel category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    [self youtubeList:refresh cacheKey:kCacheKeyVideoCategories request:^SKYoutubeListResponse *{
        return [SKYoutubeBrowser listVideoCategories:_key part:@"snippet" locale:_locale];
    } success:success failure:failure];
}

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    NSString *cacheKey = [SKCachedAsync cacheKeyWithElements:2, kCacheKeyMostPopular, category];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listVideos:_key part:@"snippet" chart:@"mostPopular" category:category pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)listVideos:(BOOL)refresh extend:(BOOL)extend playlist:(nonnull SKYoutubeResource *)playlist success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {

    NSString *cacheKey = [SKCachedAsync cacheKeyWithElements:2, kCacheKeyPlaylistItem, playlist.id];
    
    [self youtubePagedList:refresh extend:extend cacheKey:cacheKey request:^SKYoutubePagedListResponse *(NSString * _Nullable pageCode) {
        return [SKYoutubeBrowser listPlaylistItems:_key part:@"snippet" playlistId:playlist.id pageSize:50 pageCode:pageCode];
    } success:success failure:failure];
}

- (void)youtubeList:(BOOL)refresh cacheKey:(NSString *)cacheKey request:(SKListRequest)request success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    [self cache:refresh cacheKey:cacheKey request:^id _Nullable(NSError *__autoreleasing  _Nullable * _Nullable errorPtr) {
        SKYoutubeListResponse *response = request();
        
        if(response) {
            return response.items;
        } else {
            *errorPtr = [NSError errorWithDomain:@"Unable to get response" code:0 userInfo:nil];
            return nil;
        }
    } success:success failure:failure];
}

- (void)youtubePagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(NSString *)cacheKey request:(SKExtendableListRequest)request success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    [self pagedList:refresh extend:extend cacheKey:cacheKey request:^id<SKPagedList> _Nullable(id<SKPagedList>  _Nullable pagedList, NSError *__autoreleasing  _Nullable * _Nullable errorPtr) {
        
        SKYoutubePagedListResponse *response = request(((SKYoutubePagedList *)pagedList).next);
        
        if(response) {
            return [[SKYoutubePagedList alloc] initWithResponse:response];
        } else {
            *errorPtr = [NSError errorWithDomain:@"Unable to get response" code:0 userInfo:nil];
            return nil;
        }
    } success:success failure:failure];
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

+ (nonnull SKYoutubePagedListResponse *)listPlaylists:(nonnull NSString *)key part:(nonnull NSString *)part channelId:(nonnull NSString *)channelId pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
    NSDictionary *basicParameter = @{
                                     @"key" : key,
                                     @"part" : part,
                                     @"channelId" : channelId,
                                     @"maxResults" : @(pageSize)
                                     };
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:basicParameter];
    
    if(pageCode) {
        [parameter setObject:pageCode forKey:@"pageToken"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/playlists" andParameter:parameter];
}

+ (nonnull SKYoutubePagedListResponse *)listPlaylistItems:(nonnull NSString *)key part:(nonnull NSString *)part playlistId:(nonnull NSString *)playlistId pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
    NSDictionary *basicParameter = @{
                                     @"key" : key,
                                     @"part" : part,
                                     @"playlistId" : playlistId,
                                     @"maxResults" : @(pageSize)
                                     };
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:basicParameter];
    
    if(pageCode) {
        [parameter setObject:pageCode forKey:@"pageToken"];
    }
    
    return (SKYoutubePagedListResponse *)[SKYoutubeConnection objectForApi:@"youtube/v3/playlistItems" andParameter:parameter];
}

+ (nonnull SKYoutubePagedListResponse *)searchVideos:(nonnull NSString *)key query:(nullable NSString *)query part:(nonnull NSString *)part channel:(nullable NSString *)channel category:(nullable NSString *)category pageSize:(NSUInteger)pageSize pageCode:(nullable NSString *)pageCode {
    
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
    
    if(channel) {
        [parameter setObject:channel forKey:@"channelId"];
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
