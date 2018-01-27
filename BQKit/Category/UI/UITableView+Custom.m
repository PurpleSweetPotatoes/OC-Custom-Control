//
//  UITableView+Custom.m
//  Test-demo
//
//  Created by baiqiang on 2018/1/27.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "UITableView+Custom.h"

@implementation UITableView (Custom)

- (void)registerCell:(Class)cellClass isNib:(BOOL)isNib {
    
    NSString * identifier = NSStringFromClass(cellClass);
    
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
        
    }
    
}

- (UITableViewCell *)loadCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = NSStringFromClass(cellClass);
    
    return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)registerHeaderFooterView:(Class)aClass isNib:(BOOL)isNib {
    
    NSString * identifier = NSStringFromClass(aClass);
    
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
    } else {
        [self registerClass:aClass forHeaderFooterViewReuseIdentifier:identifier];
    }
}

- (UITableViewHeaderFooterView *)loadHeaderFooterView:(Class)aClass {
    
    NSString * identifier = NSStringFromClass(aClass);
    return [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

@end
