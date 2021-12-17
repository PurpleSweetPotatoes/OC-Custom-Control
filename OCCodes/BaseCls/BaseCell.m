// *******************************************
//  File Name:      BaseCell.m       
//  Author:         MrBai
//  Created Date:   2021/12/17 11:50 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BaseCell.h"

@interface BaseCell ()

@end

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configUI];
}

- (void)configUI {}

- (void)configInfo:(id)model {}

@end
