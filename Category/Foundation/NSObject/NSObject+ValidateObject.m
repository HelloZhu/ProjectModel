//
//  NSObject+ValidateObject.m
//  ESD
//
//  Created by ap2 on 15/7/6.
//  Copyright (c) 2015年 zac. All rights reserved.
//

#import "NSObject+ValidateObject.h"

@implementation NSObject (ValidateObject)

- (BOOL)isDictionary
{
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)isArray
{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isString
{
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isNSNumber
{
    return [self isKindOfClass:[NSNumber class]];
}

@end
