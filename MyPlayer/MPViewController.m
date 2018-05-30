//
//  MPViewController.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/28.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPViewController.h"
#import <FLEX.h>
#import "MPOriginPlayer.h"
#import "MPSQLExecutor+SQLString.h"
#import <YYModel.h>
#import "MPSQLUtils.h"
#import "MPSQLCondition.h"
#import "MPAudioMetadata.h"
#import <AVFoundation/AVFoundation.h>

extern NSString * const DidReceiveAudioFileNotification;

@interface MPViewController ()

@end

@implementation MPViewController
- (IBAction)other:(id)sender {
    
}

- (IBAction)Play:(id)sender {
    NSString *mp3File = [[NSBundle mainBundle] pathForResource:@"111" ofType:@"mp3"];
    MPAudioMetadata *metadata = [[MPAudioMetadata alloc] initWithFile:mp3File];
    NSLog(@"%@",metadata);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAudio:) name:DidReceiveAudioFileNotification object:nil];
}

- (void)didReceiveAudio:(NSNotification*)notification {
    NSLog(@"%@",notification.userInfo);
}

- (IBAction)button:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}

- (IBAction)createTable:(id)sender {
    
}

@end
