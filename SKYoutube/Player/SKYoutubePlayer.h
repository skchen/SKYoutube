//
//  SKYoutubePlayer.h
//  SKYoutubePlayer
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKPlayer.h>

#import <UIKit/UIKit.h>
#import "SKYoutubeResource.h"

@interface SKYoutubePlayer : SKPlayer<SKYoutubeResource *>

- (nonnull instancetype)initWithView:(nonnull UIView *)view;

@end
