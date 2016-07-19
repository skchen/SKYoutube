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
    
    _state = SKPlayerStopped;
    
    return self;
}

- (nonnull instancetype)initWithView:(nonnull UIView *)view {
    self = [super init];
    
    _innerPlayer = [[YTPlayerView alloc] initWithFrame:view.bounds];
    _innerPlayer.delegate = self;
    [view addSubview:_innerPlayer];
    
    _workerQueue = dispatch_get_main_queue();
    
    _state = SKPlayerStopped;
    
    return self;
}

#pragma mark - Override

- (void)setWorkerQueue:(dispatch_queue_t)workerQueue {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Change of worker queue is not allowed for %@", NSStringFromClass([self class])]
                                 userInfo:nil];
}

#pragma mark - State

- (void)start:(SKErrorCallback)callback {
    SKErrorCallback wrappedCallback = ^(NSError * _Nullable error) {
        dispatch_async(self.callbackQueue, ^{
            callback(error);
        });
    };
    
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerStopped:
                [self _start:wrappedCallback];
                break;
                
            case SKPlayerPaused:
                [self _resume:wrappedCallback];
                break;
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

- (void)pause:(SKErrorCallback)callback {
    SKErrorCallback wrappedCallback = ^(NSError * _Nullable error) {
        dispatch_async(self.callbackQueue, ^{
            callback(error);
        });
    };
    
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerPlaying:
                [self _pause:wrappedCallback];
                break;
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

- (void)stop:(SKErrorCallback)callback {
    SKErrorCallback wrappedCallback = ^(NSError * _Nullable error) {
        dispatch_async(self.callbackQueue, ^{
            callback(error);
        });
    };
    
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerPlaying:
            case SKPlayerPaused:
                [self _stop:wrappedCallback];
                break;
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

- (void)_start:(SKErrorCallback)callback {
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"origin" : @"http://localhost"
                                 };
    
    SKLog(@"loadWithVideoId:%@", _youtubeId);
    
    _startCallabck = callback;
    
    [_innerPlayer loadWithVideoId:_youtubeId playerVars:playerVars];
}

- (void)_resume:(SKErrorCallback)callback {
    [_innerPlayer playVideo];
    callback(nil);
}

- (void)_pause:(SKErrorCallback)callback {
    [_innerPlayer pauseVideo];
    callback(nil);
}

- (void)_stop:(SKErrorCallback)callback {
    [_innerPlayer stopVideo];
    callback(nil);
}

#pragma mark - Source

- (void)setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    __weak __typeof(self) weakSelf = self;
    
    switch (_state) {
        case SKPlayerStopped:
            [self _setSource:source callback:callback];
            break;
            
        case SKPlayerPaused:
        case SKPlayerPlaying: {
            [self stop:^(NSError * _Nullable error) {
                if(error) {
                    callback(error);
                } else {
                    [self setSource:source callback:^(NSError * _Nullable error) {
                        if(error) {
                            callback(error);
                        } else {
                            [weakSelf start:callback];
                        }
                    }];
                }
            }];
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

- (void)_setSource:(id)source callback:(SKErrorCallback)callback {
    _youtubeId = ((SKYoutubeResource *)source).id;
    
    dispatch_async(self.callbackQueue, ^{
        callback(nil);
        
        if([_delegate respondsToSelector:@selector(playerDidChangeSource:)]) {
            [_delegate playerDidChangeSource:self];
        }
    });
}

- (void)_seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    [_innerPlayer seekToSeconds:time allowSeekAhead:YES];
    success(time);
}

- (void)getProgress:(SKTimeCallback)success failure:(SKErrorCallback)failure {
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
    
    if(_startCallabck) {
        [self _resume:_startCallabck];
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    SKLog(@"didChangeToState:%@", @(state));
    
    switch(state) {
        case kYTPlayerStatePlaying:
            [self changeState:SKPlayerPlaying callback:nil];
            break;
            
        case kYTPlayerStatePaused:
            [self changeState:SKPlayerPaused callback:nil];
            break;
            
        case kYTPlayerStateQueued:
            [self changeState:SKPlayerStopped callback:nil];
            break;
            
        case kYTPlayerStateEnded:
            [self changeState:SKPlayerStopped callback:nil];
            [self playbackDidComplete:_source];
            break;
            
        default:
            break;
    }
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    SKLog(@"receivedError:%@", @(error));
    
    if(_startCallabck) {
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
