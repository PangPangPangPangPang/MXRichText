//
//  MXRichTextView.h
//  MXCoreText
//
//  Created by Max on 16/1/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXLinkNode.h"

@protocol MXRichTextViewDelegate <NSObject>

- (void)MXRichTextViewTriggerLink:(MXLinkNode *)node;

@end

@interface MXRichTextView : UIView

@property (nonatomic, weak)id<MXRichTextViewDelegate> delegate;

@property (nonatomic, copy)NSString *text;

@property (nonatomic, strong)NSMutableAttributedString *attributeString;

@property (nonatomic, strong)UIFont *font;

@property (nonatomic, strong)UIColor *fontColor;

@property (nonatomic, assign)NSLineBreakMode lineBreakMode;

@property (nonatomic, assign)NSTextAlignment textAlignment;

@property (nonatomic, assign)CGFloat lineSpace;

@property (nonatomic, assign)UIEdgeInsets padding;

@property (nonatomic, assign)NSInteger numberOfLines;

@property (nonatomic, strong)UIColor *telLinkColor;
- (void)insertNode:(UIView *)view
        atPosition:(NSInteger)position;

- (void)sizeToFit;
@end
