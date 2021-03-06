//
//  MPAudioListVC.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPAudioListVC.h"
#import "UIView+Size.h"
#import "MPAuidoListModel.h"
#import "MPAudioBasicInfo.h"
#import "MPPlayerController.h"
#import "MPPlayerCenter.h"

extern NSString * const DidReceiveAudioFileNotification;

@interface MPAudioListVC ()
@property (nonatomic, strong) MPAuidoListModel *listVCModel;
@end

@implementation MPAudioListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=  [UIColor lightGrayColor];
    self.listVCModel = [[MPAuidoListModel alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.view.height - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.listVCModel;
    [self.view addSubview:self.tableView];
    [self.listVCModel loadAudioListData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudio:) name:DidReceiveAudioFileNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didReceiveAudio:(NSNotification*)notification {
    if (![notification.object isKindOfClass:[MPAudioBasicInfo class]]) {
        return;
    }
    [self.listVCModel addItem:notification.object];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPAudioBasicInfo *info = [self.listVCModel infoForIndex:indexPath.row];
    if (!info) {
        return;
    }
    
    MPPlayerController *playerVC = [[MPPlayerController alloc] init];
    [playerVC setAudioModelList:self.listVCModel.audioList];
    [playerVC setPlayIndex:indexPath.row];
    [MPPlayerCenter shareInstance].currentPlayer = playerVC;
    [self.navigationController pushViewController:playerVC animated:YES];
}

@end
