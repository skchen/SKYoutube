//
//  SKYoutubeListPlayer.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/12.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeListPlayer.h"

#import "SKYoutubePlayer.h"

@implementation SKYoutubeListPlayer

- (nonnull instancetype)initWithView:(nonnull UIView *)view {
    SKYoutubePlayer *innerPlayer = [[SKYoutubePlayer alloc] initWithView:view];
    self = [super initWithPlayer:innerPlayer];
    return self;
}

@end
