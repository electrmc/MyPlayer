//
//  MPPlayerController.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSuperController.h"

@class MPAudioBasicInfo;
@class MPOriginPlayer;
@protocol PlayerCenterDelegate;

@interface MPPlayerController : MPSuperController <PlayerCenterDelegate>

@property (nonatomic, strong) MPOriginPlayer *player;

- (void)setAudioModelList:(NSArray*)audioList;

- (void)setPlayIndex:(NSUInteger)index;

@end
