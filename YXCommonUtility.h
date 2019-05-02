//
//  YXCommonUtility.h
//  YXOCLib
//
//  Created by Yuxi Liu on 2019/5/2.
//  Copyright © 2019 Yuxi Liu. All rights reserved.
//

#ifndef YXCommonUtility_h
#define YXCommonUtility_h


#define ___YXDUMMY_DIAGOSTIC(a) #a
#define __YXDUMMY_DIAGOSTIC(a) ___YXDUMMY_DIAGOSTIC(clang diagnostic a)
#define _YXDUMMY_DIAGOSTIC(a) _Pragma(__YXDUMMY_DIAGOSTIC(a))

#define _YXDUMMY_DIAGOSTIC_PUSH _YXDUMMY_DIAGOSTIC(push)
#define _YXDUMMY_DIAGOSTIC_POP _YXDUMMY_DIAGOSTIC(pop)
#define _YXDUMMY_DIAGOSTIC_IGNORE(a) _YXDUMMY_DIAGOSTIC(ignored #a)


#endif /* YXCommonUtility_h */
