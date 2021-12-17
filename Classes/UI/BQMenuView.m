// *******************************************
//  File Name:      BQMenuView.m       
//  Author:         MrBai
//  Created Date:   2020/6/30 2:24 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQMenuView.h"
#import "UIView+Custom.h"
#import "UILabel+Custom.h"
#import "CALayer+Custom.h"
#import <objc/runtime.h>

@interface BQMenuView ()
@property (nonatomic, assign) CGPoint showPoint;
@property (nonatomic, strong) NSArray<NSString *> * imgs;
@property (nonatomic, strong) NSArray <NSString *> * titles;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, copy) MenuBlock handBlock;
@end

@implementation BQMenuView


#pragma mark - *** Public method

+ (void)showWithTargetFrame:(CGRect)frame
                       imgs:(NSArray <NSString *> *)imgs
                     titles:(NSArray <NSString *> *)titles
                handleblock:(MenuBlock)block {

    NSString * msg = @"";
    
    if (imgs.count > 0 && imgs.count != titles.count) {
        msg = @"图片与标题数量须对等";
    } else if (titles.count == 0) {
        msg = @"必须包含标题";
    }
    
    CGFloat centX = frame.size.width * 0.5 + frame.origin.x;
    CGFloat centY = CGRectGetMaxY(frame);
    
    if (centX <= 10 || centY <= 0) {
        msg = @"展示位置异常";
    }
    
    if (msg.length > 0) {
        NSAssert(NO, msg);
    }
    
    BQMenuView * menuV = [[BQMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menuV.backgroundColor = [UIColor clearColor];
    menuV.showPoint = CGPointMake(centX, centY);
    menuV.imgs = imgs;
    menuV.titles = titles;
    menuV.lineHeight = 40;
    menuV.handBlock = block;
    [menuV configUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:menuV];
}

#pragma mark - *** Life cycle

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    NSInteger index = point.y / self.lineHeight;
    if (self.handBlock) {
        self.handBlock(index);
    }
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {

    CGFloat rowHeight = self.lineHeight;
    
    UIView * tapV = [[UIView alloc] initWithFrame:CGRectMake(0, self.showPoint.y + 10, 80, self.titles.count * rowHeight)];
    tapV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [tapV setRadius:6];
    [self addSubview:tapV];
    
    CALayer * layer = [self arrowImgLayerWithColor:tapV.backgroundColor];
    [self.layer addSublayer:layer];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapV addGestureRecognizer:tap];
    
    CGFloat space = 0;
    for (NSInteger i = 0; i < self.titles.count; i ++) {
        space = 15;
        if (self.imgs.count > i) {
            UIImageView  * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgs[i]]];
            imgV.frame = CGRectMake(space, i * rowHeight, rowHeight, rowHeight);
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [tapV addSubview:imgV];
            space = rowHeight + 30;
        }
        
        UILabel * lab = [UILabel labWithFrame:CGRectMake(space, i * rowHeight, 100, rowHeight) title:self.titles[i] font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
        [lab widthToFit];
        [tapV addSubview:lab];
        if (tapV.width < lab.right + 15) {
            tapV.width = lab.right + 15;
        }
    }
    
    tapV.left = self.showPoint.x - tapV.width * 0.5 + 7;
    
    for (NSInteger i = 0; i < self.titles.count - 1; i++) {
        CALayer * lineLayer = [CALayer layerWithFrame:CGRectMake(space, rowHeight - 0.5 + i * rowHeight, tapV.width - space, 0.5) color:[UIColor whiteColor]];
        [tapV.layer addSublayer:lineLayer];
    }
    
    if (tapV.left < 10) {
        tapV.left = 10;
    } else if (tapV.right > self.width) {
        tapV.right = self.width - 10;
    }
}

- (CALayer *)arrowImgLayerWithColor:(UIColor *)color {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(self.showPoint.x, self.showPoint.y, 15, 10);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(7, 0)];
    [path addLineToPoint:CGPointMake(0, 10)];
    [path addLineToPoint:CGPointMake(15, 10)];
    [path addLineToPoint:CGPointMake(7, 0)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.fillColor = color.CGColor;
    
    return layer;
}

#pragma mark - *** Set

#pragma mark - *** Get
    

@end

@implementation UIBarButtonItem(BQMenu)

- (void)showBQMenuViewWithTitles:(NSArray <NSString *> *)titles
                      handleblock:(MenuBlock)block {
    [self showBQMenuViewWithImgs:@[] titles:titles handleblock:block];
}

- (void)showBQMenuViewWithImgs:(NSArray <NSString *> *)imgs
                        titles:(NSArray <NSString *> *)titles
                   handleblock:(MenuBlock)block {
    Ivar ivar = class_getInstanceVariable([UIBarButtonItem class], "_view");
    UIView *v = object_getIvar(self, ivar);
    CGRect rect = [v.superview convertRect:v.frame toView:[UIApplication sharedApplication].keyWindow];
    [BQMenuView showWithTargetFrame:rect imgs:imgs titles:titles handleblock:block];
}
@end

@implementation UIView(BQMenu)

- (void)showBQMenuViewWithTitles:(NSArray <NSString *> *)titles
                      handleblock:(MenuBlock)block {
    [self showBQMenuViewWithImgs:@[] titles:titles handleblock:block];
}

- (void)showBQMenuViewWithImgs:(NSArray <NSString *> *)imgs
                        titles:(NSArray <NSString *> *)titles
                   handleblock:(MenuBlock)block {
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    [BQMenuView showWithTargetFrame:rect imgs:imgs titles:titles handleblock:block];
}

@end
