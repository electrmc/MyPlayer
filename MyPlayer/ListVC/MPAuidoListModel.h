//
//  MPAuidoListModel.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPAudioBasicInfo;

@interface MPAuidoListModel : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *audioList;

- (void)loadAudioListData;

- (void)addItem:(MPAudioBasicInfo*)item;

- (MPAudioBasicInfo*)infoForIndex:(NSUInteger)index;

@end
