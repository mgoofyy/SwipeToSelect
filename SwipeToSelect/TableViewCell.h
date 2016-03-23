//
//  TableViewCell.h
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;

typedef void(^CustomSelectBlock)(BOOL selected, NSString *string);

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property (nonatomic,assign) NSInteger row;

@property (nonatomic, copy) CustomSelectBlock customSelectedBlock;

@property (nonatomic,strong) NSArray *cellContentArray;

@end
