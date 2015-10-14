//
//  XLog.h
//  IOSDuoduo
//
//  Created by 东邪 on 14-5-23.
//  Copyright (c) 2014年 dujia. All rights reserved.
//


#import <Foundation/Foundation.h>


//-------------------打印--------------------
#ifdef DEBUG
#define NEED_OUTPUT_LOG             1
#else
#define NEED_OUTPUT_LOG             0
#endif

#if NEED_OUTPUT_LOG
#define DDLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLog(xx, ...)
#endif

#define _XLOG

#ifdef  _XLOG
#define	LogOut(format,...);      DLog(@"[%s][%d]" format,__func__,__LINE__,##__VA_ARGS__);
#define LogOutMethodFun          DLog( @"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd) );
#define LogError(format,...);    DLog(@"[error][%s][%d]" format,__func__,__LINE__,##__VA_ARGS__);
#define LogWaring(format,...);   DLog(@"[waring][%s][%d]" format,__func__,__LINE__,##__VA_ARGS__);
#define	LogTeym(format,...);     {}
#else
#define LogOut(format,...);      {}
#define LogOutMethodFun          {}
#define LogError(format,...);    {}
#define LogWaring(format,...);   {}
#define	LogTeym(format,...);     {}
#endif


