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
#import "LogMacroUtils.h"

@interface MPAuidoListModel()
@property (nonatomic, strong) MPSQLExecutor *executor;
@end

@implementation MPAuidoListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadAudioListData {
    NSArray *temp = [self.executor selectItemsInModel:[MPAudioBasicInfo new] filter:Filt_All where:nil];
    self.audioList = [NSMutableArray arrayWithArray:temp];
}

- (void)addItem:(MPAudioBasicInfo*)item {
    if (!item) {
        return;
    }
    [self.audioList addObject:item];
}

- (MPAudioBasicInfo*)infoForIndex:(NSUInteger)index {
    if (index > self.audioList.count - 1) {
        return nil;
    }
    return [self.audioList objectAtIndex:index];
}

- (BOOL)deleteItemForIndex:(NSUInteger)index {
    if (self.audioList.count - 1 < index) {
        return NO;
    }
    [self deleteFile:self.audioList[index]];
    [self.audioList removeObjectAtIndex:index];
    return YES;
}

- (BOOL)deleteFile:(MPAudioBasicInfo*)info {
    if (!info) {
        return NO;
    }
    BOOL sqlRes = [self.executor deleteItemsInModel:[MPAudioBasicInfo new] Where:^(MPSQLCondition *condition) {
        condition.condStr = [NSString stringWithFormat:@"primaryKey = %@", info.primaryKey];
    }];
    
    if (!info.filePath) {
        return NO;
    }
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:info.filePath];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    BOOL fileRes = [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:&error];
    if (error) {
        MPLog(@"Delete Item Error : %@",error);
        return NO;
    }
    return sqlRes && fileRes;
}

#pragma mark - tableview delegate
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
    cell.textLabel.text = audioBasicInfo.title ? audioBasicInfo.title : audioBasicInfo.filePath;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteItemForIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Get Method
- (MPSQLExecutor*)executor {
    if (!_executor) {
        _executor = [[MPSQLExecutor alloc] init];
    }
    return _executor;
}

@end
