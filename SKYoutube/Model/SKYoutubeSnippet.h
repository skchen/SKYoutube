//
//  SKYoutubeSnippet.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYoutubeSnippet : NSObject

@property(nonatomic, copy, readonly, nullable) NSString *title;
@property(nonatomic, copy, readonly, nullable) NSString *videoId;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
