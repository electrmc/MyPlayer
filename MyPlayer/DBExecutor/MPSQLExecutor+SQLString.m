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

// @"CREATE TABLE  IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL",basicDBName];
- (NSString*)createTabelSql:(id)model {
    if (!model) {
        return nil;
    }
    NSString *tableName = self.tableName ? self.tableName : NSStringFromClass([model class]);
    NSMutableString *creatStr = [NSMutableString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS '%@'",tableName];
    
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
        
        if (itemStr.length > 0) {
            [itemTotalStr appendString:itemStr];
            [itemTotalStr appendString:@","];
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

- (NSString*)insertItemsSql:(id)model {
    return nil;
}

- (NSString*)selectItemsSql:(id)model {
    return nil;
}

- (NSString*)deleteItemsSql:(id)model {
    return nil;
}
@end
