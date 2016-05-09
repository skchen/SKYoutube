//
//  SKYoutubeResource.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeResource.h"

static NSString * const kKeyId = @"id";
static NSString * const kKeyTitle = @"title";
static NSString * const kKeySnippet = @"snippet";

static NSString * const kIdKeyId = @"videoId";

@implementation SKYoutubeResource

- (nonnull instancetype)initWithId:(nonnull NSString *)id {
    self = [super init];
    _id = id;
    _snippet = [[SKYoutubeSnippet alloc] initWithDictionary:@{kKeyTitle: id}];
    return self;
}

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    _id = [dictionary objectForKey:kKeyId];
    
    NSDictionary *snippetDictionary = [dictionary objectForKey:kKeySnippet];
    _snippet = [[SKYoutubeSnippet alloc] initWithDictionary:snippetDictionary];
    
    return self;
}

- (BOOL)isVideo {
    return ([self videoId]!=nil);
}

- (nullable NSString *)title {
    return _snippet.title;
}

- (nullable NSString *)videoId {
    if([super isVideo]) {
        return _id;
    } else if([super isSearchResult]) {
        return [_id objectForKey:kIdKeyId];
    }
    
    return [_snippet videoId];
}

- (nonnull NSString *)description {
    NSDictionary *info = @{
                           kKeyId : _id,
                           kKeyTitle : [self title]
                           };
    return info.description;
}

@end
