// *******************************************
//  File Name:      CameraGestureView.m       
//  Author:         MrBai
//  Created Date:   2021/12/21 5:38 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CameraGestureView.h"

@interface CameraGestureView ()
<
CAAnimationDelegate
>
@property (nonatomic, strong) CALayer * foucsLayer;     ///<  聚焦框
@property (nonatomic, assign) CGFloat currentZoom;      ///<  当前焦距比例
@end

@implementation CameraGestureView


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)tapGestureClick:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self];
        [self.manager focusAtPoint:point vSize:self.bounds.size];
        [self.manager exposeAtPoint:point vSize:self.bounds.size];
        [self focusLayerAnimation:point];
    }
}

- (void)pinGestureAction:(UIPinchGestureRecognizer *)sender {
    static CGFloat kZoomValue;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentZoom = self.manager.device.videoZoomFactor;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        kZoomValue = self.currentZoom * sender.scale;
        [self.manager setVideoZoomFactor:kZoomValue]; 
    }
}
#pragma mark - *** Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.foucsLayer.hidden = YES;
    [self.foucsLayer removeAllAnimations];
}

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureAction:)];
    [self addGestureRecognizer:pin];
}

- (void)focusLayerAnimation:(CGPoint)point {
    CALayer *focusLayer = self.foucsLayer;
    focusLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [focusLayer setPosition:point];
    focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
    [CATransaction commit];
    
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [focusLayer addAnimation: animation forKey:@"animation"];
}

#pragma mark - *** Set

#pragma mark - *** Get
    
- (CALayer *)foucsLayer {
    if (_foucsLayer == nil) {
        CALayer * foucslayer = [CALayer layer];
        foucslayer.bounds = CGRectMake(0, 0, 60, 60);
        foucslayer.contents = (__bridge id)[UIImage imageNamed:@"camera_foucs"].CGImage;
        foucslayer.hidden = YES;
        [self.layer addSublayer:foucslayer];
        _foucsLayer = foucslayer;
    }
    return _foucsLayer;
}
@end
