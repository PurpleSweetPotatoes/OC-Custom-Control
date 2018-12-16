//
//  UITableView+Custom.m
//  Test-demo
//
//  Created by baiqiang on 2018/1/27.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "UITableView+Custom.h"
#import <objc/runtime.h>

static const NSString * EmptyViewDelegate;
static const NSUInteger EmptyTag = 'VIEW';

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

- (UITableViewCell *)loadTemplateCellForIdentifier:(NSString *)identifier {
    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithIdentifier:identifier];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCellsByIdentifiers[identifier] = templateCell;
    }
    
    return templateCell;
}

- (CGFloat)fetchCellHeight:(Class)cellClass configBlock:(void (^)(id _Nonnull))configBlock {
    UITableViewCell * cell = [self loadTemplateCellForIdentifier:NSStringFromClass(cellClass)];
    if (configBlock) {
        configBlock(cell);
    }
    CGFloat fittingHeight = 0;
    
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed values.
    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }
    
    NSLayoutConstraint * widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    
    // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
    static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
    });
    
    NSArray<NSLayoutConstraint *> *edgeConstraints;
    if (isSystemVersionEqualOrGreaterThen10_2) {
        // To avoid confilicts, make width constraint softer than required (1000)
        widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
        
        // Build edge constraints
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
        [cell addConstraints:edgeConstraints];
    }
    
    [cell.contentView addConstraint:widthFenceConstraint];
    
    // Auto layout engine does its math
    fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Clean-ups
    [cell.contentView removeConstraint:widthFenceConstraint];
    if (isSystemVersionEqualOrGreaterThen10_2) {
        [cell removeConstraints:edgeConstraints];
    }
    
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return  MAX(cell.bounds.size.height, fittingHeight);
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

- (void)setEmptyViewDelegate:(id<EmptyViewProtocol>)delegate {
    objc_setAssociatedObject(self, &EmptyViewDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method origin = class_getInstanceMethod(self.class, @selector(layoutSubviews));
        Method intercept = class_getInstanceMethod(self.class, @selector(bq_layoutSubviews));
        method_exchangeImplementations(origin, intercept);
    });
}

- (void)bq_layoutSubviews {
    [self bq_layoutSubviews];
    
    id<EmptyViewProtocol> delegate = objc_getAssociatedObject(self, &EmptyViewDelegate);
    
    UIView * emptyView = [self viewWithTag:EmptyTag];
    [emptyView removeFromSuperview];
    
    if (delegate && [delegate showEmptyView:self]) {
        UIView * backView = [delegate configEmptyView:self];
        NSAssert([backView isKindOfClass:[UIView class]], @"configEmptyView should return a view which kind of UIView");
        backView.tag = EmptyTag;
        [self addSubview:backView];
    }
}

@end
