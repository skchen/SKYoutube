//
//  SKYoutubePagedListResponse.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubePagedListResponse.h"

static NSString * const kKeyNextPageToken = @"nextPageToken";

@implementation SKYoutubePagedListResponse

- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    _nextPageToken = [dictionary objectForKey:kKeyNextPageToken];
    
    return self;
}

@end
