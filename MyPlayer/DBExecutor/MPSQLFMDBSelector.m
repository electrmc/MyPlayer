//
//  MPSQLFMDBSelector.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/8.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSQLFMDBSelector.h"
#import "MPSQLUtils.h"
#import <FMDB.h>

static NSString * const IntegerPrefix = @"INTEGER";
static NSString * const TextPrefix = @"TEXT";

@implementation MPSQLFMDBSelector

+ (id)valueFromFMDBResult:(FMResultSet*)rs Type:(NSString*)type columnName:(NSString*)name {

    NSString *selStr = [self fmdbSelectorResponseToType:type];
    if (!selStr) {
        return nil;
    }
    
    SEL selector = NSSelectorFromString(selStr);
    if ([rs respondsToSelector:selector]) {
        NSMethodSignature *signature =  [[rs class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        [invocation setTarget:rs];
        [invocation invoke];
        
        const char *returnType = signature.methodReturnType;
        id objc = nil;
        if (strcmp(returnType, @encode(int))) {
            int returnValue = INT_MAX;
            [invocation getReturnValue:&returnValue];
            objc = SQLBoxValue(returnValue);
        } else if(strcmp(returnType, @encode(NSString))) {
            NSString *returnValue = nil;
            [invocation getReturnValue:&returnValue];
            objc = returnValue;
        } else {
            // ...
        }
        
        return objc;
    }
    
    return nil;
}

+ (NSString*)fmdbSelectorResponseToType:(NSString*)type {
    SQLColumnType columnType = [self columnType:type];
    NSString *selectorName = nil;
    switch (columnType) {
        case SQLColumn_Integer:
            selectorName = @"intForColumn:";
            break;
        case SQLColumn_String:
            selectorName = @"stringForColumn:";
        default:
            break;
    }
    return selectorName;
}

+ (SQLColumnType)columnType:(NSString*)type {
    SQLColumnType columnType = SQLColumn_None;
    if ([type hasPrefix:IntegerPrefix]) {
        columnType = SQLColumn_Integer;
    } else if ([type hasPrefix:TextPrefix]) {
        columnType = SQLColumn_String;
    } else  {
        // do nothing
    }
    return columnType;
}

+ (NSObject*)boxBaseValue:(id)value {
    const char *type = @encode(__typeof__(value));
    
    if (strcmp(type,@encode(__typeof__([NSString class]))) ||
        strcmp(type,@encode(__typeof__([NSString new])))) {
        return value;
    } else {
        return SQLBoxValue(value);
    }
}

@end
