//
//  MXAttachmentNode.m
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXAttachmentNode.h"
#import "UIView+Coordinate.h"


@implementation MXAttachmentNode

- (id)initWithContent:(UIView *)content {
    self = [super init];
    if (self) {
        self.content = content;
        if (CGSizeEqualToSize(content.suppositionalSize, CGSizeZero)) {
            NSAssert(false, @"the node need a suppositionalSize");
        }
        self.size = content.suppositionalSize;
    }
    return self;
}

@end
