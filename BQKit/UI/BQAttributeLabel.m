//
//  BQAttributeLabel.m
//  AttributeStringDemo
//
//  Created by baiqiang on 2019/3/27.
//  Copyright © 2019年 Seven. All rights reserved.
//

#import "BQAttributeLabel.h"
#import <CoreText/CoreText.h>

@interface BQAttributeLabel()
@property (nonatomic, assign) BOOL  hasTapGesture;
@property (nonatomic, strong) NSMutableDictionary * blockInfos;
@property (nonatomic, copy) NSString * backStr;
@end

@implementation BQAttributeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blockInfos = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addTapBlockWithText:(NSString *)text {
    
    NSRange textRange = [[self.attributedText string] rangeOfString:text];
    
    if (textRange.length > 0) {
        [self addTapBlockWithRange:textRange];
    }
    
}

- (void)addTapBlockWithRange:(NSRange)range {
    
    if (!self.hasTapGesture) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testAction:)];
        [self addGestureRecognizer:tap];
        self.hasTapGesture = YES;
    }
    
    if (range.length > 0 && (range.location + range.length - 1 < self.attributedText.length)) {
        NSString * key = [NSString stringWithFormat:@"%ld-%ld",range.location, range.length];
        self.blockInfos[key] = [[self.attributedText string] substringWithRange:range];
    }
}

- (void)removeTapBlockWithText:(NSString *)text {
    NSRange textRange = [[self.attributedText string] rangeOfString:text];
    [self removeTapBlockWithRange:textRange];
}

- (void)removeTapBlockWithRange:(NSRange)range {
    if (range.length > 0) {
        NSString * key = [NSString stringWithFormat:@"%ld-%ld",range.location, range.length];
        [self.blockInfos removeObjectForKey:key];
    }
}

- (void)removeTapBlocks {
    [self.blockInfos removeAllObjects];
}

- (void)testAction:(UITapGestureRecognizer *)sender {
    
    if (self.backStr && [self.delegate respondsToSelector:@selector(attributeLabel:tapText:)]) {
        [self.delegate attributeLabel:self tapText:self.backStr];
        self.backStr = nil;
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self touchPoint:point]) {
        return self;
    }
    
    return nil;
}

- (BOOL)touchPoint:(CGPoint)p {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef  frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, NULL);
    CFRange     range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        UIFont *font = nil;
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        } else if (self.font){
            font = self.font;
        } else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGPathRelease(path);
        path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    }
    
    CFArrayRef  lines = CTFrameGetLines(frame);
    CFIndex     count = CFArrayGetCount(lines);
    NSInteger   numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines,count) : count;
    
    if (!numberOfLines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(path);
        return NO;
    }
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), origins);
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);;
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat ascent = 0.0f;
        CGFloat descent = 0.0f;
        CGFloat leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat height = ascent + fabs(descent*2) + leading;
        
        CGRect flippedRect = CGRectMake(p.x, p.y , width, height);
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        } else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, p)) {
            CGPoint relativePoint = CGPointMake(p.x, p.y);
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            for (NSString * key in self.blockInfos.allKeys) {
                NSArray * info = [key componentsSeparatedByString:@"-"];
                if (NSLocationInRange(index, NSMakeRange([info[0] integerValue], [info[1] integerValue]))) {
                    self.backStr = self.blockInfos[key];
                }
            }
   
        }
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
    return self.backStr != nil;
}

@end
