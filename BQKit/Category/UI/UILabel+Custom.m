//
//  UILabel+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@implementation UILabel (adjust)

- (CGFloat)heightToFit {
    
    if (self.text.length > 0) {
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
        self.sizeH = rect.size.height;
    }
    
    return  self.sizeH;
}

- (CGFloat)widthToFit {
    if (self.text.length > 0) {
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
        self.sizeW = rect.size.width;
    }
    
    return  self.sizeW;
}
@end
