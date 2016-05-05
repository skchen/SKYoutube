//
//  SKYoutubeResponse.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeResponse.h"

static NSString * const kKeyKind = @"kind";
static NSString * const kKeyTag = @"etag";

@implementation SKYoutubeResponse

- (nullable instancetype)initWithData:(nonnull NSData *)data {
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(!error && json) {
        return [self initWithDictionary:json];
    }
    
    return nil;
}

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _kind = [dictionary objectForKey:kKeyKind];
    _tag = [dictionary objectForKey:kKeyTag];
    
    return self;
}

@end
