//
//  SKYoutubePlayer.m
//  SKYoutubePlayer
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubePlayer.h"

@import SKUtils;

#import "YTPlayerView.h"

@interface SKYoutubePlayer () <YTPlayerViewDelegate>

@property(nonatomic, strong, nonnull) YTPlayerView *innerPlayer;
@property(nonatomic, assign) int progress;
@property(nonatomic, copy, nullable) NSString *youtubeId;
@property(nonatomic, copy) dispatch_semaphore_t semaphore;

@end

@implementation SKYoutubePlayer

- (nonnull instancetype)init {
    self = [super init];
    
    _innerPlayer = [[YTPlayerView alloc] init];
    _innerPlayer.delegate = self;
    
    return self;
}

#pragma mark - Abstract

- (nullable NSError *)_setDataSource:(nonnull NSString *)source {
    _youtubeId = source;
    return nil;
}

- (nullable NSError *)_prepare {
    _semaphore = dispatch_semaphore_create(0);
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1
                                 };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_innerPlayer loadWithVideoId:_youtubeId playerVars:playerVars];
    });
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    return nil;
}

- (nullable NSError *)_start {
    [self executeBlockingWiseInMainThread:^{
        [_innerPlayer playVideo];
    }];
    
    return nil;
}

- (nullable NSError *)_pause {
    [self executeBlockingWiseInMainThread:^{
        [_innerPlayer pauseVideo];
    }];
    
    return nil;
}

- (nullable NSError *)_stop {
    [self executeBlockingWiseInMainThread:^{
        [_innerPlayer stopVideo];
    }];
    
    return nil;
}

- (nullable NSError *)_seekTo:(int)msec {
    float seekTime = (float)msec/1000;
    [self executeBlockingWiseInMainThread:^{
        [_innerPlayer seekToSeconds:seekTime allowSeekAhead:YES];
    }];
    
    return nil;
}

- (int)getCurrentPosition {
    return _progress;
}

- (int)getDuration {
    return (int)round(_innerPlayer.duration*1000);
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView {
    dispatch_semaphore_signal(_semaphore);
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    _progress = round(playTime*1000);
}

#pragma mark - Misc 

- (void)executeBlockingWiseInMainThread:(void (^_Nonnull)(void))task; {
    _semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        task();
        dispatch_semaphore_signal(_semaphore);
    });
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

@end
