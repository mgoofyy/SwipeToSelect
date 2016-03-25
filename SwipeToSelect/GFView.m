//
//  GFView.m
//  SwipeToSelect
//
//  Created by goofygao on 16/3/26.
//  Copyright © 2016年 leon. All rights reserved.
//

#import "GFView.h"

@interface GFView()

@property (nonatomic,strong) NSMutableArray *pointArray;

@end

@implementation GFView

-(NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UISwipeGestureRecognizer *showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
        showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:showExtrasSwipe];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *showExtrasSwipe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
        [self addGestureRecognizer:showExtrasSwipe];
    }
    return self;
}

#pragma mark  action
//处理点击事件
-(void)cellSwipe:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    CGPoint realTouchPoint = CGPointMake(location.x, location.y + 64);
    self.swipSelectPointArrayBlock(realTouchPoint);
}


#pragma mark touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
   
}
//处理滑动事件
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint realTouchPoint = CGPointMake(touchPoint.x, touchPoint.y + 64);
    self.swipSelectPointArrayBlock(realTouchPoint);
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}
@end
