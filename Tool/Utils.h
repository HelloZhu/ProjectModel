//
//  Utils.h
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SCREENBOUNDS [[UIScreen mainScreen] bounds]

@interface Utils : NSObject

+ (long long)timeStmp;

+ (BOOL)isBlankString:(NSString *)string;

+ (void)dismissStatusToast;
+ (void)showStatusToast:(NSString *)msg;
+ (void)showSuccessToast:(NSString *)msg;
+ (void)showErrorToast:(NSString *)msg;
+ (void)showString:(NSString *)msg;

+ (void)callWithPhone:(NSString *)phone;

+ (void)ProertysAllKey:(NSDictionary *)jsonDic;
@end

extern NSString * const BIRTH_DAY;
extern void MMActivityIndicator_start();
extern void MMActivityIndicator_stop();
extern BOOL checkStringIsNull(NSString * str);
extern NSString *imageNameWithTime();
extern NSString * documentImagePath();
extern NSString * currentTimeString();
