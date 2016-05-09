//
//  SKYoutubeSnippet.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeSnippet.h"

static NSString * const kKeySnippetTitle = @"title";

static NSString * const kKeySnippetResourceId = @"resourceId";

static NSString * const kResourceIdVideoId = @"videoId";

@interface SKYoutubeSnippet ()

@property(nonatomic, strong, readonly, nonnull) NSDictionary *dictionary;

@end

@implementation SKYoutubeSnippet

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _dictionary = dictionary;
    
    return self;
}

- (nullable NSString *)title {
    return [_dictionary objectForKey:kKeySnippetTitle];
}

- (nullable NSString *)videoId {
    NSDictionary *resourceId = [_dictionary objectForKey:kKeySnippetResourceId];
    return [resourceId objectForKey:kResourceIdVideoId];
}

@end
