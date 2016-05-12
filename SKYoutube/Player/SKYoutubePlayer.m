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

// #define VERBOSE

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

- (nonnull instancetype)initWithView:(nonnull UIView *)view {
    self = [super init];
    
    _innerPlayer = [[YTPlayerView alloc] initWithFrame:view.bounds];
    _innerPlayer.delegate = self;
    [view addSubview:_innerPlayer];
    
    return self;
}

#pragma mark - Abstract

- (nullable NSError *)_setDataSource:(nonnull NSString *)source {
    _youtubeId = ((SKYoutubeResource *)source).videoId;
    return nil;
}

- (nullable NSError *)_prepare {
    _semaphore = dispatch_semaphore_create(0);
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"origin" : @"http://localhost"
                                 };
    
    dispatch_async(dispatch_get_main_queue(), ^{
#ifdef VERBOSE
        NSLog(@"loadWithVideoId:%@", _youtubeId);
#endif
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
        _progress = 0;
    }];
    
    return nil;
}

- (nullable NSError *)_seekTo:(int)msec {
    float seekTime = (float)msec/1000;
    [self executeBlockingWiseInMainThread:^{
        [_innerPlayer seekToSeconds:seekTime allowSeekAhead:YES];
        _progress = msec;
    }];
    
    return nil;
}

- (int)getCurrentPosition {
    return _progress;
}

- (int)getDuration {
    NSTimeInterval rawDuration;
    NSTimeInterval *rawDurationPointer = &rawDuration;
    
    [self executeBlockingWiseInMainThread:^{
        *rawDurationPointer = _innerPlayer.duration;
    }];
    
    return (int)round(rawDuration*1000);
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView {
#ifdef VERBOSE
    NSLog(@"playerViewDidBecomeReady");
#endif
    dispatch_semaphore_signal(_semaphore);
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
#ifdef VERBOSE
    NSLog(@"didChangeToState:%@", @(state));
#endif
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
#ifdef VERBOSE
    NSLog(@"receivedError:%@", @(error));
#endif
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
#ifdef VERBOSE
    NSLog(@"didPlayTime: %@", @(playTime));
#endif
    if([self isPlaying]) {
        _progress = round(playTime*1000);
    }
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
