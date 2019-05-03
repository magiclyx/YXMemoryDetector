//
//  YXMemUtility.h
//  YXMemoryDector
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#ifndef YXMemUtility_h
#define YXMemUtility_h

#import <sys/mman.h>
#import <libkern/OSAtomicDeprecated.h>
#import <malloc/malloc.h>
#include <objc/runtime.h>
//#import "IsObjcObject.h"
#include <stddef.h>
#import "YXTransplant.h"


#pragma mark - magic number
#define YX_MEMORY_MAGICNUM_STACK_UNINIT 0xCCCCCCCC

#define YX_MEMORY_MAGICNUM_HEAP_UNINIT 0xCDCDCDCD
#define YX_MEMORY_MAGICNUM_HEAP_FREED 0xFEEEFEEE
#define YX_MEMORY_MAGICNUM_HEAP_GUARD 0xABABABAB
#define YX_MEMORY_MAGICNUM_HEAP_MALLOCED 0xBAADF00D



typedef void (*YX_Malloc_Free)(struct _malloc_zone_t *zone, void *ptr);
typedef void* (*YX_Malloc_Malloc)(struct _malloc_zone_t *zone, size_t size);
typedef void (*YX_Free_definite_size)(struct _malloc_zone_t *zone, void *ptr, size_t size);
typedef void* (*YX_Calloc)(struct _malloc_zone_t *zone, size_t num_items, size_t size);
typedef void* (*YX_Valloc)(struct _malloc_zone_t *zone, size_t size);


typedef struct DummyZone{
    YX_Malloc_Free free;
    YX_Free_definite_size free_definite_size;
    YX_Malloc_Malloc malloc;
    YX_Calloc calloc;
    YX_Valloc valloc;
    const char* zone_name;
}DummyZone, *DummyZoneRef;




#pragma mark - monitor
#define YXMEMZONE_START(z,dz)  do{\
_YXDUMMY_DIAGOSTIC_PUSH \
_YXDUMMY_DIAGOSTIC_IGNORE(-Wdeprecated-declarations) \
mprotect(z, sizeof(malloc_zone_t), PROT_READ | PROT_WRITE);OSMemoryBarrier();\
}while(0)
#define YXMEMZONE_ON(o, n, b) do{ \
OSAtomicCompareAndSwapPtr((*((void*volatile*)&(b))),(*((void*volatile*)&(o))),((void*volatile*)&(b))); \
OSAtomicCompareAndSwapPtr((*((void*volatile*)&(b))),((void*)(n)),((void*volatile*)&(o))); \
}while(0)
#define YXMEMZONE_DONE(z,dz)  do{dz->zone_name=z->zone_name;OSMemoryBarrier();mprotect(zone,sizeof(malloc_zone_t),PROT_READ);\
_YXDUMMY_DIAGOSTIC_POP \
}while(0)


#endif /* YXMemUtility_h */
