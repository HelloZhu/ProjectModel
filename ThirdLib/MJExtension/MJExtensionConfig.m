//
//  MJExtensionConfig.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"


@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
#pragma mark 如果使用NSObject来调用这些方法，代表所有类都会生效
    

#pragma mark StatusResult类中的ads数组中存放的是Ad模型
    
    //[BingLiEntity setupObjectClassInArray:^NSDictionary *{return @{@"data" : @"BingLiEntity"};}];

}


@end
