//
//  MPAudioBasicInfo.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSQLDataType.h"

@interface MPAudioBasicInfo : NSObject
@property (nonatomic, strong) NSNumber <SQLD_PRIMARY_KEY,SQLT_INTEGER> *primaryKey;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *albumName;

@property (nonatomic, copy) NSString *filePath;

@end
