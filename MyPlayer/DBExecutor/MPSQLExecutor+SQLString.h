//
//  MPSQLExecutor+SQLString.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/4.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSQLExecutor.h"

@interface MPSQLExecutor (SQLString)

- (NSString*)createTabelSql:(id)model;

- (NSString*)insertItemSql:(id)model;

- (NSString*)deleteItemSql:(id)model;

- (NSString*)updateItemSql:(id)model;

- (NSArray*)selectItemSql:(id)model filt:(FiltType)filter;

@end
