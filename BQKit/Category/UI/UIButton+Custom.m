//
//  UIButton+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIButton+Custom.h"
#import "UIView+Custom.h"


@implementation UIButton (Custom)

- (void)adjustLabAndImageLocation:(BtnEdgeType)type {
    [self adjustLabAndImageLocation:type spacing:5];
}

- (void)adjustLabAndImageLocation:(BtnEdgeType)type spacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    
    if (type == EdgeTypeCenter) {
        return;
    }

    UIImageView * imgView = self.imageView;
    UILabel * titleLab = self.titleLabel;
    CGFloat width = self.frame.size.width;
    CGFloat imageLeft = 0;
    CGFloat imageTop = 0;
    CGFloat titleLeft = 0;
    CGFloat titleTop = 0;
    CGFloat titleRift = 0;
    
    if (type == EdgeTypeImageTopLabBottom) {
        imageLeft = (width - imgView.frame.size.width) * 0.5 - imgView.frame.origin.x;
        imageTop = spacing - imgView.frame.origin.y;
        titleLeft = (width - titleLab.frame.size.width) * 0.5 - titleLab.frame.origin.x - titleLab.frame.origin.x;
        titleTop = spacing * 2 + imgView.frame.size.height - titleLab.frame.origin.y;
        titleRift = -titleLeft - titleLab.frame.origin.x * 2;
    } else if (type == EdgeTypeLeft) {
        imageLeft = spacing - imgView.frame.origin.x;
        titleLeft = spacing * 2 + imgView.frame.size.width - titleLab.frame.origin.x;
        titleRift = -titleLeft;
    } else {
        titleLeft = width - CGRectGetMaxX(titleLab.frame) - spacing;
        titleRift = -titleLeft;
        imageLeft = width - imgView.right - spacing * 2 - titleLab.frame.size.width;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft, -imageTop, -imageLeft);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, -titleTop, titleRift);
}

- (void)reduceTime:(NSTimeInterval)time interval:(NSTimeInterval)interval callBlock:(void(^)(NSTimeInterval sec))block {
    
    __block NSTimeInterval tempSecond = time;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (tempSecond <= interval) {
                dispatch_source_cancel(timer);
            }
            
            tempSecond -= interval;
            
            if (tempSecond < 0) {
                tempSecond = 0;
            }
            
            if (block) {
                block(tempSecond);
            }
        });
    });
    
    dispatch_resume(timer);
}

@end
