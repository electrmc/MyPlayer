//
//  AudioReceiver.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPAudioReceiver.h"
#import "LogMacroUtils.h"
#import "MPSQLExecutor.h"
#import "MPAudioMetadata.h"
#import "NSString+MPTools.h"
#import "MPAudioBasicInfo.h"

NSString * const DidReceiveAudioFileNotification = @"DidReceiveAudioFileNotification";

static NSString * const DestDirStr = @"/Documents/Audio";
static NSUInteger randomStrLength = 15;

@implementation MPAudioReceiver

+ (BOOL)moveFileToDestDirInOriginDir:(NSURL*)scrUrl {
    if (!scrUrl) {
        return NO;
    }
    
    NSString *fileName = [self getFileName:scrUrl];
    NSString *desStr = [NSString stringWithFormat:@"%@/%@",[self destDir],fileName];
    NSURL *destUrl = [NSURL fileURLWithPath:desStr];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![manager moveItemAtURL:scrUrl toURL:destUrl error:&error]) {
        MPLog(@"%@",error);
        return NO;
    }
    
    MPAudioMetadata *metadata = [[MPAudioMetadata alloc] initWithFile:desStr];
    MPAudioBasicInfo *item = [[MPAudioBasicInfo alloc] init];
    
    item.primaryKey = (NSNumber<SQLD_PRIMARY_KEY,SQLT_INTEGER>*)[self getTimestamp];
    item.singer = metadata.singler;
    item.title = metadata.title;
    item.albumName =  metadata.albumName;
    item.filePath = [NSString stringWithFormat:@"%@/%@",DestDirStr,fileName];
    
    MPSQLExecutor *executor = [[MPSQLExecutor alloc] init];
    [executor creatTableInModel:item];
    BOOL succ = NO;
    NSUInteger count = 0, maxCount = 10;
    do {
        succ = [executor insertItemInModel:item];
        count++;
    } while (!succ && count < maxCount);
    
    if (succ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveAudioFileNotification object:item];
        });
    }
    return succ;
}

+ (NSString*)getFileName:(NSURL*)scrUrl {
    return [NSString randomStringWithLength:randomStrLength];
}

+ (NSNumber*)getTimestamp {
    NSDate *nowDate = [NSDate date];
    NSUInteger timestamp = [nowDate timeIntervalSince1970]*1000;
    timestamp = timestamp * 10 + arc4random() % 10;
    return  [NSNumber numberWithInteger:timestamp];
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
