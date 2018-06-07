//
//  DebugTools.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/5.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "DebugTools.h"
#import <FLEX.h>
#import "MPSimulatorAirdrop.h"
#import "MPDefineUtils.h"

@interface DebugTools()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableRowsName;
@property (nonatomic, strong) NSDictionary *toolsMenu;
@end

@implementation DebugTools

+ (instancetype)shareInstance {
    static DebugTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[DebugTools alloc] init];
    });
    return tools;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 90, [MPDefineUtils screenWidth], 200);
        self.backgroundColor = [UIColor lightGrayColor];
        self.tableRowsName = self.toolsMenu.allKeys;
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSDictionary*)toolsMenu {
    return @{@"dismiss":@"dismiss",
             @"FLEX":@"showFLEX",
             @"SimulateAirDrop":@"simulateAirDrop"
             };
}

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableRowsName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"toolsIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.tableRowsName[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selStr = [self.toolsMenu objectForKey:self.tableRowsName[indexPath.row]];
    SEL selector = NSSelectorFromString(selStr);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
    [self removeFromSuperview];
}

#pragma mark - Selector

- (void)simulateAirDrop {
    MPSimulatorAirdrop *simulator = [[MPSimulatorAirdrop alloc]init];
    [simulator simulateAirdrop];
    [self removeFromSuperview];
}

- (void)showFLEX {
    [[FLEXManager sharedManager] showExplorer];
}

@end
