//
//  FMDBExecutor.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "FMDBExecutor.h"
#import <FMDB.h>
#import "LogMacroUtils.h"

NSString * const TableNameKey = @"tableNamekey";
NSString * const TableColumeKey = @"TableColumeKey";

static NSString * const DBDir = @"/Documents/DB/Music.sqlite";

@implementation FMDBExecutor

+ (BOOL)createTable:(NSString*)sql {
    return [self executeSql:sql];
}

+ (BOOL)insertItem:(NSString*)sql {
    return [self executeSql:sql];
}

+ (BOOL)executeSql:(NSString*)sql {
    if (sql.length < 1) {
        return NO;
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath]) {
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            BOOL res = [db executeUpdate:sql];
            [db close];
            if (res) {
                MPLog(@"succ to creating db table");
                return YES;
            } else {
                MPLog(@"error when creating db table");
            }
        } else {
            MPLog(@"error when open db");
        }
    }
    return NO;
}

+ (NSString*)dbPath {
    NSString *dbFile = [NSHomeDirectory() stringByAppendingPathComponent:DBDir];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dbFile isDirectory:&isDir];
    if ( !(isDir == NO && existed == YES) )
    {
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
