//
//  SKYoutubeResource.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeResource.h"

@implementation SKYoutubeResource

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    return self;
}

- (nullable NSString *)title {
    return _snippet.title;
}

@end
