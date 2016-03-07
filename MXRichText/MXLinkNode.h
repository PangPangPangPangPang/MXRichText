//
//  MXLinkNode.h
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXBaseNode.h"

typedef NS_ENUM(NSInteger, LinkType) {
    normalLink = 1,
    telLink = 2
};

@interface MXLinkNode : MXBaseNode

@property (nonatomic, assign)NSRange range;
@property (nonatomic, assign)LinkType type;

- (id)initWithRange:(NSRange)range
            content:(id)content
               type:(LinkType)type;
@end
