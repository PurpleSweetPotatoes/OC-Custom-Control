//
//  BQPageControl.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQPageControl.h"

@implementation BQPageControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.spacing = 8;
        self.normalSize = 7;
        self.selectedSize = 7;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i< self.subviews.count; i++) {
        UIView * view = self.subviews[i];
        if (i == self.currentPage) {
            view.frame = CGRectMake((self.spacing + self.normalSize) * i , (self.bounds.size.height - self.selectedSize) * 0.5, self.selectedSize, self.selectedSize);
        }else {
            view.frame = CGRectMake((self.spacing + self.normalSize) * i , (self.bounds.size.height - self.normalSize) * 0.5, self.normalSize, self.normalSize);
        }
        view.layer.cornerRadius = view.bounds.size.width * 0.5;
        view.layer.masksToBounds = YES;
    }
}
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    CGSize size = [super sizeForNumberOfPages:pageCount];
    return size;
}

@end
