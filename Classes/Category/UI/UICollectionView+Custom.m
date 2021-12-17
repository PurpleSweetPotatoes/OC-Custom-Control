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

- (void)registerHeaderFooterView:(Class)aClass  isNib:(BOOL)isNib {
    NSString * identifier = NSStringFromClass(aClass);
    
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:identifier withReuseIdentifier:identifier];
    } else {
        [self registerClass:aClass forSupplementaryViewOfKind:identifier withReuseIdentifier:identifier];
    }
    
}

@end

@implementation UICollectionViewCell (Custom)

+ (instancetype)loadFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = NSStringFromClass(self);
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

@end

@implementation UICollectionReusableView (Custom)

+ (instancetype)loadHeaderFooterView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = NSStringFromClass(self);
    UICollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:identifier withReuseIdentifier:identifier forIndexPath:indexPath];
    return reusableView;
}

@end


