//
//  UIStoryboard+Addition.m
//  SwipeToSelect
//
//  Created by leon on 3/21/16.
//  Copyright © 2016 leon. All rights reserved.
//

#import "UIStoryboard+Addition.h"

@implementation UIStoryboard (Addition)

+ (UIStoryboard *)mainStoryBoard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (id)masterViewController {
    return [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"MasterViewController"];
}

+ (id)detailViewController {
    return [[UIStoryboard mainStoryBoard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
}

@end
