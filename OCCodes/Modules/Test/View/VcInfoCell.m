// *******************************************
//  File Name:      VcInfoCell.m       
//  Author:         MrBai
//  Created Date:   2021/12/17 11:43 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "VcInfoCell.h"

#import "VcModel.h"

@interface VcInfoCell ()
@property (nonatomic, strong) UILabel * contentLab;
@property (nonatomic, strong) UILabel * descLab;
@end

@implementation VcInfoCell

- (void)configUI {
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.descLab];
}

- (void)configInfo:(VcModel *)model {
    self.contentLab.text = model.titleName;
    self.descLab.text = model.descStr;
}
#pragma mark - *** get

- (UILabel *)contentLab {
    if (_contentLab == nil) {
        UILabel * contentLab = [UILabel labWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 15, 44) title:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
        _contentLab = contentLab;
    }
    return _contentLab;
}

- (UILabel *)descLab {
    if (_descLab == nil) {
        UILabel * descLab = [UILabel labWithFrame:CGRectMake(CGRectGetMaxX(self.contentLab.frame), 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 15, 44) title:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor hex:0x999999]];
        descLab.textAlignment = NSTextAlignmentRight;
        _descLab = descLab;
    }
    return _descLab;
}

@end
