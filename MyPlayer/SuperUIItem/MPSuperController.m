//
//  MPSuperController.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSuperController.h"
#import "DebugTools.h"

@interface MPSuperController ()

@end

@implementation MPSuperController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        DebugTools *tools = [DebugTools shareInstance];
        if (!tools.superview) {
            [[UIApplication sharedApplication].keyWindow addSubview:tools];
        }
    }
}

@end
