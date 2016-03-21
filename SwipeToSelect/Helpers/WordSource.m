//
//  WordSource.m
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import "WordSource.h"

@implementation WordSource

+ (NSArray *)data {
    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    return [text componentsSeparatedByString:@"\n"];
}

@end
