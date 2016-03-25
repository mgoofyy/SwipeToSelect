//
//  GFView.h
//  SwipeToSelect
//
//  Created by goofygao on 16/3/26.
//  Copyright © 2016年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SwipSelectPointArrayBlock)(CGPoint point);

@interface GFView : UIView
/**
 *  滑动选择闭包
 */
@property (nonatomic, copy) SwipSelectPointArrayBlock swipSelectPointArrayBlock;



@end
