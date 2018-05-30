//
//  WeakBlock.h
//  MyPlayer
//
//  Created by MiaoChao on 2018/4/30.
//  Copyright © 2018年 MiaoChao. All rights reserved.
//

#ifndef WeakBlock_h
#define WeakBlock_h

#ifndef MPWeakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define MPWeakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define MPWeakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define MPWeakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define MPWeakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef MPStrongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define MPStrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define MPStrongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define MPStrongifyify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define MPStrongifyify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
#endif

#endif

#endif /* WeakBlock_h */
