//
//  YXTransplant.h
//  YXOCLib
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#ifndef _YXTRANSPLANT_H_
#define _YXTRANSPLANT_H_

/* from YXOCLib -> YXCompileUtility.h */
#define ___YXDUMMY_DIAGOSTIC(a) #a
#define __YXDUMMY_DIAGOSTIC(a) ___YXDUMMY_DIAGOSTIC(clang diagnostic a)
#define _YXDUMMY_DIAGOSTIC(a) _Pragma(__YXDUMMY_DIAGOSTIC(a))

#define _YXDUMMY_DIAGOSTIC_PUSH _YXDUMMY_DIAGOSTIC(push)
#define _YXDUMMY_DIAGOSTIC_POP _YXDUMMY_DIAGOSTIC(pop)
#define _YXDUMMY_DIAGOSTIC_IGNORE(a) _YXDUMMY_DIAGOSTIC(ignored #a)

/* from YXLib -> yx_clang_def.h */
#define YX_LIKELY(x)    __builtin_expect(!!(x), 1)
#define YX_UNLIKELY(x)  __builtin_expect(!!(x), 0)

/* from YXLib -> yx_datamode_headers.h */
#define YX_ALIGNMENT 8 //alignment

/* from YXLib -> yx_core_mem.h */
#define YX_STRUCT_ALIGNMENT_INFILLING_STUFF_SIZE(structSize) (((structSize) + (YX_ALIGNMENT - 1)) / YX_ALIGNMENT)*YX_ALIGNMENT - (structSize)
#define YX_STRUCT_ALIGNMENT_INFILLING(structSize) yx_byte __struct_aligment_infilling__[YX_STRUCT_ALIGNMENT_INFILLING_STUFF_SIZE(structSize)]

/* from YXLib -> yx_core_assert.h */
#define __YX_STATIC_ASSERT_PRIVATE_JOIN_(A, B) __YX_STATIC_ASSERT_PRIVATE_JOIN_IMPL_(A, B)
#define __YX_STATIC_ASSERT_PRIVATE_JOIN_IMPL_(A, B) A ## B
#define YX_STATIC_ASSERT(condition) typedef char __YX_STATIC_ASSERT_PRIVATE_JOIN_(yx_static_assert_result, __LINE__) [condition? 1:-1]
#define YX_STATIC_ASSERT_MSG(condition, message) YX_STATIC_ASSERT(condition)
#define YX_STATIC_ASSERT_ALIGMENT(struct)  YX_STATIC_ASSERT(0 == (sizeof(struct) % YX_ALIGNMENT))

/* from YXLib -> yx_macosx_mem.h */
#define yx_os_memzero(mem, len)             (void) memset(mem, 0, len)

/* from YXLib -> yx_macosx_basictypes.h */
//typedef int32_t     yx_int32;
//typedef uint32_t    yx_uint32;
typedef uint64_t    yx_ulong64;
typedef unsigned char    yx_uchar8;
//typedef yx_int32 yx_int;
//typedef yx_uint32 yx_uint;

/* from YXLib -> yx_macosx_types.h */
typedef yx_uchar8 yx_byte;
typedef yx_ulong64 yx_value;

#endif /* _YXTRANSPLANT_H_ */
