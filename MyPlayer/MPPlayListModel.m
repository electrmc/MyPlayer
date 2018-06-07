//
//  MPPlayListModel.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/5.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPPlayListModel.h"

@interface MPPlayListModel()

@property (nonatomic, strong) NSMutableArray *modelList;

@end

@implementation MPPlayListModel

- (void)setPlayList {
    
}

- (void)setPlayList:(NSArray*)items {
    
}

- (void)addItem:(MPAudioBasicInfo*)item {
    
}

- (void)insertItem:(MPAudioBasicInfo*)item index:(NSUInteger)index {
    
}

- (void)deleteItem:(MPAudioBasicInfo*)item {
    
}

- (void)deleteItemAtIndex:(NSUInteger)index {
    
}

- (NSUInteger)count {
    return self.modelList.count;
}

@end
