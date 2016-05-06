//
//  SKYoutubeResource.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeResource.h"

static NSString * const kKeyId = @"id";
static NSString * const kKeySnippet = @"snippet";

@implementation SKYoutubeResource

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _id = [dictionary objectForKey:kKeyId];
    
    NSDictionary *snippetDictionary = [dictionary objectForKey:kKeySnippet];
    _snippet = [[SKYoutubeSnippet alloc] initWithDictionary:snippetDictionary];
    
    return self;
}

- (nullable NSString *)title {
    return _snippet.title;
}

@end
