//
//  NSArray+SloveString.m
//  SwipeToSelect
//
//  Created by goofygao on 16/3/26.
//  Copyright © 2016年 leon. All rights reserved.
//

#import "NSArray+SloveString.h"

@implementation NSArray (SloveString)

/**
 *  数组字符串全部变成大写
 */
+ (instancetype)initWithArrayToCapital:(NSArray *)array {
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [tmpArray addObject:[array[i] uppercaseString]];
    }
    return tmpArray;
}

/**
 *  数组字符串全部变成小写
 */
+ (instancetype)initWithArrayToLower:(NSArray *)array {
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [tmpArray addObject:[array[i] lowercaseString]];
    }
    return tmpArray;
}

/**
 *  数组字符串首字母大写
 */
+ (instancetype)initWithArrayToFirstWordCap:(NSArray *)array {
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [tmpArray addObject:[array[i] capitalizedString]];
    }
    return tmpArray;}


@end
