//
//  BQNumLabel.m
//  Test
//
//  Created by MrBai on 2017/6/29.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQNumLabel.h"
#import "UILabel+adjust.h"
#import "BQScreenAdaptation.h"

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

#pragma mark - public Method

#pragma mark - private Method

- (void)initUI {
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor redColor];
    self.textColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
}
#pragma mark - LoadNetWrokData

#pragma mark - response event

#pragma mark - Delegate Method

#pragma mark - View Create

#pragma mark - set Method
- (void)setText:(NSString *)text {
    [super setText:text];
    CGPoint center = self.center;
    [self adjustWidthForFont];
    NSInteger width = self.width + 8;
    self.width = width % 2 == 0 ? width : width + 1;
    self.height = self.width;
    self.layer.cornerRadius = self.width * 0.5;
    self.center = center;
}
#pragma mark - get Method

@end
