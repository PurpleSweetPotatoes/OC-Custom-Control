// *******************************************
//  File Name:      CollectionImgCell.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 11:57 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CollectionImgCell.h"

@interface CollectionImgCell()
@property (nonatomic, strong) UIImageView * imgV;
@end

@implementation CollectionImgCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgV.frame = self.contentView.bounds;
}

- (void)configInfo:(ImgModel *)model {
    [self.imgV setImage:[UIImage imageNamed:model.imgName]];
}

- (void)configUI {
    [self.contentView addSubview:self.imgV];
}

- (UIImageView *)imgV {
    if (_imgV == nil) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgV.backgroundColor = [UIColor blackColor];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV = imgV;
    }
    return _imgV;
}

@end
