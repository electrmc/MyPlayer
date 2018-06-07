//
//  MPPlayerCenter.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/6.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPPlayerCenter.h"

static MPPlayerCenter *playCenter = nil;

@implementation MPPlayerCenter

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playCenter = [[MPPlayerCenter alloc] init];
    });
    return playCenter;
}

- (UIView*)playCenterView {
    return nil;
}

- (void)play {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterPlay)]) {
        [self.currentPlayer playCenterPlay];
    }
}

- (void)pause {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterPause)]) {
        [self.currentPlayer playCenterPause];
    }
}

- (void)stop {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterStop)]) {
        [self.currentPlayer playCenterStop];
    }
}

- (void)next {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterNext)]) {
        [self.currentPlayer playCenterNext];
    }
}

- (void)previous {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterPrevious)]) {
        [self.currentPlayer playCenterPrevious];
    }
}

- (void)seekForwardTime:(NSTimeInterval)time {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterSeekForwardTime:)]) {
        [self.currentPlayer playCenterSeekForwardTime:time];
    }
}

- (void)seekBackwardTime:(NSTimeInterval)time {
    if ([self.currentPlayer respondsToSelector:@selector(playCenterSeekBackwardTime:)]) {
        [self.currentPlayer playCenterSeekBackwardTime:time];
    }
}
@end
