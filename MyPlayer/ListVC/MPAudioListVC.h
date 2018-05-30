//
//  MPAudioListVC.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSuperController.h"

@interface MPAudioListVC : MPSuperController<UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
