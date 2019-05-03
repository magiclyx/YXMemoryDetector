//
//  YXMemoryDector.h
//  YXMemoryDector
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*支持自定义zone*/
//:~ TODO 未完成，不要打开
#define YXMEMORY_DETECTOR_SUPPORT_CUSTOM_ZONE 0

@interface YXMemoryDector : NSObject
+ (void)start;
+ (void)stop;
@end
