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
+  (BOOL)createTable:(NSDictionary*)table;
@end
