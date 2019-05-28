//
//  BaseTableViewCell.m
//  tianyaTest
//
//  Created by baiqiang on 2019/5/24.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@end

@implementation BaseTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.lineLayer && !self.lineLayer.hidden) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        CGRect frame = self.lineLayer.frame;
        frame.origin.y = self.bounds.size.height - 1;
        self.lineLayer.frame = frame;
        [CATransaction commit];
    }
    
}


- (CALayer *)lineLayer {
    if (_lineLayer == nil) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        lineLayer.backgroundColor = [UIColor colorWithRed:201 / 255.0 green:201 / 255.0 blue:201 / 255.0 alpha:1].CGColor;
        _lineLayer = lineLayer;
    }
    return _lineLayer;
}

@end
