//
//  AudioReceiver.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DidReceiveAudioFileNotification;

@interface AudioReceiver : NSObject
+ (BOOL)moveFileToDestDirInOriginDir:(NSURL*)originUrl;
@end
