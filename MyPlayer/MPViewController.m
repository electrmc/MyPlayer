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

@interface MPViewController ()

@end

@implementation MPViewController

- (IBAction)Play:(id)sender {
    MPSQLExecutor *execute = [[MPSQLExecutor alloc] init];
    BasicInfoItem *item1 =  [BasicInfoItem new];
    item1.primaryKey = @1;
    item1.fileName = @"12";
    NSArray *array = [execute selectItemsInModel:item1 filter:Filt_Valuable where:nil];
    NSLog(@"%@",array);
    return;
    
    [execute creatTableInModel:[BasicInfoItem new]];
    
    for (int i=0; i<10; i++) {
        BasicInfoItem *item = [[BasicInfoItem alloc] init];
        item.primaryKey = [NSNumber numberWithInteger:i+100];
        item.fileName = [NSString stringWithFormat:@"fileName_%d",i+100];
        item.audioName = [NSString stringWithFormat:@"auidoname_%d",i+100];
        item.author = [NSString stringWithFormat:@"周杰伦_%d",i+100];
        [execute insertItemInModel:item];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)button:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}
- (IBAction)createTable:(id)sender {

}

@end
