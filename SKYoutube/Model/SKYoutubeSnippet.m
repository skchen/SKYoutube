//
//  SKYoutubeSnippet.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeSnippet.h"

static NSString * const kKeySnippetTitle = @"title";

@interface SKYoutubeSnippet ()

@property(nonatomic, strong, readonly, nonnull) NSDictionary *dictionary;

@end

@implementation SKYoutubeSnippet

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _dictionary = dictionary;
    
    return self;
}

- (nonnull NSString *)title {
    return [_dictionary objectForKey:kKeySnippetTitle];
}

@end
