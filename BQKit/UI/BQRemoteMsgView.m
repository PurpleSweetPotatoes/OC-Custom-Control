//
//  BQRemoteMsgView.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/2.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRemoteMsgView.h"
#import "BQScreenAdaptation.h"
#import "UIView+Custom.h"
#import "CALayer+Custom.h"
#import "UIColor+Custom.h"

@interface BQRemoteMsgView()
@property (nonatomic, copy) void(^callBack)();
@end

@implementation BQRemoteMsgView

static const NSMutableArray * messages;
static BOOL isShow;

+ (void)showRemoteMsgWithTitle:(NSString *)title
                       content:(NSString *)content
                        handle:(void (^)())handle {
    if (title.length == 0 || content.length == 0 || handle == nil) {
        return;
    }
    NSDictionary * dict = @{@"title":title,@"content":content,@"handle":handle};
    [messages addObject:dict];
    
    [self showRemoteView];
}

#pragma mark - class Method
+ (void)load {
    [super load];
    messages = [NSMutableArray array];
    isShow = NO;
}

+ (void)showNextMsg {
    if (messages.count == 0) {
        return;
    }
    [self showRemoteView];
}
+ (void)showRemoteView {
    if (!isShow) {
        isShow = YES;
        BQRemoteMsgView * view = [[BQRemoteMsgView alloc] initWithFrame:CGRectMake(8, 0, KScreenWidth - 16, 80)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.windowLevel = UIWindowLevelStatusBar;
        [window addSubview:view];
        [view startAnimation];
    }
}
- (void)dealloc {
    isShow = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;
    [BQRemoteMsgView showNextMsg];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestures];
        [self setUpUI];
    }
    return self;
}

#pragma mark - private Method

- (void)setUpUI {
    CGFloat spacing = 12;
    CAShapeLayer * topLayer = [CAShapeLayer layer];
    topLayer.frame = CGRectMake(0, 0, self.sizeW, 36);
    topLayer.fillColor = [UIColor colorFromHexString:@"ecf7ff"].CGColor;
    UIBezierPath * topPath = [UIBezierPath bezierPathWithRoundedRect:topLayer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(13, 13)];
    topLayer.path = topPath.CGPath;
    topLayer.opacity = 0.9;
    
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spacing, 0, self.sizeW - spacing * 2, 36)];
    titleLab.font = [UIFont boldSystemFontOfSize:14];
    titleLab.textColor = [UIColor colorFromHexString:@"255bad"];
    
    UILabel * contentLab = [[UILabel alloc] initWithFrame:CGRectMake(spacing, titleLab.sizeH + spacing, titleLab.sizeW, 10)];
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.text = @"这";
    contentLab.textColor = [UIColor colorFromHexString:@"444444"];
    
    CAShapeLayer * bottomLayer = [CAShapeLayer layer];
    bottomLayer.frame = CGRectMake(0, topLayer.bounds.size.height, self.sizeW, spacing * 2 + contentLab.sizeH);
    bottomLayer.fillColor = [UIColor colorFromHexString:@"d6ecfe"].CGColor;
    UIBezierPath * bottomPath = [UIBezierPath bezierPathWithRoundedRect:bottomLayer.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    bottomLayer.path = bottomPath.CGPath;
    bottomLayer.opacity = 0.9;
    
    
    bottomLayer.sizeH = contentLab.sizeH + spacing * 2;
    
    self.sizeH = bottomLayer.sizeH + topLayer.sizeH;
    
    self.top = - self.sizeH;
    
    UIView * shadowView = [[UIView alloc] initWithFrame:self.bounds];
    shadowView.layer.shadowRadius = 8;
    shadowView.layer.shadowOffset = CGSizeMake(0, 5);
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity = 0.4;
    shadowView.layer.cornerRadius = 13;
    [self addSubview:shadowView];
    [shadowView.layer addSublayer:topLayer];
    [shadowView.layer addSublayer:bottomLayer];
    [shadowView addSubview:titleLab];
    [shadowView addSubview:contentLab];
    
    //赋值
    NSDictionary * dict = messages.firstObject;
    [messages removeObjectAtIndex:0];
    titleLab.text = dict[@"title"];
    contentLab.text = dict[@"content"];
    self.callBack = dict[@"handle"];
}
- (void)addGestures {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTopGesture)];
    [self addGestureRecognizer:tap];
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    swip.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swip];
    [swip requireGestureRecognizerToFail:tap];
}

#pragma mark - Animation
- (void)startAnimation {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.top = 8;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf && [weakSelf superview]) {
                [weakSelf removeSelf];
            }
        });
    }];
}
- (void)removeSelf {
    [UIView animateWithDuration:0.25 animations:^{
        self.top = - CGRectGetMaxY(self.frame);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - Gesture
- (void)actionTopGesture {
    self.callBack();
    [self removeSelf];
}

@end
