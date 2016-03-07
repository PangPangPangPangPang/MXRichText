//
//  MXEmojiNode.m
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXEmojiNode.h"
#import "UIView+Coordinate.h"

static NSDictionary *emojiDictory = nil;

@implementation MXEmojiNode

+ (NSDictionary *)emojiDictory {
    if (!emojiDictory) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiList" ofType:@"plist"];
        emojiDictory = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return emojiDictory;
}

- (id)initWithArgs:(NSDictionary *)args {
    self = [super init];
    if (self) {
        
        UIImage *emojiImage = [UIImage imageNamed:[[MXEmojiNode emojiDictory] valueForKey:[args valueForKey:@"content"]]];
        if (emojiImage) {
            UIImageView *imageView = [UIImageView new];
            [imageView setImage:emojiImage];
            [imageView setSuppositionalSize:CGSizeMake(24, 28)];
            [imageView setInset:UIEdgeInsetsMake(4, 2, 0, 2)];
            self.content = imageView;
            self.size = imageView.suppositionalSize;
        }
    }
    return self;
}

@end
