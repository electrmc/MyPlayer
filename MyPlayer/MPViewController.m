//
//  MPViewController.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/28.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPViewController.h"
#import <FLEX.h>
#import "AudioModel.h"
#import "MPOriginPlayer.h"
#import "MPSQLExecutor+SQLString.h"
#import <YYModel.h>
#import "MPSQLUtils.h"
#import "MPSQLCondition.h"
#import "MPAudioMetadata.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (IBAction)Play:(id)sender {
    NSString *mp3File = [[NSBundle mainBundle] pathForResource:@"111" ofType:@"mp3"];
    MPAudioMetadata *metadata = [[MPAudioMetadata alloc] initWithFile:mp3File];
    NSLog(@"%@",metadata);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)button:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}

- (IBAction)createTable:(id)sender {
    
    
    
    MPSQLExecutor *execute = [[MPSQLExecutor alloc] init];
    
    BasicInfoItem *item2 = [[BasicInfoItem alloc] init];
    item2.primaryKey = SQLEW(@123456);
    item2.fileName = @"this is update file";
    [execute updateItemsInModel:item2 where:^(MPSQLCondition *condition) {
        
        condition.condStr = @"primaryKey == 100";
    }];
    return;
    
    
    [execute creatTableInModel:[BasicInfoItem new]];
    
    for (int i=0; i<10; i++) {
        BasicInfoItem *item = [[BasicInfoItem alloc] init];
        item.primaryKey = SQLEW([NSNumber numberWithInteger:i+100]);
        item.fileName = [NSString stringWithFormat:@"fileName_%d",i+100];
        item.audioName = [NSString stringWithFormat:@"auidoname_%d",i+100];
        item.author = [NSString stringWithFormat:@"周杰伦_%d",i+100];
        item.num1 = SQLEW(@(1.234+i));
        [execute insertItemInModel:item];
    }
    
    return;
    BasicInfoItem *item1 = [BasicInfoItem new];
    item2.primaryKey = SQLEW(@1);
    item2.fileName = @"12";
    NSArray *array = [execute selectItemsInModel:item2 filter:Filt_Valuable where:nil];
    NSLog(@"%@",array);
    return;
    
}

@end
