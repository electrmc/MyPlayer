//
//  FMDBExecutor.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "FMDBExecutor.h"
#import <FMDB.h>
#import "MacroUtils.h"

NSString * const TableNameKey = @"tableNamekey";
NSString * const TableColumeKey = @"TableColumeKey";

static NSString * const DBDir = @"/Documents/DB/Music.sqlite";

@implementation FMDBExecutor

+ (BOOL)createTable:(NSDictionary*)table {
    NSString *tableName = table[TableNameKey];
    if (!tableName) {
        return NO;
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath]) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL",tableName];
            NSArray *ary = table[TableColumeKey];
            [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isKindOfClass:[NSString class]]) {
                    *stop = YES;
                    return;
                }
                [sql appendString:@","];
                NSString *colume = [NSString stringWithFormat:@"'%@' text",obj];
                [sql appendString:colume];
            }];
            [sql appendString:@")"];
            
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
