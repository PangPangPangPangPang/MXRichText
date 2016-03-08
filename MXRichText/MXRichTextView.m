//
//  MXRichTextView.m
//  MXCoreText
//
//  Created by Max on 16/1/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MXRichTextView.h"
#import <CoreText/CoreText.h>
#import "MXAttachmentNode.h"
#import "UIView+Coordinate.h"
#import "NSString+parser.h"
#import "MXLinkControl.h"
#import "MXEmojiNode.h"

NSMutableAttributedString *replacementAttrString(){
    unichar replacementChar           = 0xFFFC;
    NSString *replacementString       = [NSString stringWithCharacters:&replacementChar
                                                                      length:1];
    NSMutableAttributedString *replacementAttrString   = [[NSMutableAttributedString alloc] initWithString:replacementString];
    return replacementAttrString;
}

CTTextAlignment transferTextAlignment(NSTextAlignment alignment) {
    switch (alignment) {
        case NSTextAlignmentCenter:
            return kCTTextAlignmentRight;
            break;
        case NSTextAlignmentRight:
            return kCTTextAlignmentCenter;
            break;
        default:
            return (CTTextAlignment)alignment;
            break;
    }
}

@implementation MXRichTextView {
    CTFrameRef        _frame;
    NSMutableArray   *_nodes;
    CGFloat           _ascent;
    CGFloat           _descent;
    CGFloat           _defaultLineSpace;
    NSMutableString  *_mutableString;
    NSMutableArray   *_links;
    NSMutableArray          *_emojis;
}

- (void)generateAttributedString {
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault,
                                                                              0);
    CFAttributedStringReplaceString(attrString,
                                    CFRangeMake(0, 0),
                                    (CFStringRef)_attributeString.string);

    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[_font fontName],
                                             [_font pointSize],
                                             &CGAffineTransformIdentity);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)_attributeString,
                                   CFRangeMake(0, [_attributeString.string length]),
                                   kCTFontAttributeName,
                                   fontRef);
    CFRelease(fontRef);
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)_attributeString,
                                   CFRangeMake(0, [_attributeString.string length]),
                                   kCTForegroundColorAttributeName,
                                   _fontColor.CGColor);
    
    CTLineBreakMode lineBreak = (CTLineBreakMode)_lineBreakMode;
    
    CTParagraphStyleSetting lineBreakStyle;
    lineBreakStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.value = &lineBreak;
    lineBreakStyle.valueSize = sizeof(CTLineBreakMode);
    
    CTTextAlignment alignment = transferTextAlignment(_textAlignment);
    
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.value = &alignment;
    alignmentStyle.valueSize = sizeof(CTTextAlignment);

    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.value = &_lineSpace;
    lineSpaceStyle.valueSize = sizeof(CGFloat);

    CTParagraphStyleSetting settings[] = {lineBreakStyle, alignmentStyle, lineSpaceStyle};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)_attributeString,
                                   CFRangeMake(0, [_attributeString.string length]),
                                   kCTParagraphStyleAttributeName,
                                   paragraphStyle);
    CFRelease(paragraphStyle);

}

- (void)insertNode:(UIView *)view
        atPosition:(NSInteger)position {
    
    CTRunDelegateCallbacks callbacks;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    callbacks.dealloc = deallocCallback;
    callbacks.version = kCTRunDelegateCurrentVersion;
    
    MXAttachmentNode *node = [[MXAttachmentNode alloc] initWithContent:view];
    node.lineSpace = _lineSpace;
    node.ascent = _ascent;
    node.descent = _descent;

    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(node));
    
    NSDictionary *attr = @{(NSString *)kCTRunDelegateAttributeName : (__bridge id)delegate,};
    [_attributeString insertAttributedString:replacementAttrString() atIndex:position];
    
    NSMutableString *temp = [NSMutableString stringWithString:_attributeString.string];
    [temp insertString:replacementAttrString().string atIndex:position];
    _text = [temp copy];
    
    [_attributeString setAttributes:attr range:NSMakeRange(position, 1)];
    [_nodes addObject:node];
    
    [self setNeedsDisplay];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer setNeedsDisplayOnBoundsChange:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        _nodes = [NSMutableArray new];
        _numberOfLines = 0;
        _fontColor = [UIColor blackColor];
        _telLinkColor = [UIColor blueColor];
        _links = [NSMutableArray new];
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        CTFontRef font = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize, NULL);
        _ascent = CTFontGetAscent(font);
        _descent = CTFontGetDescent(font);
        _defaultLineSpace = (_ascent + _descent) / 2;
        CFRelease(font);
    }
}

- (void)setText:(NSString *)text {
     _emojis = [text matchAndReplace];
    NSMutableString *parserString = [text mutableCopy];
    if (_emojis.count > 0) {
        parserString = [_emojis lastObject];
        [_emojis removeLastObject];
    }
    _text = [parserString copy];

    if (_attributeString) {
        CFAttributedStringReplaceString((CFMutableAttributedStringRef)_attributeString,
                                        CFRangeMake(0, 0),
                                        (CFStringRef)_text);
    }else {
        _attributeString = [[NSMutableAttributedString alloc] initWithString:_text];
    }
    for (NSDictionary *args in _emojis) {
        [self generateEmojiWithArgs:args];
    }
    [self setNeedsDisplay];
}

- (void)generateEmojiWithArgs:(NSDictionary *)args {
    CTRunDelegateCallbacks callbacks;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    callbacks.dealloc = deallocCallback;
    callbacks.version = kCTRunDelegateCurrentVersion;
    
    MXEmojiNode *node = [[MXEmojiNode alloc] initWithArgs:args];
    if (!node.content) {
        return;
    }
    node.lineSpace = _lineSpace;
    node.ascent = _ascent;
    node.descent = _descent;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(node));
    
    NSDictionary *attr = @{(NSString *)kCTRunDelegateAttributeName : (__bridge id)delegate,};
    [_attributeString insertAttributedString:replacementAttrString() atIndex:[[args valueForKey:@"position"] integerValue]];
    
    NSMutableString *temp = [NSMutableString stringWithString:_attributeString.string];
    [temp insertString:replacementAttrString().string atIndex:[[args valueForKey:@"position"] integerValue]];
    _text = [temp copy];
    
    [_attributeString setAttributes:attr range:NSMakeRange([[args valueForKey:@"position"] integerValue], 1)];
    [_nodes addObject:node];
}

- (void)drawRect:(CGRect)rect {
    
    [self prepareMatrix:rect];
    if (!_text) {
        return;
    }
    [self generateAttributedString];
    [self parserLink];
    
    [self generateFrame:rect];
    [self generateNode];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawRect:rect
           context:ctx];
    
    
}

- (void)parserLink {
    NSArray *tels = [_attributeString.string matchTel];
    for (NSTextCheckingResult *result in tels) {
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)_attributeString,
                                       CFRangeMake(result.range.location, result.range.length),
                                       kCTForegroundColorAttributeName,
                                       _telLinkColor.CGColor);
        
        MXLinkNode *node = [[MXLinkNode alloc] initWithRange:result.range
                                                     content:[_attributeString.string substringWithRange:result.range]
                                                        type:telLink];
        [_links addObject:node];

    }
}

- (void)generateNode {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CFArrayRef lines = CTFrameGetLines(_frame);
    NSUInteger lineCount = CFArrayGetCount(lines);
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, lineCount), lineOrigins);

    for (int i = 0; i < lineCount; i++) {
        
        if (_numberOfLines <= i && _numberOfLines != 0) {
            return;
        }
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint lineOrigin = lineOrigins[i];
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        NSUInteger runCount = CFArrayGetCount(runs);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);

        for (int j = 0; j < runCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CFRange runRange = CTRunGetStringRange(run);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, &offset);
            CGFloat ascent;
            CGFloat descent;
            CGFloat leading;
            CGFloat width;
            width = CTRunGetTypographicBounds(run,
                                      CFRangeMake(0, 0),
                                      &ascent,
                                      &descent,
                                      &leading);

            if (delegate) {
                MXBaseNode *node = (__bridge MXBaseNode *)CTRunDelegateGetRefCon(delegate);
                UIView *view = node.content;
                [view setFrame:CGRectMake(lineOrigin.x + offset + view.inset.left,
                                          self.frame.size.height - lineOrigin.y - lineAscent + view.inset.top,
                                          node.size.width - view.inset.left - view.inset.right,
                                          node.size.height - view.inset.left - view.inset.right)];
                [self addSubview:view];
                continue;
            }
            
            
            for (MXLinkNode *link in _links) {
                if (NSIntersectionRange(link.range, NSMakeRange(runRange.location, runRange.length)).length > 0) {
                    const CGPoint *_Nullable points = CTRunGetPositionsPtr(run);
                    CGFloat originX = points[0].x;
                    MXLinkControl *view= [MXLinkControl new];
                    view.node = link;
                    [view addTarget:self
                             action:@selector(onTapLink:)
                   forControlEvents:UIControlEventTouchUpInside];
                    [view setFrame:CGRectMake(originX,
                                              self.frame.size.height - lineOrigin.y - lineAscent - _ascent + ascent,
                                              width,
                                              ascent + descent)];
                    [self addSubview:view];
                    
                }
            }
        }
    }
    
}

- (void)onTapLink:(MXLinkControl *)control {
    if (_delegate && [_delegate respondsToSelector:@selector(MXRichTextViewTriggerLink:)]) {
        [_delegate MXRichTextViewTriggerLink:control.node];
    }
}

- (void)drawRect:(CGRect)rect
         context:(CGContextRef)ctx {
    if (_numberOfLines == 0) {
        CTFrameDraw(_frame, ctx);
        return;
    }
    
    CFArrayRef lines = CTFrameGetLines(_frame);
    NSUInteger lineCount = CFArrayGetCount(lines);

    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, lineCount), lineOrigins);
    for (int index = 0; index < lineCount; index++) {
        if (_numberOfLines <= index) {
            return;
        }
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, index);
        CGPoint lineOrigin = lineOrigins[index];
        CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, ctx);
    }

}

- (void)sizeToFit {
    [self generateAttributedString];
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)_attributeString);
    [self generateFrame:self.bounds];
    CFRange fitRange;
    CFRange range = CFRangeMake(0, _attributeString.string.length);
    CFArrayRef lines = CTFrameGetLines(_frame);
    NSInteger lineCount = CFArrayGetCount(lines);
    if (_numberOfLines > 0 && _numberOfLines < lineCount) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, _numberOfLines - 1);
         CFRange temp = CTLineGetStringRange(line);
        range = CFRangeMake(0, temp.length + temp.location);
    }
    
    CGSize size =  CTFramesetterSuggestFrameSizeWithConstraints(setter,
                                                                range,
                                                                NULL,
                                                                CGSizeMake(self.bounds.size.width, CGFLOAT_MAX),
                                                                &fitRange);
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
}

- (void)dealloc {
    CFRelease(_frame);
}

- (void)prepareMatrix:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(ctx, 0.f, rect.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
}

- (void)generateFrame:(CGRect)rect{
    if (_frame) {
        CFRelease(_frame);
        _frame = nil;
    }
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)_attributeString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, rect);
    _frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, NULL);
    CFRelease(setter);
    CFRelease(path);
}

@end


//        UIView *view1 = [UIView new];
//        [view1 setBackgroundColor:[UIColor redColor]];
//        [view1 setFrame:CGRectMake(0, self.frame.size.height - lineOrigin.y + lineDescent, self.frame.size.width / 2, 1)];
////        [self addSubview:view1];
//
//        UIView *view2 = [UIView new];
//        [view2 setBackgroundColor:[UIColor blueColor]];
//        [view2 setFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height - lineOrigin.y - lineAscent, self.frame.size.width / 2, 1)];
////        [self addSubview:view2];
//
//        UIView *view3 = [UIView new];
//        [view3 setBackgroundColor:[UIColor purpleColor]];
//        [view3 setFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height - lineOrigin.y, self.frame.size.width / 2, 1)];
////        [self addSubview:view3];

