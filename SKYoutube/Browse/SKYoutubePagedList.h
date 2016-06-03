//
//  SKYoutubePagedList.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@class SKYoutubePagedListResponse;

@interface SKYoutubePagedList : NSObject<SKPagedList>

@property(nonatomic, copy, readonly, nullable) NSString *next;

- (nonnull instancetype)initWithResponse:(nonnull SKYoutubePagedListResponse *)response;

@end
