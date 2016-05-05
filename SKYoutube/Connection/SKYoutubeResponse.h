//
//  SKYoutubeResponse.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYoutubeResponse : NSObject

@property(nonatomic, copy, readonly, nonnull) NSString *kind;
@property(nonatomic, copy, readonly, nonnull) NSString *tag;

- (nullable instancetype)initWithData:(nonnull NSData *)data;
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
