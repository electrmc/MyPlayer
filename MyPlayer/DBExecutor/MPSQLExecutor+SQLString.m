//
//  MPSQLExecutor+SQLString.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/4.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSQLExecutor+SQLString.h"
#import "MPSQLDescription.h"

@implementation MPSQLExecutor (SQLString)

/**
 @"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL",basicDBName];
 */
- (NSString*)createTabelSql:(id)model {
    if (!model) {
        return nil;
    }
    NSString *tableName = self.tableName ? self.tableName : NSStringFromClass([model class]);
    NSMutableString *creatStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'",tableName];
    
    NSDictionary *descriptionDic = [[MPSQLDescription sharedInstance] sqlDescriptionWithModel:model];
    
    NSMutableString *itemTotalStr = [NSMutableString stringWithString:@""];
    
    [descriptionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSMutableString *itemStr = [NSMutableString stringWithString:@""];
        
        NSString *itemName = (NSString*)key;
        if (itemName.length < 1) {
            NSAssert(0, @"SQL ERROR : Create Table Item name is nil");
            *stop = YES;
        }
        
        [itemStr appendString:[NSString stringWithFormat:@"'%@' ",itemName]];
        
        NSDictionary *itemDesDic = (NSDictionary*)obj;
        NSString *itemType = [[itemDesDic objectForKey:SQLItemTypeKey] firstObject];
        if (itemType.length > 0) {
            [itemStr appendString:itemType];
            [itemStr appendString:@" "];
        }

        NSArray *itemDes = [itemDesDic objectForKey:SQLItemDescKey];
        [itemDes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *des = (NSString*)obj;
            if ([des isKindOfClass:[NSString class]] && des.length > 0) {
                [itemStr appendString:des];
                [itemStr appendString:@" "];
            }
        }];
        itemStr = [NSMutableString stringWithFormat:@"%@,",itemStr];
        if ([itemStr containsString:@"PRIMARY"]) {
            [itemTotalStr insertString:itemStr atIndex:0];
        } else {
            [itemTotalStr appendString:itemStr];
        }
    }];
    
    if (itemTotalStr.length > 1) {
        NSString *tempStr = [itemTotalStr substringToIndex:itemTotalStr.length - 1];
        [creatStr appendString:@"("];
        [creatStr appendString:tempStr];
        [creatStr appendString:@")"];
    }
    return creatStr;
}


/**
 INSERT INTO tableName (name, password) values(?, ?)
 */
- (NSString*)insertItemsSql:(id)model {
    if(!model) {
        return nil;
    }
    
    NSDictionary *descriptionDic = [[MPSQLDescription sharedInstance] sqlDescriptionWithModel:model];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:descriptionDic.count];
    NSArray *propertys = descriptionDic.allKeys;
    for (int i=0; i<propertys.count; i++) {
        NSString *property = propertys[i];
        if (![property isKindOfClass:[NSString class]]) {
            return nil;
        }
        SEL selector = NSSelectorFromString(property);
        if ([model respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id value = [model performSelector:selector withObject:nil];
#pragma clang diagnostic pop
            if (value) {
                [tempDic setObject:[NSString stringWithFormat:@"%@",value] forKey:property];
            }
        }
    }
    
    
    // joint INSERT SQL string
    NSMutableString *names = [NSMutableString stringWithString:@""];
    NSMutableString *values = [NSMutableString stringWithString:@""];

    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [names appendString:[NSString stringWithFormat:@"%@, ",key]];
        [values appendString:[NSString stringWithFormat:@"'%@', ",obj]];
    }];
    NSString *resNames = nil;
    if (names.length > 2) {
        resNames = [names substringToIndex:names.length - 2];
    }
    NSString *resValues = nil;
    if (values.length > 2) {
        resValues = [values substringToIndex:values.length - 2];
    }
    
    if (resNames && resValues) {
        NSString *tableName = self.tableName ? self.tableName : NSStringFromClass([model class]);
        NSMutableString *insertStr = [NSMutableString stringWithFormat:@"INSERT INTO '%@'",tableName];
        [insertStr appendString:[NSString stringWithFormat:@"(%@) ",resNames]];
        [insertStr appendString:[NSString stringWithFormat:@"values(%@)",resValues]];
        return insertStr;
    } else {
        return nil;
    }
}

- (NSString*)selectItemsSql:(id)model {
    return nil;
}

- (NSString*)deleteItemsSql:(id)model {
    return nil;
}
@end
