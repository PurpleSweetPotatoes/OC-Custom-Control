//
//  UICollectionView+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UICollectionView+Custom.h"

@implementation UICollectionView (Custom)
- (void)registerCell:(Class)cellClass isNib:(BOOL)isNib {
    
    NSString * identifier = NSStringFromClass(cellClass);
    
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    } else {
        [self registerClass:cellClass forCellWithReuseIdentifier:identifier];
    }
    
}

- (UICollectionViewCell *)loadCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = NSStringFromClass(cellClass);
    
    return [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)registerHeaderFooterView:(Class)aClass  isNib:(BOOL)isNib {
    NSString * identifier = NSStringFromClass(aClass);
    
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:identifier withReuseIdentifier:identifier];
    } else {
        [self registerClass:aClass forSupplementaryViewOfKind:identifier withReuseIdentifier:identifier];
    }
    
}

- (UICollectionReusableView *)loadHeaderFooterView:(Class)aClass indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = NSStringFromClass(aClass);
    UICollectionReusableView * reusableView = [self dequeueReusableSupplementaryViewOfKind:identifier withReuseIdentifier:identifier forIndexPath:indexPath];
    return reusableView;
}

@end
