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

@interface MPPlayerController ()

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) MPAudioBasicInfo *audioInfo;

@end

@implementation MPPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor lightGrayColor];
    [self.view addSubview:self.playBtn];
}

- (void)play:(UIButton*)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)setAudioModel:(MPAudioBasicInfo*)audioinfo {
    self.audioInfo = audioinfo;
}

#pragma mark - Get method
- (MPOriginPlayer*)player {
    if (!_player) {
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:self.audioInfo.filePath];
        _player = [[MPOriginPlayer alloc] initWithAudioURL:[NSURL fileURLWithPath:filePath]];
    }
    return _player;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
