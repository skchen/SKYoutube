//
//  ViewController.h
//  SKYoutubePlayer
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKUtils/SKUtils.h>

@interface SKYoutubePlayerViewController : SKListPlayerViewController

@property(nonatomic, strong, nonnull) NSArray *list;
@property(nonatomic, assign) NSUInteger index;

@end

