//
//  BQAlertVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/5/7.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQAlertVc.h"

#import "BQDefineHead.h"
#import "CALayer+Custom.h"
#import "UIColor+Custom.h"
#import "UIImage+Custom.h"
#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@interface BQAlertVc ()
@property (nonatomic, strong) UIView                     * disPlayerView;
@property (nonatomic, strong) UIImageView                * blurImgV;
@property (nonatomic, strong) NSString                   * alertTitle;
@property (nonatomic, strong) NSString                   * content;
@property (nonatomic, strong) UIView                     * customView;
@property (nonatomic, strong) NSMutableDictionary        * blockDic;
@property (nonatomic, strong) NSMutableArray<UIButton *> * btnArr;
@end

@implementation BQAlertVc

+ (instancetype)configAlertVcWithTile:(NSString *)title content:(NSString *)content {
    BQAlertVc * alertVc = [[BQAlertVc alloc] init];
    alertVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alertVc.alertTitle = title;
    alertVc.content = content;
    return alertVc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.btnArr = [NSMutableArray arrayWithCapacity:2];
        self.blockDic = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage * img = [[UIApplication sharedApplication].keyWindow convertToImage];
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    imgV.image = [img blurImageWithRadius:2];
    [self.view insertSubview:imgV atIndex:0];
    self.blurImgV = imgV;
    
    UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIColor * color = [UIColor hexstr:@"282520"];
    backView.backgroundColor = [color colorWithAlphaComponent:0.6];
    [self.blurImgV addSubview:backView];
    
    [self setUpUI];
}

- (void)setUpUI {
    
    [self.view addSubview:self.disPlayerView];
    
    CGFloat bottomHeight = 0;
    if (self.customView) {
        [self.disPlayerView addSubview:self.customView];
        bottomHeight = self.customView.bottom;
    } else {
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.disPlayerView.width - 20, 20)];
        titleLab.text = self.alertTitle;
        titleLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        titleLab.numberOfLines = 0;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor hexstr:@"282520"];
        [titleLab heightToFit];
        titleLab.center = CGPointMake(self.disPlayerView.width * 0.5, 25 + titleLab.height * 0.5);
        [self.disPlayerView addSubview:titleLab];
        
        UILabel * contentLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, self.disPlayerView.width - 60, 20)];
        contentLab.text = self.content;
        contentLab.numberOfLines = 0;
        contentLab.font = [UIFont systemFontOfSize:13];
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.textColor = [UIColor hexstr:@"282520"];
        [contentLab heightToFit];
        contentLab.center = CGPointMake(self.disPlayerView.width * 0.5, titleLab.bottom + 15 + contentLab.height * 0.5);
        [self.disPlayerView addSubview:contentLab];
        bottomHeight = contentLab.bottom + 20;
    }
    
    CGFloat btnWidth = self.disPlayerView.width;
    if (self.btnArr.count == 0) {
        [self addBtnWithTitle:@"OK" type:AlertBtnTypeNormal handle:nil];
    } else if (self.btnArr.count == 2) {
        CALayer * lineLayer = [CALayer cellLineLayerWithFrame:CGRectMake(self.disPlayerView.width * 0.5 - 0.5, bottomHeight, 1, 45)];
        [self.disPlayerView.layer addSublayer:lineLayer];
        btnWidth = self.disPlayerView.width * 0.5;
    }
    
    CALayer * lineLayer = [CALayer cellLineLayerWithFrame:CGRectMake(0, bottomHeight, self.disPlayerView.width, 1)];
    [self.disPlayerView.layer addSublayer:lineLayer];
    
    for (NSInteger i = 0; i < self.btnArr.count; i++) {
        self.btnArr[i].frame = CGRectMake(i * btnWidth, bottomHeight, btnWidth, 45);
        [self.disPlayerView addSubview:self.btnArr[i]];
    }
    self.disPlayerView.height = self.btnArr[0].bottom;
    self.disPlayerView.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5);
    
}

- (void)addCustomView:(UIView *)customView {
    self.customView = customView;
}

- (void)addBtnWithTitle:(NSString *)title type:(AlertBtnType)type handle:(_Nullable VoidAlertBlock)handle {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor hexstr:type == 0 ? @"1a237e":@"8e0000"] forState:UIControlStateNormal];
    [self.btnArr addObject:btn];
    
    if (handle) {
        self.blockDic[title] = handle;
    }
}

- (void)showVc {
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    [vc presentViewController:self animated:NO completion:^{
        [self animationShow];
    }];
}

- (void)alertBtnAction:(UIButton *)sender {
    if (self.blockDic[sender.currentTitle]) {
        VoidAlertBlock block = self.blockDic[sender.currentTitle];
        block();
    }
    [self animationHide];
}

- (void)animationShow {
    self.blurImgV.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.disPlayerView.alpha = 1;
        self.blurImgV.alpha = 1;
    }];
}

- (void)animationHide {
    [UIView animateWithDuration:0.25 animations:^{
        self.disPlayerView.alpha = 0;
        self.blurImgV.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (UIView *)disPlayerView {
    if (_disPlayerView == nil) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
        view.backgroundColor = [UIColor hexstr:@"fcfcfc"];
        view.layer.cornerRadius = 16;
        view.alpha = 0;
        _disPlayerView = view;
    }
    return _disPlayerView;
}
@end
