//
//  UIImageView+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIImageView+Custom.h"

@interface BQShowImageView : UIView
/**  图片视图 */
@property (nonatomic, strong) UIImageView *imageView;
/**  背景视图 */
@property (nonatomic, strong) UIView *backView;
/**  原图片位置 */
@property (nonatomic, assign) CGRect orgiFrame;

+ (void)showImage:(UIImage *)image frame:(CGRect)frame;

@end;

@implementation UIImageView (Show)

- (void)canShowImage {
    
    for (UIGestureRecognizer * sender in self.gestureRecognizers) {
        [self removeGestureRecognizer:sender];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageView:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)setGifImgWithName:(NSString *)name {
    [self setGifImgWithName:name inBundle:[NSBundle mainBundle]];
}

- (void)setGifImgWithName:(NSString *)name inBundle:(NSBundle *)bundle {
    NSData * data = nil;
    NSString * originPath = [bundle pathForResource:name ofType:@"gif"];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale > 1.0f) {
        NSString * retinaPath = [bundle pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:retinaPath];
    }
    
    if (!data) {
        data = [NSData dataWithContentsOfFile:originPath];
    }
    
    if (!data) return;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage * animatedImage = nil;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self.class frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    self.image = animatedImage;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

- (void)showImageView:(UITapGestureRecognizer *)tap {
    
    if (!self.image) {
        NSLog(@"no have Image at here!");
        return;
    }
    
    CGRect imageViewFrame = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    [BQShowImageView showImage:self.image frame:imageViewFrame];
}
@end

#pragma mark ---- 展示UIImageView视图

@implementation BQShowImageView

+ (void)showImage:(UIImage *)image
            frame:(CGRect)frame {
    BQShowImageView * showImageView = [[BQShowImageView alloc] initWithOrignframe:frame];
    showImageView.imageView.image = image;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:showImageView];
    [showImageView beginAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //重载方法 防止点击事件传递
}

- (id)initWithOrignframe:(CGRect)frame{
    self = [super init];
    if (self != nil) {
        self.orgiFrame = frame;
        self.frame = [UIScreen mainScreen].bounds;
        [self initUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 实例方法
- (void)initUI{
    
    self.backView = [[UIView alloc] initWithFrame:self.bounds];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self addSubview:self.backView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = self.orgiFrame;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerChange:)];
    [imageView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerChange:)];
    [imageView addGestureRecognizer:pinch];
    self.imageView = imageView;
    [self addSubview:imageView];
}

- (void)beginAnimation {
    self.backView.alpha = 0;
    CGFloat toWidth = self.bounds.size.width - 10;
    CGFloat toHeight = self.imageView.bounds.size.height * toWidth / self.imageView.bounds.size.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 1;
        self.imageView.bounds = CGRectMake(0, 0, toWidth, toHeight);
        self.imageView.center = self.center;
        
    }];
}

#pragma mark - 事件响应方法
- (void)gestureRecognizerChange:(UIGestureRecognizer*)gesture {
    // 拖拽
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
        static CGPoint startCenter;
        if (pan.state == UIGestureRecognizerStateBegan) {
            startCenter = self.imageView.center;
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            // 此处必须从self.view中获取translation，因为translation和view的transform属性挂钩，若transform改变了则translation也会变
            CGPoint translation = [pan translationInView:self];
            self.imageView.center = CGPointMake(startCenter.x + translation.x, startCenter.y + translation.y);
        } else if (pan.state == UIGestureRecognizerStateEnded) {
            startCenter = CGPointZero;
        }
    } else {// 缩放
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gesture;
        static CGFloat startScale;
        if (pinch.state == UIGestureRecognizerStateBegan) {
            startScale = pinch.scale;
        } else if (pinch.state == UIGestureRecognizerStateChanged) {
            CGFloat scale = (pinch.scale - startScale) +1;
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
            startScale = pinch.scale;
        } else if (pinch.state == UIGestureRecognizerStateEnded) {
            startScale = 1;
        }
    }
}

- (void)removeSelf {
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.frame = self.orgiFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
