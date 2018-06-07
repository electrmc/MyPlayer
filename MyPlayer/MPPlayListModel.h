//
//  MPPlayListModel.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/5.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MPAudioBasicInfo;

@interface MPPlayListModel : NSObject

@property (nonatomic, strong, readonly) NSArray *list;

- (void)setPlayList:(NSArray*)items;

- (void)addItem:(MPAudioBasicInfo*)item;

- (void)insertItem:(MPAudioBasicInfo*)item index:(NSUInteger)index;

- (void)deleteItem:(MPAudioBasicInfo*)item;

- (void)deleteItemAtIndex:(NSUInteger)index;

- (NSUInteger)count;

@end
