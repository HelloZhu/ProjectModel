//
//  NSObject+ValidateObject.h
//  ESD
//
//  Created by ap2 on 15/7/6.
//  Copyright (c) 2015年 zac. All rights reserved.
//

#import <Foundation/Foundation.h>

//对象校检
@interface NSObject (ValidateObject)

- (BOOL)isDictionary;
- (BOOL)isArray;
- (BOOL)isString;
- (BOOL)isNSNumber;

@end
