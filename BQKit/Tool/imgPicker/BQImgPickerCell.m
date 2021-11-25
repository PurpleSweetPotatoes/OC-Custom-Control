//
//  BQImgPickerCell.m
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQImgPickerCell.h"
#import "PHAsset+Picker.h"
#import <Photos/PHImageManager.h>

@interface BQImgPickerCell()
@property (nonatomic, strong) UIImageView           * imageView;
@property (nonatomic, assign) CGFloat               targetWidth;///<  获取的宽度
@property (nonatomic, strong) PHImageRequestOptions * options;
@property (nonatomic, strong) UIButton              * selectBtn;
@end

@implementation BQImgPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = self.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    CGFloat imgBtnWidth = 26;
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(self.bounds.size.width - 30, 5, imgBtnWidth, imgBtnWidth);
    [selectBtn addTarget:self action:@selector(pickCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];
    
    
    // btn图像画图
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgBtnWidth, imgBtnWidth), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextAddArc(context, imgBtnWidth * 0.5, imgBtnWidth * 0.5, imgBtnWidth * 0.5 - 1, 0, 2 * M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.7].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.3].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage * normalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextClearRect(context, CGRectMake(0, 0, imgBtnWidth, imgBtnWidth));
    CGContextAddArc(context, imgBtnWidth * 0.5, imgBtnWidth * 0.5, imgBtnWidth * 0.5 - 1, 0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0x30/255.0 green:0x8e/255.0 blue:0xe3/255.0 alpha:1].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextMoveToPoint(context, 6, 13);
    CGContextAddLineToPoint(context, 12, 19);
    CGContextAddLineToPoint(context, 20, 8);
    CGContextStrokePath(context);
    UIImage * selectImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [selectBtn setImage:normalImg forState:UIControlStateNormal];
    [selectBtn setImage:selectImg forState:UIControlStateSelected];
    self.selectBtn = selectBtn;
    self.options = [[PHImageRequestOptions alloc] init];
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    self.targetWidth = self.imageView.bounds.size.width * [UIScreen mainScreen].scale;
}


- (void)pickCellBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imgPiackCellBtnActionWithAsset:)] && [self.delegate imgPiackCellBtnActionWithAsset:self.assetModel]) {
        sender.selected = !sender.selected;
        self.assetModel.selected = sender.selected;
    }
}

- (void)setAssetModel:(PHAsset *)assetModel {
    _assetModel = assetModel;
    
    self.imageView.image = nil;
    
    self.selectBtn.selected = assetModel.selected;
    
    if (self.assetModel.image) {
        self.imageView.image = self.assetModel.image;
    } else {
        [[PHImageManager defaultManager] requestImageForAsset:assetModel targetSize:CGSizeMake(self.targetWidth, self.targetWidth) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageView.image = result;
        }];
    }
    
}

@end
