//
//  BasicInfoDB.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "BasicInfoDB.h"
#import "FMDBExecutor.h"

@implementation BasicInfoDB

+ (BOOL)creatBasicInfoDB {
    NSString *basicDBName = @"BasicDBInfo";
    NSArray *basicDBColume = @[@"name",@"author",@"date"];
    return [FMDBExecutor createTable:@{TableNameKey:basicDBName,TableColumeKey:basicDBColume}];
}

@end

