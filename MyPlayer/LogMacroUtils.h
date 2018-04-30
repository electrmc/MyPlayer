//
//  LogLogMacroUtils.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#ifndef LogLogMacroUtils_h
#define LogLogMacroUtils_h

#ifdef DEBUG
#define MPLog(...) NSLog(__VA_ARGS__)
#define DebugMethod() NSLog(@"%s", __func__)
#else
#define MPLog(...)
#define DebugMethod()
#endif

#endif /* LogLogMacroUtils_h */
