//
//  UIStoryboard+Addition.h
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Addition)

+ (UIStoryboard *)mainStoryBoard;
/**
 *  Initiate MasterViewController from story board
 */
+ (id)masterViewController;

/**
 *  Initiate DetailViewController from story board
 */
+ (id)detailViewController;

@end
