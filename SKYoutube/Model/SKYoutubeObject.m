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

static NSString * const kKindSearchListResponse = @"youtube#searchListResponse";
static NSString * const kKindVideoCategoryListResponse = @"youtube#videoCategoryListResponse";
static NSString * const kKindVideoListResponse = @"youtube#videoListResponse";

static NSString * const kClassListResponse = @"SKYoutubeListResponse";
static NSString * const kClassPagedListResponse = @"SKYoutubePagedListResponse";

static NSString * const kKindSearchResult = @"youtube#searchResult";

static NSString * const kKindVideoCategory = @"youtube#videoCategory";
static NSString * const kClassVideoCategory = @"SKYoutubeVideoCategory";

static NSString * const kKindVideo = @"youtube#video";
static NSString * const kClassVideo = @"SKYoutubeResource";

@implementation SKYoutubeObject

+ (nullable NSString *)classNameForDictioanry:(nonnull NSDictionary *)dictionary {
    NSString *kind = [dictionary objectForKey:kKeyKind];
    if(kind) {
        if([kind isEqualToString:kKindSearchResult]) {
            kind = kKindVideo;
        }
        
        return [SKYoutubeObject classNameForKind:kind];
    }
    return nil;
}

+ (nullable NSString *)classNameForKind:(nonnull NSString *)kind {
    NSDictionary *mapping = @{
                              kKindSearchListResponse : kClassPagedListResponse,
                              kKindVideoCategoryListResponse : kClassListResponse,
                              kKindVideoListResponse : kClassPagedListResponse,
                              
                              kKindVideoCategory : kClassVideoCategory,
                              kKindVideo : kClassVideo
                              };
    
    return [mapping objectForKey:kind];
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

@end
