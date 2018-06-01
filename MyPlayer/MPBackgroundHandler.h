//
//  MPBackgroundHandler.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/6/1.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPBackgroundHandler : NSObject

- (UIBackgroundTaskIdentifier)setBackgroundPlay:(UIBackgroundTaskIdentifier)backTaskId;

- (void)handleRemoteEvent:(UIEvent *)event;

@end
