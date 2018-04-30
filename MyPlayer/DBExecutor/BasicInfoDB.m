//
//  BasicInfoDB.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "BasicInfoDB.h"
#import "FMDBExecutor.h"
#import "AudioModel.h"

static NSString *basicDBName = @"BasicInfoTable";
@implementation BasicInfoDB

+ (BOOL)creatBasicInfoTable {
    
    NSArray *basicDBColume = @[@"name",@"author"];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL",basicDBName];

    [basicDBColume enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            *stop = YES;
            return;
        }
        [sql appendString:@","];
        NSString *colume = [NSString stringWithFormat:@"'%@' text",obj];
        [sql appendString:colume];
    }];
    [sql appendString:@")"];
    
    return [FMDBExecutor createTable:sql];
}

+ (BOOL)insertItem:(BasicInfoItem*)item {
    if (item.name.length < 1 || item.primaryKey == 0) {
        return NO;
    }
    NSString *author = item.author ? item.author : @"";
    NSString *insertSql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (id, name, author) VALUES ('%ld', '%@', '%@')",basicDBName,(long)item.primaryKey, item.name,author];
    return [FMDBExecutor insertItem:insertSql];
}

@end

