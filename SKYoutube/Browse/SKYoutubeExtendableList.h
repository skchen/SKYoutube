//
//  SKYoutubeExtendableList.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKYoutubePagedListResponse.h"

@interface SKYoutubeExtendableList : NSObject

@property(nonatomic, copy, readonly, nullable) NSString *nextPageToken;
@property(nonatomic, copy, readonly, nonnull) NSArray *objects;
@property(nonatomic, readonly) BOOL finished;

- (void)addObjectsByResponse:(nonnull SKYoutubePagedListResponse *)response;

@end
