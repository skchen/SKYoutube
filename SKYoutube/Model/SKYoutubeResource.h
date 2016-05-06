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
    NSString *_id;
}

@property(nonatomic, copy, readonly, nonnull) NSString *id;
@property(nonatomic, copy, readonly, nullable) SKYoutubeSnippet *snippet;

@property(nonatomic, copy, readonly, nullable) NSString *title;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
