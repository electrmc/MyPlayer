//
//  MPSQLExecutor.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSQLExecutor.h"
#import "MPSQLCondition.h"
#import "MPSQLUtils.h"
#import <FMDB.h>
#import "MPSQLExecutor+SQLString.h"

static NSString * const DBFile = @"Music.sqlite";
static NSString * const DBDir = @"/Documents/DB";

@implementation MPSQLExecutor

- (BOOL)creatTableInModel:(id)model {
    if (!model) {
        SQLLog(@"SQL %s , Error : Model is nil",__func__);
        return NO;
    }
    NSString *sqlStr = [self createTabelSql:model];
    if (!sqlStr) {
        SQLLog(@"SQL Error : sql is nil");
        return NO;
    }
    return [self executeSql:sqlStr dbPath:self.databasePath];
}

- (BOOL)insertItemInModel:(id)model {
    NSString *sqlStr = [self insertItemsSql:model];
    return [self executeSql:sqlStr dbPath:self.databasePath];
}

- (BOOL)deleteItemsInModel:(id)model Where:(SQLConditionBlock)condition {
    NSString *sqlStr = [self deleteItemsSql:model];
    return [self executeSql:sqlStr dbPath:self.databasePath];
}

- (BOOL)updateItemsInModel:(id)model where:(SQLConditionBlock)condition {
    NSString *conditionStr = nil;
    if (condition) {
        MPSQLCondition *cond = [[MPSQLCondition alloc] init];
        condition(cond);
        conditionStr = [cond condStr];
    }
    
    return NO;
}

- (NSArray*)selectItemsInModel:(id)model where:(SQLConditionBlock)condition {
    NSString *conditionStr = nil;
    if (condition) {
        MPSQLCondition *cond = [[MPSQLCondition alloc] init];
        condition(cond);
        conditionStr = [cond condStr];
    }
    
    return nil;
}

#pragma mark - private
- (BOOL)executeSql:(NSString*)sql dbPath:(NSString*)dbPath{
    if (sql.length < 1 || dbPath.length < 1) {
        return NO;
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath]) {
        FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            BOOL res = [db executeUpdate:sql];
            [db close];
            if (res) {
                SQLLog(@"succ to creating db table");
                return YES;
            } else {
                SQLLog(@"error when creating db table");
            }
        } else {
            SQLLog(@"error when open db");
        }
    }
    return NO;
}

- (NSString*)databasePath {
    NSString *dbDir = [NSHomeDirectory() stringByAppendingPathComponent:DBDir];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL dirExist = [fileManager fileExistsAtPath:dbDir isDirectory:&isDir];
    if (!dirExist || !isDir) {
        BOOL succ = [fileManager createDirectoryAtPath:dbDir
                            withIntermediateDirectories:YES
                                             attributes:nil error:nil];
        if (!succ) {
            return nil;
        }
    }
    
    NSString *dbFile = [dbDir stringByAppendingPathComponent:DBFile];
    BOOL existed = [fileManager fileExistsAtPath:dbFile isDirectory:&isDir];
    if ( !(isDir == NO && existed == YES) ) {
        BOOL res =[fileManager createFileAtPath:dbFile contents:nil attributes:nil];
        if (res) {
            return dbFile;
        } else {
            return nil;
        }
    }
    return dbFile;
}

@end
