//
//  UIButton+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIButton+Custom.h"
#import "UIView+Custom.h"
#import <objc/runtime.h>

@interface UIButton ()
/**bool 类型 YES 不允许点击   NO 允许点击   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIButton (Custom)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

#pragma mark - 图片文字排版

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
        spacing = (self.frame.size.height - imgView.frame.size.height - titleLab.frame.size.height) / 3;
        if (spacing < 0) {
            spacing = 0;
        }
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

#pragma mark - 时间倒计时

- (void)reduceTime:(NSTimeInterval)time interval:(NSTimeInterval)interval callBlock:(void(^)(NSTimeInterval sec))block {
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:self.titleLabel.font.pointSize];
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

#pragma mark - 配置点击间隔

- (NSTimeInterval)timeInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//当我们按钮点击事件 sendAction 时  将会执行  mySendAction
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.timeInterval <= 0)
    {
        //不需要被hook
        [self mySendAction:action to:target forEvent:event];
        return;
    }
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"])
    {
        if (self.isIgnoreEvent)
        {
            return;
        }
        else if (self.timeInterval > 0)
        {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    //此处 methodA和methodB方法IMP互换了，实际上执行 sendAction；所以不会死循环
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
//runtime 动态绑定 属性
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent{
    //_cmd == @select(isIgnore); 和set方法里一致
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)resetState{
    [self setIsIgnoreEvent:NO];
}

#pragma mark - 扩大点击返回

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, @selector(hitTestEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if(value)
    {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

//扩大点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden)
    {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
