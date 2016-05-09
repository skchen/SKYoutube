//
//  SKYoutubeResource.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeObject.h"

#import "SKYoutubeSnippet.h"

@interface SKYoutubeResource : SKYoutubeObject {
@protected
    id _id;
}

@property(nonatomic, copy, readonly, nonnull) id id;
@property(nonatomic, copy, readonly, nullable) SKYoutubeSnippet *snippet;

@property(nonatomic, copy, readonly, nullable) NSString *title;
@property(nonatomic, copy, readonly, nullable) NSString *videoId;

- (nonnull instancetype)initWithId:(nonnull NSString *)id;
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
