//
//  MPSQLDescription.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/4.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 primaryKey = {
    "sql_item_description" = (
                                PRIMARY,
                                KEY
                             );
    "sql_item_type" = INTEGER;
 };
 abc = {
    "sql_item_type" = TEXT;
 };
 def = {
    "sql_item_type" = TEXT;
 };
*/

extern NSString * const SQLItemTypeKey;
extern NSString * const SQLItemDescKey;

@interface MPSQLDescription : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary<NSString*,NSDictionary*>*)sqlDescriptionWithModel:(id)model;

@end
