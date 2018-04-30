//
//  AudioReceiver.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "AudioReceiver.h"
#import "BasicInfoDB.h"
#import "LogMacroUtils.h"

static NSString * const DestDirStr = @"/Documents/Music/";
@implementation AudioReceiver

+ (BOOL)moveFileToDestDirInOriginDir:(NSURL*)originUrl {
    NSString *timestamp = [self getTimestamp];
    NSString *desStr = [NSString stringWithFormat:@"%@%@",[self destDir],timestamp];
    NSURL *destUrl = [NSURL fileURLWithPath:desStr];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![manager moveItemAtURL:originUrl toURL:destUrl error:&error]) {
        MPLog(@"%@",error);
        return NO;
    }
    
    // 更新数据库
    
    return YES;
}

/// 根据时间戳命名
+ (NSString *)getTimestamp {
    NSDate *nowDate = [NSDate date];
    double timestamp = (double)[nowDate timeIntervalSince1970]*1000;
    long nowTimestamp = [[NSNumber numberWithDouble:timestamp] longValue];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld",nowTimestamp];
    return timestampStr;
}

+ (NSString*)destDir {
    NSString *destDir = [NSHomeDirectory() stringByAppendingPathComponent:DestDirStr];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:destDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        BOOL res = [fileManager createDirectoryAtPath:destDir
                          withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            return destDir;
        } else {
            return nil;
        }
    }
    return destDir;
}

@end
