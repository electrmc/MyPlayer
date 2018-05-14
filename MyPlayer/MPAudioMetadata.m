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
    NSURL *fileURL = [NSURL URLWithString:_filePath];
    [self dataInfoFromFileURL:fileURL];
}

- (void)dataInfoFromFileURL:(NSURL *)fileURL
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSArray *ary = @[@"commonMetadata"];
    [asset loadValuesAsynchronouslyForKeys:ary
                         completionHandler:^{
                             NSLog(@"get metadata");
                             [self abc:asset identifier:ary];
                             dispatch_semaphore_signal(semaphore);
                         }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"continue");
}

- (void)abc:(AVAsset*)asset identifier:(NSArray<NSString*>*)identifiers {
    NSError *error = nil;
    for (NSString *identifier in identifiers) {
        AVKeyValueStatus status = [asset statusOfValueForKey:identifier error:&error];
        switch (status) {
            case AVKeyValueStatusLoaded: {
                [self getMetadata:asset];
                break;
            case AVKeyValueStatusFailed:
                break;
            case AVKeyValueStatusCancelled:
                break;
            default:
                break;
            }
        }
    }
}

- (void)getMetadata:(AVAsset*)asset {
    // 获取数据
    NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                       withKey:AVMetadataCommonKeyArtwork
                                                      keySpace:AVMetadataKeySpaceCommon];
    for (AVMetadataItem *item in artworks)
    {
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3])
        {
            NSDictionary *dict = [item.value copyWithZone:nil];
            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            // 获取图片
            UIImage  *image = [UIImage imageWithData:[dict objectForKey:@"data"]];
            
        }
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes])
        {
            // 获取图片
            UIImage *image = [UIImage imageWithData:[item.value copyWithZone:nil]];
        }
    }
}

@end
