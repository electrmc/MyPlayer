//
//  BasicInfoDB.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BasicInfoItem;
@interface BasicInfoDB : NSObject

+ (BOOL)creatBasicInfoTable;
+ (BOOL)insertItem:(BasicInfoItem*)item;
@end
