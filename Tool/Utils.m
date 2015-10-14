//
//  Utils.m
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "Utils.h"
#import "WSProgressHUD.h"
#import "MBProgressHUD.h"

NSString * const BIRTH_DAY = @"birthday";

@implementation Utils

+ (long long)timeStmp
{
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSTimeInterval temp  =[localDate timeIntervalSince1970]*1000;
    long long timeSp = (long long)temp;
    NSLog(@"timeSp:%lld",timeSp); //时间戳的值

    return timeSp;
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string && [string isKindOfClass:[NSString class]])
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}



+ (void)showStatusToast:(NSString *)msg
{
    [WSProgressHUD showWithStatus:msg maskType:WSProgressHUDMaskTypeBlack];
}

+ (void)dismissStatusToast
{
    [WSProgressHUD dismiss];
}

+ (void)showSuccessToast:(NSString *)msg
{
     if ([Utils isBlankString: msg]) {return;}
    [WSProgressHUD showSuccessWithStatus:msg];
}

+ (void)showErrorToast:(NSString *)msg
{
     if ([Utils isBlankString: msg]) {return;}
    [WSProgressHUD showErrorWithStatus:msg];
}

+ (void)showString:(NSString *)msg
{
    [WSProgressHUD dismiss];
    if ([Utils isBlankString: msg]) {return;}
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)callWithPhone:(NSString *)phone
{
    if ([Utils isBlankString:phone]) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 
+ (void)ProertysAllKey:(NSDictionary *)jsonDic
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *path = @"/Users/zhu/Desktop/entity.h";
    
    
    
    NSArray *arr = [jsonDic allKeys];
    NSMutableArray *m_p = [NSMutableArray array];
    NSMutableArray *m_V = [NSMutableArray array];
    for (NSString *key in arr)
    {
        NSString *mykey = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;", key];
        NSString *value = [NSString stringWithFormat:@"entity.%@ = [dic stringValueForKey: -%@*]",key,key ];
        
        [m_V addObject: value];
        [m_p addObject: mykey];
    }
    
    NSData *teD = [NSKeyedArchiver archivedDataWithRootObject:m_p];
    
    [fm createFileAtPath:path contents:teD attributes:nil];
}

@end

void MMActivityIndicator_start() {
    [WSProgressHUD showWithStatus:@"请稍等..." maskType:WSProgressHUDMaskTypeBlack];
    
};

void MMActivityIndicator_stop() {
    [WSProgressHUD dismiss];
    
};

BOOL checkStringIsNull(NSString * str)
{
    if (str.length == 0 || str == nil) {
        return YES;
    }
    return NO;
}

NSString * documentImagePath()
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images/%@",path,imageNameWithTime()];
    return path;
}

NSString *imageNameWithTime()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    return fileName;
}

NSString * currentTimeString()
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}
