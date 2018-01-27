//
//  BQNumLabel.m
//  Test
//
//  Created by MrBai on 2017/6/29.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQNumLabel.h"
#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@interface BQNumLabel ()

@end

@implementation BQNumLabel

#pragma mark - create Method
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - private Method
- (void)initUI {
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor redColor];
    self.textColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
}

#pragma mark - set Method
- (void)setText:(NSString *)text {
    [super setText:text];
    CGPoint center = self.center;
    [self widthToFit];
    NSInteger width = self.sizeW + 8;
    self.sizeW = width % 2 == 0 ? width : width + 1;
    self.sizeH = self.sizeW;
    self.layer.cornerRadius = self.sizeW * 0.5;
    self.center = center;
}

@end
