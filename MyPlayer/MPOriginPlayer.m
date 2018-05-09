//
//  MPOriginPlayer.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPOriginPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "WeakBlock.h"
#import "LogMacroUtils.h"

@interface MPOriginPlayer ()

@property (nonatomic, strong) NSURL *playURL;

@property (nonatomic, strong) AVPlayer *m_player;
// 独占模式
@property (nonatomic, assign) BOOL isSingleMode;
// 是否关联耳机
@property (nonatomic, assign) BOOL isBindEarPhone;

@end



@implementation MPOriginPlayer
{
    id m_timeObserve;
}

#pragma mark - Life Cycle
- (instancetype)initWithAudioURL:(NSURL *)url
{
    self = [self initWithAudioURL:url singleModel:YES stopByEarphone:YES];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithAudioURL:(NSURL *)url singleModel:(BOOL)shouldSingle stopByEarphone:(BOOL)bindEarphone
{
    self = [self init];
    if (self) {
        _isSingleMode = shouldSingle;
        _isBindEarPhone = bindEarphone;
        
        _playURL = url;
        AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
        _m_player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        
        //给当前歌曲添加监控
        [self addObserver];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.m_progress = 0;
        self.m_playTime = DBL_MAX;
        self.m_playDuration = DBL_MAX;
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method
/// 开始播放
- (void)play {
    [self.m_player play];
    self.m_isPlaying = YES;
}

/// 暂停播放
- (void)pause {
    [self.m_player pause];
    BOOL pre_isPlaying = self.m_isPlaying;
    self.m_isPlaying = NO;
}

/// 停止
- (void)stopPlay {
    [self.m_player pause];
    [self.m_player seekToTime:CMTimeMake(0, 1)];
    
    //重置进度
    self.m_progress = 0;
    self.m_playTime = DBL_MAX;
    self.m_playDuration = DBL_MAX;
    BOOL pre_isPlaying = self.m_isPlaying;
    self.m_isPlaying = NO;
}

/// 从slider 滑动的位置播放
- (void)seekTo:(CGFloat)progress {
    if (progress > 1.0) {
        return;
    }
    
    CGFloat time = progress * self.m_playDuration;
    [self seekToTime:time];
}

- (void)seekToTime:(NSTimeInterval)time
{
    // 循环播放特殊处理
    if (_isLoopPlay && time > _m_playDuration && _m_playDuration > 0) {
        time -= (NSInteger)(time / _m_playDuration) * _m_playDuration;
    }
    if (!_m_player && self.playURL) {
        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:self.playURL];
        _m_player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        //给当前歌曲添加监控
        [self addObserver];
    }
    if (!_m_player) {
        return;
    }
    
    [self.m_player seekToTime:CMTimeMake(time * 44100, 44100) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}


- (void)changeVolume:(CGFloat)progress
{
    progress = MIN(progress, 1.0);
    progress = MAX(progress, 0);
    NSArray *audioTracks = [self.m_player.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:progress atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [self.m_player.currentItem setAudioMix:audioMix];
}

#pragma mark - KVO
- (void)addObserver {
    
    AVPlayerItem *songItem = self.m_player.currentItem;
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    
    //更新播放器进度
    @MPWeakify(self);
    m_timeObserve = [self.m_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 100) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        if (current >= 0) {
            @MPStrongify(self);
            self.m_progress = current / self.m_playDuration;
            self.m_playTime = current;
            // maybe background play need use
            if (self.timeChangedBlock) {
                self.timeChangedBlock(self);
            }
        }
    }];
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    AVPlayerItem *songItem = self.m_player.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (m_timeObserve) {
        [self.m_player removeTimeObserver:m_timeObserve];
        m_timeObserve = nil;
    }
    
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self.m_player replaceCurrentItemWithPlayerItem:nil];
}

#pragma mark - Notification & KVO
- (void)playbackFinished:(NSNotification *)notice {
    self.m_isPlaying = NO;

    if ([notice.object isEqual:self.m_player.currentItem] && _isLoopPlay) {
        [_m_player seekToTime:CMTimeMake(0, 1)];
        [_m_player play];
    }
}

- (void)audioInterruption:(NSNotification *)notification {
    static BOOL shouldPlayAfterInterruption = NO;
    NSDictionary * interruptionDict = notification.userInfo;
    NSNumber * interruptionType = [interruptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    if (interruptionType.intValue == AVAudioSessionInterruptionTypeBegan) {
        if (self.m_isPlaying) {
            [self pause];
            shouldPlayAfterInterruption = YES;
        } else {
            shouldPlayAfterInterruption = NO;
        }
    } else if (interruptionType.intValue == AVAudioSessionInterruptionTypeEnded) {
        //在后台不能恢复播放
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            MPLog(@"APP在后台，不能继续播放");
        } else { //在前台继续播放
            if (shouldPlayAfterInterruption) {
                [self play];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        switch (self.m_player.status) {
            case AVPlayerStatusUnknown:
                MPLog(@"未知状态");
                break;
            case AVPlayerStatusReadyToPlay: {
                CMTime duration = item.duration;// 获取视频总长度
                self.m_playDuration = CMTimeGetSeconds(duration);
                if (self.m_playDuration <= 0 || isnan(self.m_playDuration)) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
                        [self removeObserver];
                    }
                } else {
                }
                MPLog(@"准备完毕");
            }
                break;
            case AVPlayerStatusFailed:
                MPLog(@"加载失败");
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    }
}

//// post notification
- (void)postNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

#pragma mark - Get Method
- (BOOL)isPlaying {
    return self.m_player.rate == 1;
}
@end
