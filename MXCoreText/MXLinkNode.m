//
//  MXLinkNode.m
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXLinkNode.h"

@implementation MXLinkNode
- (id)initWithRange:(NSRange)range
            content:(id)content
               type:(LinkType)type {
    self = [super init];
    if (self) {
        _range = range;
        self.content = content;
        _type = type;
    }
    return self;
}
@end
