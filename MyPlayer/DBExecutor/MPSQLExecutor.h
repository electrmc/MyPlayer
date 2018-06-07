//
//  MPSQLExecutor.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSQLCondition.h"

typedef NS_ENUM(NSUInteger, FiltType) {
    Filt_All,
    Filt_Valuable,
    Filt_NoneValue,
};


typedef void(^SQLConditionBlock)(MPSQLCondition*condition);

@interface MPSQLExecutor : NSObject

@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic, copy) NSString *tableName;

- (BOOL)creatTableInModel:(id)model;

- (BOOL)insertItemInModel:(id)model;

- (BOOL)deleteItemsInModel:(id)model Where:(SQLConditionBlock)condition;

- (BOOL)updateItemsInModel:(id)model where:(SQLConditionBlock)condition;

- (NSArray*)selectItemsInModel:(id)model filter:(FiltType)filter where:(SQLConditionBlock)condition;

@end
