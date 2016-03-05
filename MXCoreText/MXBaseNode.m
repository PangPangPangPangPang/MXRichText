//
//  MXBaseNode.m
//  MXCoreText
//
//  Created by Max on 16/3/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXBaseNode.h"
#import "UIView+Coordinate.h"

CGFloat ascentCallback(void *ref) {
    MXBaseNode *node = (__bridge MXBaseNode *)ref;
    return node.ascent;
}

CGFloat descentCallback(void *ref) {
    MXBaseNode *node = (__bridge MXBaseNode *)ref;
    if (node.size.height > node.ascent + node.descent + node.lineSpace) {
        return node.size.height - node.ascent - node.lineSpace;
    }
    return node.size.height - node.ascent;
}
CGFloat widthCallback(void* ref) {
    MXBaseNode *node = (__bridge MXBaseNode *)ref;
    return node.size.width;
}
void deallocCallback(void* ref) {
    
}


@implementation MXBaseNode

- (id)initWithContent:(UIView *)content {
    self = [super init];
    if (self) {
        _content = content;
        if (CGSizeEqualToSize(content.suppositionalSize, CGSizeZero)) {
            NSAssert(false, @"the node need a suppositionalSize");
        }
        _size = content.suppositionalSize;
    }
    return self;
}

@end
