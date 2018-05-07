//
//  MPSQLDescription.m
//  MyPlayer
//
//  Created by MiaoChao on 2018/5/4.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#import "MPSQLDescription.h"
#import <objc/runtime.h>

NSString * const SQLItemTypeKey = @"sql_item_type";
NSString * const SQLItemDescKey = @"sql_item_description";

static NSString * const SQLPrefix_TYPE = @"SQLT_";
static NSString * const SQLPrefix_Desc = @"SQLD_";

static NSString *pattern = @"<\\w*>";

static NSString * const SQL_TEXT_TYPE = @"NSString";
static NSString * const SQL_INTERGER_TYPE = @"NSNumber";
static NSString * const SQL_TEXT = @"TEXT";
static NSString * const SQL_INTERGER = @"INTERGER";

@interface MPSQLDescription()
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSDictionary*> *descriptionDic;
@end

@implementation MPSQLDescription

static MPSQLDescription *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.descriptionDic = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (NSDictionary<NSString*,NSDictionary*>*)sqlDescriptionWithModel:(id)model {
    NSDictionary *descriptionDic = [self.descriptionDic objectForKey:NSStringFromClass([model class])];
    if (!descriptionDic) {
        descriptionDic = [self getModelSQLDescription:model];
        if (descriptionDic) {
            [self.descriptionDic setObject:[descriptionDic copy] forKey:NSStringFromClass([model class])];
        }
    }
    return descriptionDic;
}

- (NSDictionary<NSString*,NSDictionary*>*)getModelSQLDescription:(id)model {
    NSMutableDictionary *descriptionDic = [NSMutableDictionary dictionary];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *describe = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        NSDictionary<NSString *,NSArray*> *protocolDes = [self getPropertyProtocolDescription:describe];
        protocolDes = protocolDes?protocolDes:@{};
        [descriptionDic setObject:[protocolDes copy] forKey:propertyName];
    }
    free(properties);
    
    return descriptionDic.count > 0 ? descriptionDic : nil;
}

- (NSDictionary<NSString *,NSArray*>*)getPropertyProtocolDescription:(NSString*)describe {
    if (!describe) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:describe options:0 range:NSMakeRange(0, describe.length)];
    
    NSMutableArray *typeAry = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *descAry = [NSMutableArray array];
    
    NSUInteger resCount = result.count;
    if (resCount < 1) {
        if ([describe containsString:SQL_TEXT_TYPE]) {
            [typeAry addObject:SQL_TEXT];
        } else if([describe containsString:SQL_INTERGER_TYPE]) {
            [typeAry addObject:SQL_INTERGER];
        } else {
            // do nothing
        }
    } else {
        for (int i=0; i<resCount; i++) {
            NSTextCheckingResult *res = result[i];
            NSRange range = NSMakeRange(res.range.location+1, res.range.length-2);
            NSString *protocolStr = [describe substringWithRange:range];
            
            NSMutableArray *tempAry = nil;
            if ([protocolStr hasPrefix:SQLPrefix_TYPE]) {
                protocolStr = [protocolStr substringFromIndex:SQLPrefix_TYPE.length];
                tempAry  = typeAry;
            } else if([protocolStr hasPrefix:SQLPrefix_Desc]) {
                protocolStr = [protocolStr substringFromIndex:SQLPrefix_Desc.length];
                tempAry = descAry;
            } else {
                // do nothing
            }
            
            NSArray *protocolAry = [protocolStr componentsSeparatedByString:@"_"];
            [tempAry addObjectsFromArray:protocolAry];
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (typeAry.count > 0) {
        [dic setObject:[typeAry copy] forKey:SQLItemTypeKey];
    }
    if (descAry.count > 0) {
        [dic setObject:[descAry copy] forKey:SQLItemDescKey];
    }
    return dic;
}

@end
