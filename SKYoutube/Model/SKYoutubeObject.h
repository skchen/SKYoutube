//
//  SKYoutubeObject.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYoutubeObject : NSObject {
    @protected
    NSString *_kind;
    NSString *_tag;
}

@property(nonatomic, copy, readonly, nonnull) NSString *kind;
@property(nonatomic, copy, readonly, nonnull) NSString *tag;

+ (nullable instancetype)objectWithDictionary:(nonnull NSDictionary *)dictionary;
+ (nullable instancetype)objectWithData:(nonnull NSData *)data;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

- (BOOL)isChannel;
- (BOOL)isVideo;

@end
