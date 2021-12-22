// *******************************************
//  File Name:      CameraGestureView.m       
//  Author:         MrBai
//  Created Date:   2021/12/21 5:38 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQGestureView.h"

@interface BQGestureView ()

@end

@implementation BQGestureView

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
        if ([self.delegate respondsToSelector:@selector(gestureView:tapPoint:)]) {
            CGPoint point = [sender locationInView:self];
            [self.delegate gestureView:self tapPoint:point];
        }
    }
}

- (void)pinGestureAction:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(gestureViewPinBegin:)]) {
            [self.delegate gestureViewPinBegin:self];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(gestureViewPinChange:changeValue:)]) {
            [self.delegate gestureViewPinChange:self changeValue:self.pinValue * sender.scale];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(gestureViewPinEnd:)]) {
            [self.delegate gestureViewPinEnd:self];
        }
    }
}

- (void)swipGestureAction:(UISwipeGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(gestureViewSwip:toLeft:)]) {
        [self.delegate gestureViewSwip:self toLeft:sender.direction == UISwipeGestureRecognizerDirectionRight];
    }
}

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureAction:)];
    [self addGestureRecognizer:pin];
    
    UISwipeGestureRecognizer * swipRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGestureAction:)];
    swipRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRightGesture];
    UISwipeGestureRecognizer * swipLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGestureAction:)];
    swipLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeftGesture];
    
}

#pragma mark - *** Set

#pragma mark - *** Get
    
@end
