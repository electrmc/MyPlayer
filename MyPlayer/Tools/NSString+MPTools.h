//
//  NSString+MPTools.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/19.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MPTools)

+ (NSString*)URLDecodedString:(NSString*)str;

+ (NSString *)randomStringWithLength:(NSInteger)len;

@end
