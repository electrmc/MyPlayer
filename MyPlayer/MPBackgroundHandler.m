//
//  MPBackgroundHandler.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/1.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPBackgroundHandler.h"
#import <AVFoundation/AVFoundation.h>

@implementation MPBackgroundHandler

//实现一下backgroundPlayerID:这个方法:
- (UIBackgroundTaskIdentifier)setBackgroundPlay:(UIBackgroundTaskIdentifier)backTaskId {
    
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)handleRemoteEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                //点击播放按钮或者耳机线控中间那个按钮
                break;
            case UIEventSubtypeRemoteControlPause:
                //点击暂停按钮
                break;
            case UIEventSubtypeRemoteControlStop:
                //点击停止按钮
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //点击播放与暂停开关按钮(iphone抽屉中使用这个)
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //点击下一曲按钮或者耳机中间按钮两下
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //点击上一曲按钮或者耳机中间按钮三下
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                //快退开始 点击耳机中间按钮三下不放开
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                //快退结束 耳机快退控制松开后
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                //开始快进 耳机中间按钮两下不放开
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                //快进结束 耳机快进操作松开后
                break;
            default:
                break;
        }
    }
}

@end
