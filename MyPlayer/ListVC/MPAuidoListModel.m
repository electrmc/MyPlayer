//
//  MPAuidoListModel.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPAuidoListModel.h"
#import "MPAudioListCell.h"
#import "MPSQLExecutor.h"
#import "MPAudioBasicInfo.h"

@interface MPAuidoListModel()

@property (nonatomic, strong) NSMutableArray *audioList;

@end

@implementation MPAuidoListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadAudioListData {
    MPSQLExecutor *executor = [[MPSQLExecutor alloc] init];
    NSArray *temp = [executor selectItemsInModel:[MPAudioBasicInfo new] filter:Filt_All where:nil];
    self.audioList = [NSMutableArray arrayWithArray:temp];
}

- (void)addItem:(MPAudioBasicInfo*)item {
    if (!item) {
        return;
    }
    [self.audioList addObject:item];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MPAudioListCellIdentifier";
    MPAudioListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPAudioListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPAudioBasicInfo *audioBasicInfo = self.audioList[indexPath.row];
    cell.textLabel.text = audioBasicInfo.filePath;
    return cell;
}

@end
