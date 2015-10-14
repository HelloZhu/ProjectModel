//
//  Constant.h
//  ProjectModel
//
//  Created by ap2 on 15/10/14.
//  Copyright © 2015年 ap2. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#pragma mark - 系统版本
#define isIOS7                [[UIDevice currentDevice].systemVersion doubleValue]>=7.0?YES:NO
#define isIOS8                [[UIDevice currentDevice].systemVersion doubleValue]>=8.0?YES:NO
#define isIOS9                [[UIDevice currentDevice].systemVersion doubleValue]>=8.0?YES:NO

#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]
#define TheBundleVerison       [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]

#pragma mark - 屏幕
#define STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT         (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))
#define FULL_WIDTH            SCREEN_WIDTH
#define FULL_HEIGHT           (SCREEN_HEIGHT - ((SYSTEM_VERSION >= 7) ? 0 : STATUSBAR_HEIGHT))
#define CONTENT_HEIGHT        (FULL_HEIGHT - NAVBAR_HEIGHT)
// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

#pragma mark - 颜色
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#pragma mark - 字体
#define BoldSystemFont(size)  [UIFont boldSystemFontOfSize:size]
#define systemFont(size)      [UIFont systemFontOfSize:size]

#define BLOCK_SAFE_RUN(block, ...)              block ? block(__VA_ARGS__) : nil;



#endif /* Constant_h */
