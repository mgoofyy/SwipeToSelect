//
//  NSArray+Random.m
//  SwipeToSelect
//
//  Created by goofygao on 16/3/23.
//  Copyright © 2016年 leon. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

+ (instancetype)arrayForRandom:(NSArray *)array {
    NSMutableArray *randomArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        int value = (arc4random() % array.count);
        [randomArray addObject:array[value]];
    }
    return randomArray;
}

@end
