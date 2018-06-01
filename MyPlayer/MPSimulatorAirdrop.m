//
//  MPSimulatorAirdrop.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSimulatorAirdrop.h"
#import "MPAudioReceiver.h"

@interface MPSimulatorAirdrop()
@property (nonatomic, strong) NSArray *audioFiles;
@end

@implementation MPSimulatorAirdrop

- (void)simulateAirdrop {
    for (NSString *filepath in self.audioFiles) {
        NSURL *url = [NSURL fileURLWithPath:filepath];
        [MPAudioReceiver moveFileToDestDirInOriginDir:url];
    }
}

- (NSArray*)audioFiles {
    if (!_audioFiles) {
        _audioFiles = @[@"/Users/miaochao/Desktop/MyPlayer/样例音乐/痛仰乐队\ -\ 再见杰克.mp3",
                        @"/Users/miaochao/Desktop/MyPlayer/样例音乐/王建房\ -\ 我的梦想在路上.mp3",
                        @"/Users/miaochao/Desktop/MyPlayer/样例音乐/Ryan.B\,AY楊佬叁\ -\ 再也没有.mp3"];
    }
    return _audioFiles;
}

@end
