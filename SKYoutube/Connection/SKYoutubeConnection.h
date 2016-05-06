//
//  SKYoutubeConnection.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKYoutubePagedListResponse.h"

@interface SKYoutubeConnection : NSObject

+ (nonnull SKYoutubeObject *)objectForApi:(nonnull NSString *)api andParameter:(nullable NSDictionary *)parameter;

@end
