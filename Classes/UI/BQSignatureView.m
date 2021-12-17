// *******************************************
//  File Name:      BQSignatureView.m       
//  Author:         MrBai
//  Created Date:   2020/5/27 11:05 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQSignatureView.h"
#import "UIView+Custom.h"

@interface BQDrawView : UIView
@property (nonatomic, strong) NSMutableArray * pointArr;
@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
- (void)resetView;
- (UIImage *)currentImg;
@end

@interface BQSignatureView ()
@property (nonatomic, strong) UILabel * centLab;
@property (nonatomic, strong) UILabel * tipLab;
@property (nonatomic, strong) UIButton * resetBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) BQDrawView * drawView;
@property (nonatomic, copy) void(^handle)(UIImage * img);
@end

@implementation BQSignatureView


#pragma mark - *** Public method
+ (void)showWithHandle:(void(^)(UIImage * img))handle {
    BQSignatureView * view = [[BQSignatureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.handle = handle;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}
#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)resetBtnAction:(UIButton *)sender {
    [self.drawView resetView];
}

- (void)sureBtnAction:(UIButton *)sender {
    UIImage * image = [self.drawView currentImg];
    if (image) {
        self.handle(image);
        [self removeFromSuperview];
    } else {
        self.tipLab.text = @"请正确签写您的名字";
        self.tipLab.textColor = [UIColor colorWithRed:1.0 green:98/255.0 blue:82/255.0 alpha:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tipLab.text = @"请在框内用正楷手写您的名字";
            self.tipLab.textColor = [UIColor colorWithWhite:0 alpha:0.2];
        });
    }
}

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(70, (self.height - 500) * 0.5, self.width - 90, 500);
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.lineJoin = kCALineJoinRound;
    //  设置线宽，线间距
    shapeLayer.lineDashPattern = @[@(8),@(5)];
    //  设置路径
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:shapeLayer.bounds];
    shapeLayer.path = path.CGPath;
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
    
    
    [self addSubview:self.centLab];
    [self addSubview:self.tipLab];
    
    [self addSubview:self.resetBtn];
    [self addSubview:self.sureBtn];
    
    self.drawView = [[BQDrawView alloc] initWithFrame:shapeLayer.frame];
    self.drawView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.drawView];
    
}

#pragma mark - *** Set

#pragma mark - *** Get
    
- (UILabel *)centLab {
    if (_centLab == nil) {
        UILabel * centerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, self.width - 90)];
        centerLab.text = @"签 名 处";
        centerLab.font = [UIFont systemFontOfSize:100];
        centerLab.textColor = [UIColor colorWithWhite:0.4 alpha:0.2];
        centerLab.textAlignment = NSTextAlignmentCenter;
        centerLab.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        centerLab.origin = CGPointMake(100, (self.height - 500) * 0.5);
        _centLab = centerLab;
    }
    return _centLab;
}

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
        lab.text = @"请在框内用正楷手写您的名字";
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = [UIColor colorWithWhite:0 alpha:0.2];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        lab.origin = CGPointMake(110, (self.height - 500) * 0.5);
        _tipLab = lab;
    }
    return _tipLab;
}

- (UIButton *)resetBtn {
    if (_resetBtn == nil) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 80, 40);
        btn.layer.cornerRadius = 22;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:@"重 写" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        btn.origin = CGPointMake(15, self.height * 0.5 -  140);
        _resetBtn = btn;
    }
    return _resetBtn;
}

- (UIButton *)sureBtn {
    if (_sureBtn == nil) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 80, 40);
        btn.layer.cornerRadius = 22;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor colorWithRed:50/255.0 green:156/255.0 blue:1 alpha:1];
        [btn setTitle:@"确 定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        btn.origin = CGPointMake(15, self.height * 0.5 + 60);
        _sureBtn = btn;
    }
    return _sureBtn;
}
@end


@implementation BQDrawView
{
    NSMutableArray * _tempArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minX = CGFLOAT_MAX;
        self.minY = CGFLOAT_MAX;
        self.maxX = 0;
        self.maxY = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.backgroundColor setFill];
    for (NSArray * subArr in self.pointArr) {
        if (subArr.count > 1) {
            for (NSInteger i = 1; i < subArr.count; i++) {
                CGPoint prePt = [subArr[i - 1] CGPointValue];
                CGPoint curPt = [subArr[i] CGPointValue];
                CGContextMoveToPoint(context, prePt.x, prePt.y);
                CGContextAddLineToPoint(context, curPt.x, curPt.y);
                CGContextSetLineCap(context, kCGLineCapRound);
                CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextSetLineWidth(context, 4);
                CGContextStrokePath(context);
            }
        }
    }
}

- (UIImage *)currentImg {
    CGFloat length = 0;
    for (NSArray * subArr in self.pointArr) {
        if (subArr.count > 1) {
            for (NSInteger i = 1; i < subArr.count; i++) {
                CGPoint prePt = [subArr[i - 1] CGPointValue];
                CGPoint curPt = [subArr[i] CGPointValue];
                CGFloat distance = sqrt(pow((prePt.x - curPt.x), 2) + pow((prePt.y - curPt.y), 2));
                length += distance;
            }
        }
    }
    
    if (length < 600 || (self.maxY - self.minY) <= self.width * 0.4 || (self.maxX - self.minX) <= self.width * 0.4) {
        [self resetView];
        return nil;
    }
    
    CGSize size = CGSizeMake(self.height, self.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(context, -M_PI_2);
    CGContextTranslateCTM(context,-(self.height + self.minX + self.maxX) * 0.5,(self.height - self.maxY - self.minY) * 0.5);
    [self.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)resetView {
    [self.pointArr removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawWithPoint:(CGPoint)point {
    
    if (point.x < self.minX) {
        self.minX = point.x;
    }
    if (point.x > self.maxX) {
        self.maxX = point.x;
    }
    
    if (point.y < self.minY) {
        self.minY = point.y;
    }
    if (point.y > self.maxY) {
        self.maxY = point.y;
    }

    
    [_tempArr addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        _tempArr = [NSMutableArray array];
        [self.pointArr addObject:_tempArr];
        CGPoint location = [[touches anyObject] locationInView:self];
        [self drawWithPoint:location];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        CGPoint location = [[touches anyObject] locationInView:self];
        [self drawWithPoint:location];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1) {
        CGPoint location = [[touches anyObject] locationInView:self];
        [_tempArr addObject:[NSValue valueWithCGPoint:location]];
        [self.pointArr removeLastObject];
        [self.pointArr addObject:[_tempArr copy]];
        _tempArr = nil;
        [self setNeedsDisplay];
    }
}

- (NSMutableArray *)pointArr {
    if (_pointArr == nil) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

@end
