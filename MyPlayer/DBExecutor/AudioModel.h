//
//  AudioModel.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootInfo: NSObject
@property (nonatomic, assign) NSInteger primaryKey;
@end

@interface BasicInfoItem : RootInfo
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@end

