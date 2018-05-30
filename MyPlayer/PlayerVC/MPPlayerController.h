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

@interface MPPlayerController : MPSuperController

@property (nonatomic, strong) MPOriginPlayer *player;
@end
