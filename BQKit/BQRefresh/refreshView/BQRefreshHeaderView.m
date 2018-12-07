//
//  BQRefreshHeaderView.m
//  TianyaTest
//
//  Created by MrBai on 2017/8/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRefreshHeaderView.h"
#import "NSBundle+Refresh.h"
#import "UIImageView+Custom.h"

@interface BQRefreshHeaderView()
@property (nonatomic, strong) UIImageView * pullImgView;
@property (nonatomic, strong) UIImageView * gifsView;

@property (nonatomic, copy) NSString * pullStr;
@property (nonatomic, copy) NSString * willRefreshStr;
@property (nonatomic, copy) NSString * refreshStr;
@end

@implementation BQRefreshHeaderView

static NSString * const keyIdle = @"BQRefreshHeaderIdleText";
static NSString * const keyWill = @"BQRefreshHeaderPullingText";
static NSString * const keyRefresh = @"BQRefreshHeaderRefreshingText";

#pragma mark - Create Method
+ (instancetype)headerWithBlock:(CallBlock)block {
    //头部刷新视图高度
    CGFloat height = 90;
    BQRefreshHeaderView * headerView = [[self alloc] initWithFrame:CGRectMake(0, -height, 0, height)];
    headerView.block = block;
    return headerView;
}

+ (instancetype)headerWithPullStr:(NSString *)pullStr
                   willRefreshStr:(NSString *)willRefreshStr
                       refreshStr:(NSString *)refreshStr
                            Block:(CallBlock)block {
    BQRefreshHeaderView * headerView = [self headerWithBlock:block];
    headerView.pullStr = pullStr;
    headerView.willRefreshStr = willRefreshStr;
    headerView.refreshStr = refreshStr;
    return headerView;
}

#pragma mark - Instance Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.gifsView];
    [self addSubview:self.pullImgView];
    [self addSubview:self.statuLab];
    
    self.gifsView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gifsView.center = CGPointMake(self.bounds.size.width * 0.5, 32);
    self.pullImgView.center = self.gifsView.center;
    self.statuLab.frame = CGRectMake(0, 60, self.bounds.size.width, 15);
}

#pragma mark - KVO Method 
- (void)contentOffsetDidChange {
    
    if (self.statu == RefreshStatuType_Refreshing) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        switch (self.statu) {
            case RefreshStatuType_Pull:
            {
                if (self.pullStr) {
                    self.statuLab.text = self.pullStr;
                } else {
                    self.statuLab.text = [NSBundle refreshStringKey:keyIdle];
                }
                
                if ((self.origiOffsetY - self.scrollView.contentOffset.y) > self.bounds.size.height) {
                    self.statu = RefreshStatuType_willRefresh;
                }
            }
                break;
            case RefreshStatuType_willRefresh:
            {
                
                if (self.willRefreshStr) {
                    self.statuLab.text = self.willRefreshStr;
                } else {
                    self.statuLab.text = [NSBundle refreshStringKey:keyWill];
                }
                
                if ((self.origiOffsetY - self.scrollView.contentOffset.y) <= self.bounds.size.height){
                    self.statu = RefreshStatuType_Pull;
                }
            }
                break;
            default:
                break;
        }
        
    } else {
        if (self.statu == RefreshStatuType_willRefresh) {
            self.statu = RefreshStatuType_Refreshing;
            if (self.block) {
                self.block();
            }
        }
    }
}

#pragma mark - Refresh Method
- (void)beginAnimation {
    
    if (self.statu != RefreshStatuType_Refreshing) {
        self.statu = RefreshStatuType_Refreshing;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(self.bounds.size.height, 0, 0, 0);
    }];
    
    if (self.refreshStr) {
        self.statuLab.text = self.refreshStr;
    } else {
        self.statuLab.text = [NSBundle refreshStringKey:keyRefresh];
    }
    
    [self changeHiddenStatus];
}

- (void)endRefresh {
    self.statu = RefreshStatuType_Pull;
    [self changeHiddenStatus];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

- (void)changeHiddenStatus {
    self.gifsView.hidden = !self.gifsView.isHidden;
    self.pullImgView.hidden = !self.pullImgView.isHidden;
}

#pragma mark - get Method
- (UIImageView *)pullImgView {
    if (_pullImgView == nil) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [imgView setImage:[NSBundle animatedFirstImg]];
        _pullImgView = imgView;
    }
    return _pullImgView;
}

- (UIImageView *)gifsView {
    if (_gifsView == nil) {
        UIImageView * gifImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [gifImgView setGifImgWithName:@"earth_loading" inBundle:[NSBundle refreshBunlde]];
        
        _gifsView = gifImgView;
    }
    return _gifsView;
}
@end
