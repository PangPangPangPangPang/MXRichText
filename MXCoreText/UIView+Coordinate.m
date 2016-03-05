//
//  UIView+Coordinate.m
//  MXCoreText
//
//  Created by Max on 16/3/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "UIView+Coordinate.h"
#import "objc/runtime.h"

static const char *insetKey = "insetKye";
static const char *offSetKey = "offSetKey";
static const char *suppositionalSizeKey = "suppositionalSizeKey";

@implementation UIView (Coordinate)

- (void)setInset:(UIEdgeInsets)inset {
    objc_setAssociatedObject(self,
                             insetKey,
                             [NSValue valueWithUIEdgeInsets:inset],
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIEdgeInsets)inset {
    NSValue *value = objc_getAssociatedObject(self, insetKey);
    return [value UIEdgeInsetsValue];
}

- (void)setOffSet:(CGPoint)offSet {
    objc_setAssociatedObject(self,
                             offSetKey,
                             [NSValue valueWithCGPoint:offSet],
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGPoint)offSet {
    NSValue *value = objc_getAssociatedObject(self, offSetKey);
    return [value CGPointValue];
}

- (void)setSuppositionalSize:(CGSize)suppositionalSize {
    objc_setAssociatedObject(self,
                             suppositionalSizeKey,
                             [NSValue valueWithCGSize:suppositionalSize],
                             OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (CGSize)suppositionalSize {
    NSValue *value = objc_getAssociatedObject(self, suppositionalSizeKey);
    return [value CGSizeValue];

}




@end
