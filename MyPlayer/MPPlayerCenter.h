//
//  MPPlayerCenter.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/6.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerCenterDelegate <NSObject>
- (void)playCenterPlay;

- (void)playCenterPause;

- (void)playCenterStop;

- (void)playCenterNext;

- (void)playCenterPrevious;

- (void)playCenterSeekForwardTime:(NSTimeInterval)time;

- (void)playCenterSeekBackwardTime:(NSTimeInterval)time;
@end

@interface MPPlayerCenter : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) id<PlayerCenterDelegate>currentPlayer;

- (void)play;

- (void)pause;

- (void)stop;

- (void)next;

- (void)previous;

- (void)seekForwardTime:(NSTimeInterval)time;

- (void)seekBackwardTime:(NSTimeInterval)time;

@end
