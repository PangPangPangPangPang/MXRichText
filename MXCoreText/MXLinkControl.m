//
//  MXLinkControl.m
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXLinkControl.h"

@implementation MXLinkControl

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.16]];
    }else {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

@end
