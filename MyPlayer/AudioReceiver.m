//
//  AudioReceiver.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "AudioReceiver.h"
#import "BasicInfoDB.h"
#import "AudioModel.h"
#import "LogMacroUtils.h"

static NSString * const DestDirStr = @"/Documents/Audio";
@implementation AudioReceiver

+ (BOOL)moveFileToDestDirInOriginDir:(NSURL*)scrUrl {
    if (!scrUrl) {
        return NO;
    }
    NSInteger timestamp = [self getTimestamp];
    NSString *desStr = [NSString stringWithFormat:@"%@/%ld",[self destDir],(long)timestamp];
    NSURL *destUrl = [NSURL fileURLWithPath:desStr];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![manager moveItemAtURL:scrUrl toURL:destUrl error:&error]) {
        MPLog(@"%@",error);
        return NO;
    }
    
    // 获取歌曲名和作者
    BasicInfoItem *item = [[BasicInfoItem alloc] init];
    item.primaryKey = timestamp;
    item.name = @"123";
    item.author = @"456";
    [BasicInfoDB insertItem:item];
    return YES;
}

+ (NSInteger)getTimestamp {
    NSDate *nowDate = [NSDate date];
    double timestamp = (double)[nowDate timeIntervalSince1970]*1000;
    return  [[NSNumber numberWithDouble:timestamp] integerValue];
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
