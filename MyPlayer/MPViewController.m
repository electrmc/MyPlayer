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
    if ([BasicInfoDB creatBasicInfoDB]) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
}

@end
