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
    
    id returnObjc = nil;
    
    SEL selector = NSSelectorFromString(selStr);
    if ([rs respondsToSelector:selector]) {
        NSMethodSignature *signature =  [[rs class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        [invocation setArgument:&name atIndex:2];
        [invocation setTarget:rs];
        [invocation invoke];
        returnObjc = [self getReturnFromInvocation:invocation];
    }
    
    return returnObjc;
}

+ (id)getReturnFromInvocation:(NSInvocation*)invocation {
    if (!invocation) {
        return nil;
    }
    
    id returnObjc = nil;
    const char *returnType = invocation.methodSignature.methodReturnType;
    
    if (strcmp(returnType, @encode(int)) == 0) {
        int returnValue = INT_MAX;
        [invocation getReturnValue:&returnValue];
        if (returnValue != INT_MAX) {
            returnObjc = SQLBoxValue(returnValue);
        }
        
    } else if(strcmp(returnType, @encode(float)) == 0) {
        float returnValue = FLT_MAX;
        [invocation getReturnValue:&returnValue];
        if (fabs(returnValue - FLT_MAX) > FLT_EPSILON) {
            returnObjc = SQLBoxValue(returnValue);
        }
        
    } else if(strcmp(returnType, @encode(id)) == 0) {
        NSString * __unsafe_unretained returnValue = nil;
        [invocation getReturnValue:&returnValue];
        returnObjc = returnValue;
        
    } else {
        // ...
    }
    return returnObjc;
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

@end
