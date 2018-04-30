//
//  FMDBExecutor.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/29.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBGlobal.h"

@interface FMDBExecutor : NSObject
/**
 创建表
 CREATE TABLE tableName(
 ID INT PRIMARY KEY     NOT NULL,
 NAME           TEXT    NOT NULL,
 AGE            INT     NOT NULL,
 ADDRESS        CHAR(50),
 SALARY         REAL
 );
 */
+  (BOOL)createTable:(NSString*)sql;

/**
 插入数据
 
 INSERT INTO TABLE_NAME [(column1, column2, column3,...columnN)]
 VALUES (value1, value2, value3,...valueN);
 通常column1是主key，其他的是各列的名字
 */
+ (BOOL)insertItem:(NSString*)sql;
@end
