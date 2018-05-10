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
#import <YYModel.h>
#import "MPSQLExecutor+SQLString.h"
#import "MPSQLFMDBSelector.h"

static NSString * const DBFile = @"Music.sqlite";
static NSString * const DBDir = @"/Documents/DB";

extern NSString * const SQLItemTypeKey;

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
    NSString *sqlStr = [self insertItemSql:model];
    return [self executeSql:sqlStr dbPath:self.databasePath];
}

- (BOOL)deleteItemsInModel:(id)model Where:(SQLConditionBlock)condition {
    NSString *sqlStr = [self deleteItemSql:model];
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

- (NSArray*)selectItemsInModel:(id)model filter:(FiltType)filter where:(SQLConditionBlock)condition {
    NSString *conditionStr = nil;
    if (condition) {
        MPSQLCondition *cond = [[MPSQLCondition alloc] init];
        condition(cond);
        conditionStr = [cond condStr];
    }
    
    NSArray *result = [self selectItemSql:model filt:filter];
    NSString *sql = result.firstObject;
    if (!sql) {
        return nil;
    }
    if (conditionStr) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,conditionStr];
    }
    
    NSMutableArray *items = [NSMutableArray array];
    NSDictionary *propertyDic = result.lastObject;
    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [propertyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *type = [obj objectForKey:SQLItemTypeKey];
                id result = [MPSQLFMDBSelector valueFromFMDBResult:rs Type:type columnName:key];
                if (result) {
                    [dic setObject:result forKey:key];
                }
            }];
            
            id result = [[model class] yy_modelWithDictionary:dic];
            if (result) {
                [items addObject:result];
            }
        }
        [db close];
    } else {
        SQLLog(@"SQL ERROR when open db");
    }
    
    return items;
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
                SQLLog(@"SQL SUCCES : \"%@\"",sql);
                return YES;
            } else {
                SQLLog(@"SQL ERROR : \"%@\"",sql);
            }
        } else {
            SQLLog(@"SQL ERROR when open db");
        }
    }
    return NO;
}

- (NSString*)databasePath {
    if(!_databasePath) {
        NSString *dbDir = [NSHomeDirectory() stringByAppendingPathComponent:DBDir];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL dirExist = [fileManager fileExistsAtPath:dbDir isDirectory:&isDir];
        if (!dirExist || !isDir) {
            BOOL succ = [fileManager createDirectoryAtPath:dbDir
                               withIntermediateDirectories:YES
                                                attributes:nil error:nil];
            if (!succ) { // 创建文件夹失败
                return _databasePath;
            }
        }
        
        NSString *dbFile = [dbDir stringByAppendingPathComponent:DBFile];
        BOOL existed = [fileManager fileExistsAtPath:dbFile isDirectory:&isDir];
        if (existed == YES && isDir == NO) {
            _databasePath = dbFile;
        } else {
            BOOL res =[fileManager createFileAtPath:dbFile contents:nil attributes:nil];
            if (res) { // 创建文件成功
                _databasePath = dbFile;
            } else { // 创建文件失败
                return _databasePath;
            }
        }
    }
    
    return _databasePath;
}

@end
