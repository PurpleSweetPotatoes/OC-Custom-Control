// *******************************************
//  File Name:      BQPhotoView.m
//  Author:         MrBai
//  Created Date:   2020/3/4 10:21 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQPhotoView.h"

@interface BQPhotoView ()
<
UIScrollViewDelegate
>
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIScrollView * scrV;
@end

@implementation BQPhotoView


#pragma mark - *** Public method

+ (void)show:(UIImage *)img {
    BQPhotoView * view = [[BQPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [view setImage:img];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)setImage:(UIImage *)img {
    [self resetNormal];
    self.imgV.image = img;
    CGSize imgSize = img.size;
    CGFloat height = imgSize.height * self.bounds.size.width / imgSize.width;
    CGRect frame = CGRectMake(0, (self.bounds.size.height - height) * 0.5, self.bounds.size.width, height);
    self.imgV.frame = frame;
}

- (void)resetNormal {
    if (self.scrV.zoomScale > self.scrV.minimumZoomScale) {
        [self.scrV setZoomScale:self.scrV.minimumZoomScale animated:NO];
    }
}
#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)singTapAction:(UITapGestureRecognizer *)sender {
    [self.scrV setZoomScale:self.scrV.minimumZoomScale animated:NO];
    if ([self.delegate respondsToSelector:@selector(photoTapAction)]) {
        [self.delegate photoTapAction];
    } else {
        [self removeFromSuperview];
    }
    
}

- (void)doubleTapAction:(UITapGestureRecognizer *)sender {
    if (self.imgV.image) {
        if (self.scrV.zoomScale <= self.scrV.minimumZoomScale) {
            CGPoint location = [sender locationInView:self.imgV];
            CGFloat width = self.imgV.bounds.size.width / self.scrV.maximumZoomScale;
            CGFloat height = self.imgV.bounds.size.height / self.scrV.maximumZoomScale;
            CGRect rect = CGRectMake(location.x - width * 0.5, location.y - height * 0.5, width, height);
            [self.scrV zoomToRect:rect animated:YES];
        } else {
            [self.scrV setZoomScale:self.scrV.minimumZoomScale animated:YES];
        }
    }
}
#pragma mark - *** Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)*0.5 : 0.0;
    
    self.imgV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self addSubview:self.bgView];
    [self addSubview:self.scrV];
    [self.scrV addSubview:self.imgV];
    
    UITapGestureRecognizer * singTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singTapAction:)];
    [self addGestureRecognizer:singTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    
    [singTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
}

#pragma mark - *** Set

#pragma mark - *** Get
    
- (UIView *)bgView {
    if (_bgView == nil) {
        UIView * bgV = [[UIView alloc] initWithFrame:self.bounds];
        bgV.backgroundColor = [UIColor blackColor];
        _bgView = bgV;
    }
    return _bgView;
}

- (UIScrollView *)scrV {
    if (_scrV == nil) {
        UIScrollView * scrV = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrV.showsVerticalScrollIndicator = NO;
        scrV.showsHorizontalScrollIndicator = NO;
        scrV.clipsToBounds = YES;
        scrV.maximumZoomScale = 2.0;
        scrV.minimumZoomScale = 1.0;
        scrV.delegate = self;
        _scrV = scrV;
    }
    return _scrV;
}

- (UIImageView *)imgV {
    if (_imgV == nil) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV = imgV;
    }
    return _imgV;
}
@end
