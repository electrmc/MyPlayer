//
//  AudioModel.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSQLDataType.h"

@interface BasicInfoItem : NSObject
@property (nonatomic, strong) NSNumber <SQLD_PRIMARY_KEY,SQLT_INTEGER> *primaryKey;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *audioName;
@property (nonatomic, copy) NSString *author;
@end
