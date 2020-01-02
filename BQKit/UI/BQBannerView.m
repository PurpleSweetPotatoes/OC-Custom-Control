//
//  BQ12View.m
//  Test
//
//  Created by MAC on 16/12/19.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import "BQBannerView.h"
#import "UIAlertController+Custom.h"
#import "BQTimer.h"

@interface BQBannerView ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView * contentView;

@property (nonatomic, strong) NSArray<UIImageView *> * imgVArr;
@property (nonatomic, assign) NSInteger  count;
@property (nonatomic, assign) NSInteger  currentIndex;
@property (nonatomic, strong) BQTimer * timer;
@end

@implementation BQBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self reloadData];
}

- (void)initData {
    self.count = 0;
    self.times = 2;
}

- (void)initUI {
    self.contentView = [self configScrollViewWithFrame:self.bounds];
    NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; ++i) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.contentView.bounds.size.width, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        [self.contentView addSubview:imageView];
        [imgArr addObject:imageView];
    }
    self.imgVArr = imgArr;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0 , 60, 20)];
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - self.pageControl.bounds.size.height * 0.8);
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    [self addGestureRecognizer:tap];
}

- (UIScrollView * )configScrollViewWithFrame:(CGRect)frame {
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 3, scrollView.bounds.size.height);
    scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    return scrollView;
}

- (void)reloadData {
    self.count = [self.delegate numOfImgsInBannerView:self];
    self.pageControl.numberOfPages = self.count;
    self.pageControl.hidden = self.count <= 1;
    self.currentIndex = 0;
    self.contentView.userInteractionEnabled = self.count > 1;
    [self imageChage];
    if (self.count > 1) {
        [self.timer start];
    }
}

#pragma mark - Private Method

- (void)imageChage {
    for (NSInteger i = -1; i < 2; ++ i) {
        NSInteger index = (self.currentIndex + i + self.count) % self.count;
        [self.delegate bannerView:self configImgV:self.imgVArr[i+1] index:index];
    }
    [self.contentView setContentOffset:CGPointMake(self.contentView.bounds.size.width, 0) animated:NO];
}

- (void)tapGestureEvent {
    if ([self.delegate respondsToSelector:@selector(bannerView:clickIndex:)]) {
        [self.delegate bannerView:self clickIndex:self.currentIndex];
    }
}

#pragma mark - Timer

- (void)timeValueChange:(BQTimer *)timer {
    NSInteger index = self.currentIndex + 1;
    self.currentIndex = index;
    [self.contentView setContentOffset:CGPointMake(self.contentView.bounds.size.width * 2, 0) animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(bannerView:scorllToIndex:)]) {
        [self.delegate bannerView:self scorllToIndex:self.currentIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pause];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.timer start];
    if (scrollView.contentOffset.x != self.bounds.size.width) {
        NSInteger index = scrollView.contentOffset.x > self.bounds.size.width ? 1 : -1;
        self.currentIndex = self.currentIndex + index + self.count;
        [self imageChage];
        if ([self.delegate respondsToSelector:@selector(bannerView:scorllToIndex:)]) {
            [self.delegate bannerView:self scorllToIndex:self.currentIndex];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self imageChage];
}

#pragma mark - Set

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex % self.count;
    self.pageControl.currentPage = _currentIndex;
}

- (void)setTimes:(NSTimeInterval)times {
    if (self.timer) {
        [self.timer clear];
    }
    
    self.timer = [BQTimer configWithScheduleTime:times target:self selector:@selector(timeValueChange:)];

    if (self.count > 1) {
        [self.timer start];
    }
}

@end
