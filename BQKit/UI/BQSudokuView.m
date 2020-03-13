//
//  BQSudokuView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/4/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQSudokuView.h"



@interface BQSudokuView ()
@property (nonatomic, strong) NSArray * imgVArr;
@property (nonatomic, assign) CGFloat  itemHeight;
@property (nonatomic, assign) CGFloat  itemSpace;
@end

@implementation BQSudokuView



- (instancetype)initWithOrigin:(CGPoint)origin
                    itemHeight:(CGFloat)height
                     itemSpace:(CGFloat)itemSpace {
    CGRect frame = CGRectMake(origin.x, origin.y, itemSpace * 2 + height * 3, itemSpace * 2 + height * 3);
    self = [super initWithFrame:frame];
    if (self) {
        self.itemHeight = height;
        self.itemSpace = itemSpace;
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithOrigin:frame.origin itemHeight:60 itemSpace:10];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithOrigin:CGPointZero itemHeight:60 itemSpace:10];
}

- (void)setUpUI {
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:9];
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i % 3) * (self.itemHeight + self.itemSpace), i / 3 * (self.itemHeight + self.itemSpace), self.itemHeight, self.itemHeight)];
        imgView.tag = i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVtapAction:)];
        [imgView addGestureRecognizer:tap];
        [self addSubview:imgView];
        [arr addObject:imgView];
    }
    self.imgVArr = [arr copy];
}

- (void)reloadData {
    UIView * disView = nil;
    NSInteger count = [self.delegate numOfImgsInSudokuView:self];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView * imgV = self.imgVArr[i];
        imgV.hidden = i >= count;
        if (!imgV.hidden) {
            [self.delegate sudokuView:self configImgV:imgV index:i];
            disView = imgV;
        }
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.itemSpace * 2 + self.itemHeight * 3, CGRectGetMaxY(disView.frame));
}

- (void)imgVtapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(sudokuView:clickIndex:)]) {
        [self.delegate sudokuView:self clickIndex:sender.view.tag];
    }
}

- (void)setDelegate:(id<BQSudokuViewDelegate>)delegate {
    _delegate = delegate;
    if (delegate) {
        [self reloadData];
    }
}
@end
