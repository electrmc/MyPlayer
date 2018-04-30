//
//  MPViewController.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/28.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPViewController.h"
#import <FLEX.h>
#import "BasicInfoDB.h"
#import "AudioModel.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)button:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}
- (IBAction)createTable:(id)sender {
    [BasicInfoDB creatBasicInfoTable];
    BasicInfoItem *item = [[BasicInfoItem alloc] init];
    item.primaryKey = 123456;
    item.name = @"七里香";
    item.author = @"周杰伦";
    if ([BasicInfoDB insertItem:item]) {
        NSLog(@"success");
    } else {
        NSLog(@"error");
    }
}

@end
