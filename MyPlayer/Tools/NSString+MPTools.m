//
//  NSString+MPTools.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/19.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "NSString+MPTools.h"

static NSString * letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation NSString (MPTools)

//转码方法
+ (NSString*)URLDecodedString:(NSString*)str {
    return  [str stringByRemovingPercentEncoding];
}

+ (NSString *)randomStringWithLength:(NSInteger)len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
