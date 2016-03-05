//
//  MXEmojiNode.h
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXBaseNode.h"

//static NSDictionary *emojiDictory;

@interface MXEmojiNode : MXBaseNode

- (id)initWithArgs:(NSDictionary *)args;
+ (NSDictionary *)emojiDictory;
@end
