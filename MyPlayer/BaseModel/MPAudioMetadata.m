//
//  MPAudioMetadata.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/12.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPAudioMetadata.h"
#import <AVFoundation/AVFoundation.h>

@implementation MPAudioMetadata

- (instancetype)initWithFile:(NSString*)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
        [self loadAudioMetadata];
    }
    return self;
}

- (void)loadAudioMetadata {
    if (!_filePath) {
        return;
    }
    NSURL *fileURL = [NSURL fileURLWithPath:_filePath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    [self getMetadata:asset];
}

- (void)getMetadata:(AVAsset*)mp3Asset {
    //根据歌曲计算
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            if([metadataItem.commonKey isEqualToString:@"title"]){
                self.title = (NSString *)metadataItem.value;//歌曲名
            } else if ([metadataItem.commonKey isEqualToString:@"artist"]){
                self.singler = (NSString *)metadataItem.value;//歌手
            } else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
                self.albumName = (NSString *)metadataItem.value;
            } else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {//图片生成
                NSDictionary *dict=(NSDictionary *)metadataItem.value;
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    NSData *data=[dict objectForKey:@"data"];
                    self.icon = [UIImage imageWithData:data];//图片
                } else {
                    self.icon = [UIImage imageWithData:[metadataItem.value copyWithZone:nil]] ;
                }
            }
        }
    }
}

- (void)getMetadata1:(AVAsset*)asset {
    [self printMetadata:asset];
    
    [asset loadValuesAsynchronouslyForKeys:@[@"commonMetadata",@"availableMetadataFormats"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"commonMetadata" error:&error];
        switch (status) {
            case AVKeyValueStatusLoaded:
                [self printMetadata:asset];
                break;
            case AVKeyValueStatusFailed:
                NSLog(@"failed");
                break;
            case AVKeyValueStatusCancelled:
                NSLog(@"canceled");
                break;
            default:
                
                break;
        }
    }];
    
    for (NSString *format in [asset availableMetadataFormats]) {
        NSLog(@"format : %@",format);
    }
}

- (void)printMetadata:(AVAsset*) asset{
    
    NSError *error = nil;
    AVKeyValueStatus status = [asset statusOfValueForKey:@"commonMetadata" error:&error];
    NSLog(@"%d",status);
    
    for (AVMetadataItem *item in asset.metadata)
    {
        NSLog(@"1 item.keySpace : %@",item.keySpace);
        NSLog(@"1 item.commonKey : %@",item.commonKey);
        NSLog(@"1 item.identifier : %@",item.identifier);
    }
    
    NSLog(@"\n\n\n======commonMetadata");
    
    for (AVMetadataItem *item in asset.commonMetadata)
    {
        NSLog(@"2 item.keySpace : %@",item.keySpace);
        NSLog(@"2 item.commonKey : %@",item.commonKey);
        NSLog(@"2 item.identifier : %@",item.identifier);
    }
}

- (void)test {
    NSLog(@"AVMetadataKey %@",AVMetadataCommonKeyTitle);
    NSLog(@"AVMetadataKey %@",AVMetadataCommonKeyCreator);
    NSLog(@"AVMetadataKey %@",AVMetadataCommonKeySubject);
    NSLog(@"AVMetadataKey %@",AVMetadataCommonKeyDescription);
    
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceCommon);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceQuickTimeUserData);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceISOUserData);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceQuickTimeMetadata);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceiTunes);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceIcy);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceID3);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceAudioFile);
    NSLog(@"AVMetadataKeySpace %@",AVMetadataKeySpaceHLSDateRange);
    
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatQuickTimeUserData);
    NSLog(@"AVMetadataFormat %@",AVMetadataCommonKeyTitle);
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatID3Metadata);
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatUnknown);
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatHLSMetadata);
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatiTunesMetadata);
    NSLog(@"AVMetadataFormat %@",AVMetadataFormatQuickTimeMetadata);
}

@end
