//
//  NSString+parser.m
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "NSString+parser.h"
#import "MXEmojiNode.h"

static NSRegularExpression *_tel_Expression = nil;
static  NSString * _Nonnull _tel_Pattern = @"[0-9]{3}[0-9-]+";

static NSRegularExpression *_emoji_Expression = nil;
static  NSString * _Nonnull _emoji_Pattern = @"【.{1,2}】";

static NSDictionary *_emojiDictory = nil;

@implementation NSString (parser)

- (NSArray *)matchTel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tel_Expression = [[NSRegularExpression alloc] initWithPattern:_tel_Pattern
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
    });
    return [_tel_Expression matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
}

- (NSMutableArray *)matchAndReplace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emoji_Expression = [[NSRegularExpression alloc] initWithPattern:_emoji_Pattern
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];

    });
    NSMutableString *mutString = [NSMutableString stringWithString:self];
    NSMutableArray  *mutArray = [NSMutableArray array];
    
    BOOL flag = true;
    while (flag) {
        NSTextCheckingResult *result = [_emoji_Expression firstMatchInString:mutString options:NSMatchingReportProgress range:NSMakeRange(0, mutString.length)];
        if (result) {
            NSString *tempString = [mutString substringWithRange:result.range];
            NSDictionary *tempdic = @{@"content" : tempString, @"position" : [NSNumber numberWithInteger:result.range.location]};
            [mutArray addObject:tempdic];
            [mutString replaceCharactersInRange:result.range withString:@""];
        }else {
            flag = false;
        }
    }
    for (NSInteger i = mutArray.count - 1; i >= 0; i--) {
        NSDictionary *emojiDic = mutArray[i];
        if (![[MXEmojiNode emojiDictory] valueForKey:[emojiDic valueForKey:@"content"]]) {
            [mutString insertString:[emojiDic valueForKey:@"content"] atIndex:[[emojiDic valueForKey:@"position"] integerValue]];
        }
    }
    
    if (mutArray.count > 0) {
        [mutArray addObject:mutString];
    }
    return mutArray;
}

@end
