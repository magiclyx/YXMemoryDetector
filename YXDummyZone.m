//
//  YXDummyZone.m
//  YXMemoryDetector
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#import "YXDummyZone.h"
#import "YXMemUtility.h"

#define YX_MEMORY_DUMMYZONE_MAPPING_SIZE 131 //must primary number

typedef struct __yx_dummyzone_wrapper
{
    yx_value key;
    DummyZone dummy_zone;
    YX_STRUCT_ALIGNMENT_INFILLING(sizeof(struct __yx_dummyzone_wrapper*));
}__yx_dummyzone_wrapper;
YX_STATIC_ASSERT_ALIGMENT(struct __yx_dummyzone_wrapper);

static __yx_dummyzone_wrapper g_dummyzone_mapping[YX_MEMORY_DUMMYZONE_MAPPING_SIZE];
static size_t g_zone_size = 0;


void yx_dummyzone_initialize()
{
    if (0 == g_zone_size) {
        yx_os_memzero(g_dummyzone_mapping, sizeof(__yx_dummyzone_wrapper)*YX_MEMORY_DUMMYZONE_MAPPING_SIZE);
    }
}

DummyZoneRef yx_dummyzone_create_from_zone(struct _malloc_zone_t *zone)
{
    yx_value key = (yx_value)(unsigned long)(void*)zone->zone_name;
    unsigned long pos = (unsigned int)(labs((long)key) % YX_MEMORY_DUMMYZONE_MAPPING_SIZE);
    
    
    
    return NULL;
}

DummyZoneRef yx_dummyzone_search_from_zone(struct _malloc_zone_t *zone)
{
    return NULL;
}
