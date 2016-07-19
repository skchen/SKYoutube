//
//  SKYoutubePlayer.m
//  SKYoutubePlayer
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubePlayer.h"

#import "YTPlayerView.h"

#import "SKYoutubeResource.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

@interface SKYoutubePlayer () <YTPlayerViewDelegate>

@property(nonatomic, strong, nonnull) YTPlayerView *innerPlayer;
@property(nonatomic, assign) int progress;
@property(nonatomic, copy, nullable) NSString *youtubeId;
@property(nonatomic, copy, nullable) SKErrorCallback prepareCallabck;
@property(nonatomic, copy, nullable) SKErrorCallback startCallabck;
@property(nonatomic, copy, nullable) SKErrorCallback pauseCallabck;
@property(nonatomic, copy, nullable) SKErrorCallback stopCallabck;

@end

@implementation SKYoutubePlayer

- (nonnull instancetype)init {
    self = [super init];
    
    _innerPlayer = [[YTPlayerView alloc] init];
    _innerPlayer.delegate = self;
    
    _workerQueue = dispatch_get_main_queue();
    
    return self;
}

- (nonnull instancetype)initWithView:(nonnull UIView *)view {
    self = [super init];
    
    _innerPlayer = [[YTPlayerView alloc] initWithFrame:view.bounds];
    _innerPlayer.delegate = self;
    [view addSubview:_innerPlayer];
    
    _workerQueue = dispatch_get_main_queue();
    
    return self;
}

#pragma mark - Override

- (void)setWorkerQueue:(dispatch_queue_t)workerQueue {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Change of worker queue is not allowed for %@", NSStringFromClass([self class])]
                                 userInfo:nil];
}

#pragma mark - Abstract

- (void)_setDataSource:(nonnull NSString *)source {
    _youtubeId = ((SKYoutubeResource *)source).videoId;
}

- (void)_prepare:(SKErrorCallback)callback {
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"origin" : @"http://localhost"
                                 };
    
    SKLog(@"loadWithVideoId:%@", _youtubeId);
    
    _prepareCallabck = callback;
    
    [_innerPlayer loadWithVideoId:_youtubeId playerVars:playerVars];
}

- (void)_start:(SKErrorCallback)callback {
    _startCallabck = callback;
    [_innerPlayer playVideo];
}

- (void)_pause:(SKErrorCallback)callback {
    _pauseCallabck = callback;
    [_innerPlayer pauseVideo];
}

- (void)_stop:(SKErrorCallback)callback {
    _stopCallabck = callback;
    [_innerPlayer stopVideo];
}

- (void)_seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    [_innerPlayer seekToSeconds:time allowSeekAhead:YES];
    success(time);
}

- (void)getCurrentPosition:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(_callbackQueue, ^{
        success(_progress);
    });
}

- (void)getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(_workerQueue, ^{
        NSTimeInterval duration = _innerPlayer.duration;
        
        dispatch_async(_callbackQueue, ^{
            success(duration);
        });
    });
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView {
    SKLog(@"playerViewDidBecomeReady");
    
    if(_prepareCallabck) {
        _prepareCallabck(nil);
        _prepareCallabck = nil;
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    SKLog(@"didChangeToState:%@", @(state));
    
    switch(state) {
        case kYTPlayerStatePlaying:
            if(_startCallabck) {
                _startCallabck(nil);
                _startCallabck = nil;
            }
            break;
            
        case kYTPlayerStatePaused:
            if(_pauseCallabck) {
                _pauseCallabck(nil);
                _pauseCallabck = nil;
            }
            break;
            
        case kYTPlayerStateQueued:
            if(_stopCallabck) {
                _stopCallabck(nil);
                _stopCallabck = nil;
            }
            break;
            
        case kYTPlayerStateEnded:
            [self playbackDidComplete:_source];
            break;
            
        default:
            break;
    }
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    SKLog(@"receivedError:%@", @(error));
    
    if(_prepareCallabck) {
        [self notifyErrorMessage:@"YTPlayerView error" callback:_prepareCallabck];
        _prepareCallabck = nil;
    } else if(_startCallabck) {
        [self notifyErrorMessage:@"YTPlayerView error" callback:_startCallabck];
        _startCallabck = nil;
    }
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    SKLog(@"didPlayTime: %@", @(playTime));
    
    if(_state==SKPlayerPlaying) {
        _progress = playTime;
    }
}

@end
