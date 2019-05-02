//
//  YXMemoryDector.m
//  YXMemoryDector
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#import "YXMemoryDector.h"
#import "YXMemUtility.h"
#import <stdio.h>


#define ZONE_TYPE(zone, name)  (0==strncmp(zone->zone_name,(name),strlen((name))))

#define YXMEMZONE_MONITOR_ON(zone, dummyzone) \
do{YXMEMZONE_START((zone),dummy_zone); \
YXMEMZONE_ON((zone)->malloc, _yx_new_scalable_malloc, dummy_zone->malloc); \
YXMEMZONE_ON((zone)->calloc, _yx_new_calloc, dummy_zone->calloc); \
YXMEMZONE_ON((zone)->free, _yx_new_scalable_free, dummy_zone->free); \
YXMEMZONE_ON((zone)->free_definite_size, _yx_free_definite_size, dummy_zone->free_definite_size); \
YXMEMZONE_DONE((zone),dummy_zone); \
}while(0)

#define YXMEMZONE_MONITOR_OFF(zone, dummyzone) \
do{YXMEMZONE_START((zone),dummy_zone); \
YXMEMZONE_ON((zone)->free, _yx_new_scalable_free, dummy_zone->free); \
YXMEMZONE_ON((zone)->free_definite_size, _yx_free_definite_size, dummy_zone->free_definite_size); \
YXMEMZONE_DONE((zone),dummy_zone); \
}while(0)


#define YX_MEMORY_FIND_IN_FASTDUMMYZONE_RECORD(dummy_zone_pre) \
do{ for (int i=0; i<sizeof(all_dummy_zones)/sizeof(all_dummy_zones[0]); i++){ \
if (all_dummy_zones[i].zone_name == zone->zone_name) {(*(dummy_zone_pre)) = &(all_dummy_zones[i]); break;} \
}}while(0)


#define YX_MEMORY_FASTDUMMYZONE_WITH_ZONE(dummy_zone_ptr, zone) \
do{if (ZONE_TYPE(zone, FAST_ZONENAME_DEFAULT)){(*(dummy_zone_ptr)) = &(all_dummy_zones[DefaultZone]);}\
else if(ZONE_TYPE(zone, FAST_ZONENAME_HELPER)){(*(dummy_zone_ptr)) = &(all_dummy_zones[helperZone]);}\
else if(ZONE_TYPE(zone, FAST_ZONENAME_GFX)){(*(dummy_zone_ptr)) = &(all_dummy_zones[GFZZone]);}\
}while(0)


#define YX_MEMORY_MALLOC_WITH_SENTINEL(mem_ptr, zone, size) \
do{const size_t totalSize = sizeof(__yxsentinel) /*+ 2*YX_ALIGNMENT*/ + size; \
__yxptr mem_start = dummy_zone->malloc(zone, totalSize); \
(*(mem_ptr)) = mem_start; \
__yxsentinel* tail_sentinel = mem_start + size - sizeof(__yxsentinel); \
*tail_sentinel = YX_MEMORY_MAGICNUM_HEAP_GUARD; \
mprotect(tail_sentinel, sizeof(__yxsentinel), PROT_READ); \
}while(0)

#define YX_MEMORY_CLEAR_SENTINEL(zone, ptr) \
do{size_t size = malloc_size(ptr); \
if (YX_LIKELY(size > 0)){ \
__yxsentinel* tail_sentinel = ptr + size - sizeof(__yxsentinel); \
if (YX_LIKELY(*tail_sentinel  == YX_MEMORY_MAGICNUM_HEAP_GUARD)) {mprotect(tail_sentinel, sizeof(__yxsentinel), PROT_READ | PROT_WRITE);} \
}}while(0)


#define FAST_ZONENAME_DEFAULT "DefaultMallocZone"
#define FAST_ZONENAME_HELPER "MallocHelperZone"
#define FAST_ZONENAME_GFX "GFXMallocZone"



static void _yx_new_scalable_free(struct _malloc_zone_t *zone, void *ptr);
static void* _yx_new_scalable_malloc(struct _malloc_zone_t *zone, size_t size);
static void _yx_free_definite_size(struct _malloc_zone_t *zone, void *ptr, size_t size);
static void* _yx_new_calloc(struct _malloc_zone_t *zone, size_t num_items, size_t size);

typedef int32_t __yxsentinel;
typedef void* __yxptr;

typedef enum fastzoneIndex{
    DefaultZone = 0,
    helperZone,
    GFZZone,
}fastzoneIndex;


DummyZone all_dummy_zones[8];

#pragma mark YXMemoryDector

@implementation YXMemoryDector : NSObject


+ (void)start
{
    memset(all_dummy_zones, 0, sizeof(all_dummy_zones));
    
    vm_address_t* zones;
    unsigned int count;
    kern_return_t kr = malloc_get_all_zones(TASK_NULL, 0, &zones, &count);
    if (YX_LIKELY(kr == KERN_SUCCESS))
    {
        for (unsigned int i = 0; i < count; i++)
        {
            DummyZoneRef dummy_zone = NULL;
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            
            YX_MEMORY_FASTDUMMYZONE_WITH_ZONE(&dummy_zone, zone);
            if (YX_UNLIKELY(NULL == dummy_zone))
                continue;

            YXMEMZONE_MONITOR_ON(zone, dummy_zone);
            
        }
    }
}

+ (void)stop
{
    vm_address_t* zones;
    unsigned int count;
    kern_return_t kr = malloc_get_all_zones(TASK_NULL, 0, &zones, &count);
    if (YX_LIKELY(kr == KERN_SUCCESS))
    {
        for (unsigned int i = 0; i < count; i++)
        {
            DummyZoneRef dummy_zone = NULL;
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            
            YX_MEMORY_FASTDUMMYZONE_WITH_ZONE(&dummy_zone, zone);
            if (YX_UNLIKELY(NULL == dummy_zone))
                continue;
            
            YXMEMZONE_MONITOR_OFF(zone, dummy_zone);
            
        }
    }
}

@end


#pragma mark private

static void _yx_new_scalable_free(struct _malloc_zone_t *zone, void *ptr)
{
    DummyZoneRef dummy_zone = NULL;
    YX_MEMORY_FIND_IN_FASTDUMMYZONE_RECORD(&dummy_zone);
    
    if (YX_LIKELY(NULL != dummy_zone))
    {
        YX_MEMORY_CLEAR_SENTINEL(zone, ptr);
        return dummy_zone->free(zone, ptr);
    }
    
}


static void* _yx_new_scalable_malloc(struct _malloc_zone_t *zone, size_t size)
{
    
    DummyZoneRef dummy_zone = NULL;
    YX_MEMORY_FIND_IN_FASTDUMMYZONE_RECORD(&dummy_zone);

    if (YX_LIKELY(NULL != dummy_zone))
    {
        __yxptr mem;
        YX_MEMORY_MALLOC_WITH_SENTINEL(&mem, zone, size);

        return mem;
    }

    return NULL;
}

void _yx_free_definite_size (struct _malloc_zone_t *zone, void *ptr, size_t size)
{
    DummyZoneRef dummy_zone = NULL;
    YX_MEMORY_FIND_IN_FASTDUMMYZONE_RECORD(&dummy_zone);
    
    if (YX_LIKELY(NULL != dummy_zone &&  size > 0))
    {
        YX_MEMORY_CLEAR_SENTINEL(zone, ptr);
        return dummy_zone->free_definite_size(zone, ptr, size);
    }
    assert(0);
}

static void* _yx_new_calloc(struct _malloc_zone_t *zone, size_t num_items, size_t size)
{
    DummyZoneRef dummy_zone = NULL;
    YX_MEMORY_FIND_IN_FASTDUMMYZONE_RECORD(&dummy_zone);
    
    if (YX_LIKELY(NULL != dummy_zone))
    {
        __yxptr mem;
        YX_MEMORY_MALLOC_WITH_SENTINEL(&mem, zone, size);
        
        return mem;
    }
    
    return NULL;
}




