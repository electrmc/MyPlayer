//
//  MPPlayerController.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPPlayerController.h"
#import "MPAudioBasicInfo.h"
#import "MPOriginPlayer.h"
#import "MPPlayerCenter.h"

@interface MPPlayerController ()

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *previousBtn;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) MPAudioBasicInfo *currentAudioInfo;
@property (nonatomic, strong) NSMutableArray<MPAudioBasicInfo*> *audioList;
@end

@implementation MPPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor lightGrayColor];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.previousBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setPlayIndex:(NSUInteger)index {
    self.currentIndex = index;
    self.player = nil;
}

- (void)play:(UIButton*)btn {
    if (self.player.m_isPlaying) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (void)setAudioModelList:(NSArray *)audioList {
    self.audioList = [NSMutableArray arrayWithArray:audioList];
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player stopPlay];
}

- (void)seekTo:(NSTimeInterval)time {
    [self.player seekTo:time];
}

- (void)next {
    self.currentIndex++;
    self.player = nil;
    [self.player play];
}

- (void)previous {
    self.currentIndex--;
    self.player = nil;
    [self.player play];
}

#pragma mark - Get method
- (MPOriginPlayer*)player {
    if (!_player) {
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:self.currentAudioInfo.filePath];
        _player = [[MPOriginPlayer alloc] initWithAudioURL:[NSURL fileURLWithPath:filePath]];
    }
    return _player;
}

- (MPAudioBasicInfo*)currentAudioInfo {
    if (self.currentIndex < 0 || self.currentIndex > self.audioList.count - 1) {
        self.currentIndex = 0;
    }
    if (self.currentIndex < self.audioList.count) {
        return self.audioList[self.currentIndex];
    } else {
        return nil;
    }
}

- (UIButton*)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
        _playBtn.frame = CGRectMake(100, 100, 80, 30);
        [_playBtn setBackgroundColor:[UIColor cyanColor]];
        [_playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton*)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_nextBtn setTitle:@"next" forState:UIControlStateNormal];
        _nextBtn.frame = CGRectMake(100, 200, 80, 30);
        [_nextBtn setBackgroundColor:[UIColor cyanColor]];
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton*)previousBtn {
    if (!_previousBtn) {
        _previousBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_previousBtn setTitle:@"previous" forState:UIControlStateNormal];
        _previousBtn.frame = CGRectMake(100, 300, 80, 30);
        [_previousBtn setBackgroundColor:[UIColor cyanColor]];
        [_previousBtn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousBtn;
}

#pragma mark - PlayerCenterDelegate
- (void)playCenterPlay {
    [self play];
}

- (void)playCenterPause {
    [self pause];
}

- (void)playCenterStop {
    [self stop];
}

- (void)playCenterNext {
    [self next];
}

- (void)playCenterPrevious{
    [self previous];
}

- (void)playCenterSeekTo:(NSTimeInterval)time {
    [self seekTo:time];
}
@end
