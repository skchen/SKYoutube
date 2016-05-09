//
//  SKYoutubeObject.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeObject.h"

static NSString * const kKeyKind = @"kind";
static NSString * const kKeyTag = @"etag";

static NSString * const kKindChannelListResponse = @"youtube#channelListResponse";
static NSString * const kKindGuideCategoryListResponse = @"youtube#guideCategoryListResponse";
static NSString * const kKindPlaylistListResponse = @"youtube#playlistListResponse";
static NSString * const kKindPlaylistItemListResponse = @"youtube#playlistItemListResponse";
static NSString * const kKindSearchListResponse = @"youtube#searchListResponse";
static NSString * const kKindVideoCategoryListResponse = @"youtube#videoCategoryListResponse";
static NSString * const kKindVideoListResponse = @"youtube#videoListResponse";

static NSString * const kKindChannel = @"youtube#channel";
static NSString * const kKindGuideCategory = @"youtube#guideCategory";
static NSString * const kKindPlaylist = @"youtube#playlist";
static NSString * const kKindPlaylistItem = @"youtube#playlistItem";
static NSString * const kKindSearchResult = @"youtube#searchResult";
static NSString * const kKindVideoCategory = @"youtube#videoCategory";
static NSString * const kKindVideo = @"youtube#video";

static NSString * const kClassListResponse = @"SKYoutubeListResponse";
static NSString * const kClassPagedListResponse = @"SKYoutubePagedListResponse";
static NSString * const kClassResource = @"SKYoutubeResource";

@implementation SKYoutubeObject

+ (nullable NSString *)classNameForDictioanry:(nonnull NSDictionary *)dictionary {
    NSString *kind = [dictionary objectForKey:kKeyKind];
    if(kind) {
        return [SKYoutubeObject classNameForKind:kind];
    }
    return nil;
}

+ (nullable NSString *)classNameForKind:(nonnull NSString *)kind {
    NSDictionary *mapping = @{
                              kKindChannelListResponse : kClassPagedListResponse,
                              kKindGuideCategoryListResponse : kClassListResponse,
                              kKindPlaylistListResponse : kClassPagedListResponse,
                              kKindPlaylistItemListResponse : kClassPagedListResponse,
                              kKindSearchListResponse : kClassPagedListResponse,
                              kKindVideoCategoryListResponse : kClassListResponse,
                              kKindVideoListResponse : kClassPagedListResponse,
                              
                              kKindChannel : kClassResource,
                              kKindGuideCategory : kClassResource,
                              kKindPlaylist : kClassResource,
                              kKindPlaylistItem : kClassResource,
                              kKindSearchResult : kClassResource,
                              kKindVideoCategory : kClassResource,
                              kKindVideo : kClassResource
                              };
    
    NSString *className = [mapping objectForKey:kind];
    
    if(!className) {
        NSLog(@"Unrecognized kind: %@", kind);
    }
    
    return className;
}

+ (nullable instancetype)objectWithDictionary:(nonnull NSDictionary *)dictionary {
    NSString *className = [SKYoutubeObject classNameForDictioanry:dictionary];
    
    if(className) {
        return [[NSClassFromString(className) alloc] initWithDictionary:dictionary];
    }
    
    return nil;
}

+ (nullable instancetype)objectWithData:(nonnull NSData *)data {
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(!error && json) {
        return [SKYoutubeObject objectWithDictionary:json];
    }
    
    return nil;
}

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _kind = [dictionary objectForKey:kKeyKind];
    _tag = [dictionary objectForKey:kKeyTag];
    
    return self;
}

- (BOOL)isChannel {
    return [_kind isEqualToString:kKindChannel];
}

- (BOOL)isPlaylist {
    return [_kind isEqualToString:kKindPlaylist];
}

- (BOOL)isPlaylistItem {
    return [_kind isEqualToString:kKindPlaylistItem];
}

- (BOOL)isSearchResult {
    return [_kind isEqualToString:kKindSearchResult];
}

- (BOOL)isVideo {
    return [_kind isEqualToString:kKindVideo];
}

@end
