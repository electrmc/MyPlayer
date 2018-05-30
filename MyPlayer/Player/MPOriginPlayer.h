//
//  MPOriginPlayer.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MPOriginPlayer : NSObject

// 独占模式
@property (nonatomic, assign, readonly) BOOL isSingleMode;

// 是否关联耳机
@property (nonatomic, assign, readonly) BOOL isBindEarPhone;

@property (nonatomic, strong, readonly) NSURL *playURL;

// 是否循环播放
@property (nonatomic, assign) BOOL isLoopPlay;

/// 当前播放歌曲图片
@property (nonatomic, strong) UIImage *m_coverImg;

/// 播放器播放状态
@property (nonatomic, assign) BOOL m_isPlaying;

/// 播放进度
@property (nonatomic, assign) CGFloat m_progress;

/// 当前播放时间(秒)
@property (nonatomic, assign) CGFloat m_playTime;

/// 总时长(秒)
@property (nonatomic, assign) CGFloat m_playDuration;

// === 一些回调
@property (nonatomic, copy) void(^statusChangedBlock)(MPOriginPlayer *player);
@property (nonatomic, copy) void(^timeChangedBlock)(MPOriginPlayer *player);


- (instancetype)initWithAudioURL:(NSURL *)url;

- (instancetype)initWithAudioURL:(NSURL *)url singleModel:(BOOL)shouldSingle stopByEarphone:(BOOL)bindEarphone;

/// 开始播放
- (void)play;
/// 从指定位置播放
- (void)seekTo:(CGFloat)progress;
/// 从指定时间播放
- (void)seekToTime:(NSTimeInterval)time;
/// 暂停播放
- (void)pause;
/// 停止
- (void)stopPlay;
// 调整音量
- (void)changeVolume:(CGFloat)progress;

@end
