//
//  MPAudioMetadata.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/12.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPAudioMetadata : NSObject

@property (nonatomic, copy, readonly) NSString *filePath;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *artist;

- (instancetype)initWithFile:(NSString*)filePath;

@end
