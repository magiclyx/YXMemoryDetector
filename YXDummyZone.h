//
//  YXDummyZone.h
//  YXMemoryDetector
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXMemUtility.h"

void yx_dummyzone_initialize(void);
DummyZoneRef yx_dummyzone_create_from_zone(struct _malloc_zone_t *zone); //not thread safe !!
DummyZoneRef yx_dummyzone_search_from_zone(struct _malloc_zone_t *zone);

