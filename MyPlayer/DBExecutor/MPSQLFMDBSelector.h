//
//  MPSQLFMDBSelector.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/8.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

@interface MPSQLFMDBSelector : NSObject

+ (id)valueFromFMDBResult:(FMResultSet*)rs Type:(NSString*)type columnName:(NSString*)name;

@end
