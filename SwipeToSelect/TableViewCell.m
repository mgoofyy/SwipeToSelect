//
//  TableViewCell.m
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import "TableViewCell.h"

#define THEME_COLOR [[UIColor blueColor] colorWithAlphaComponent:0.5]

@implementation TableViewCell

- (void)awakeFromNib {

    [self configureIndicator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIndicatorHighlighted:(BOOL)highlighted {
    self.indicator.highlighted = highlighted;
    if (highlighted) {
        self.indicator.backgroundColor = THEME_COLOR;
    } else {
        self.indicator.backgroundColor = [UIColor clearColor];
    }
}

- (void)configureIndicator {
    self.indicator.layer.borderColor = THEME_COLOR.CGColor;
    self.indicator.layer.borderWidth = 1.f;

    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(imageViewTapped:)];
    [self.indicator addGestureRecognizer:tap];
}

- (void)imageViewTapped:(UIGestureRecognizer *)gesture {
    [self setIndicatorHighlighted:!self.indicator.highlighted];
}

@end
