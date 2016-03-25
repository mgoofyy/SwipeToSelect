//
//  NSArray+SloveString.h
//  SwipeToSelect
//
//  Created by goofygao on 16/3/26.
//  Copyright © 2016年 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SloveString)

/**
 *  数组字符串全部变成大写
 */
+ (instancetype)initWithArrayToCapital:(NSArray *)array;

/**
 *  数组字符串全部变成小写
 */
+ (instancetype)initWithArrayToLower:(NSArray *)array;

/**
 *  数组字符串首字母大写
 */
+ (instancetype)initWithArrayToFirstWordCap:(NSArray *)array;
@end
