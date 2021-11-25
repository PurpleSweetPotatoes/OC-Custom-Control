// *******************************************
//  File Name:      BQKeyBoardManager.m
//  Author:         MrBai
//  Created Date:   2020/5/13 12:28 PM
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQKeyBoardManager.h"

#import "BQDefineHead.h"
#import "UIColor+Custom.h"
#import "UIImage+Custom.h"
#import "UILabel+Custom.h"

@interface BQKeyBoardManager ()
@property (nonatomic, strong) UIView                    * responseV;
@property (nonatomic, strong) NSMutableArray<UIView *>  * editVList;
@property (nonatomic, strong) UIView                    * currentEditV;
@property (nonatomic, assign) BOOL                      didAdd;
@end

@interface BQKeyBoardToolBar : UIView
@property (nonatomic, strong) UIButton     * preBtn;
@property (nonatomic, strong) UIButton     * nextBtn;
@property (nonatomic, strong) UILabel      * tipLab;
@property (nonatomic, strong) UIButton     * dissBtn;
+ (instancetype)toolBar;
@end

@implementation BQKeyBoardManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static BQKeyBoardManager * manager;
    dispatch_once(&onceToken, ^{
        manager = [[BQKeyBoardManager alloc] init];
        manager.editVList = [NSMutableArray array];
    });
    return manager;
}

+ (void)startResponseView:(UIView *)reView {
    BQKeyBoardManager * manager =  [self share];
    manager.responseV = reView;
}

+ (void)closeResponse {
    BQKeyBoardManager * manager =  [self share];
    manager.responseV = nil;
}

#pragma mark - Event

- (void)preBtnAction:(UIButton *)btn {
    NSInteger index = [self.editVList indexOfObject:self.currentEditV];
    UIView * preV = self.editVList[index - 1];
    [preV becomeFirstResponder];
}

- (void)nextBtnAction:(UIButton *)btn {
    NSInteger index = [self.editVList indexOfObject:self.currentEditV];
    UIView * nextV = self.editVList[index + 1];
    [nextV becomeFirstResponder];
}

- (void)dissBtnAction:(UIButton *)btn {
    [self.currentEditV resignFirstResponder];
}

#pragma mark - Instacell

- (void)checkCanResponseCtlr:(UIView *)view {
    if (([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) && view.userInteractionEnabled) {
        [self.editVList addObject:view];
    } else {
        for (UIView * subV in view.subviews) {
            [self checkCanResponseCtlr:subV];
        }
    }
}

#pragma mark - Notification & KeyBoardHandle

- (void)addNotifiCation {
    [self.editVList removeAllObjects];
    [self checkCanResponseCtlr:self.responseV];
    for (NSInteger i = 0; i < self.editVList.count; i++) {
        UITextField * tf = (UITextField *)self.editVList[i];
        if (tf.inputAccessoryView == nil) {
            BQKeyBoardToolBar * toolBar = [BQKeyBoardToolBar toolBar];
            [toolBar.preBtn addTarget:self action:@selector(preBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [toolBar.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [toolBar.dissBtn addTarget:self action:@selector(dissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                toolBar.preBtn.selected = YES;
                toolBar.preBtn.userInteractionEnabled = NO;
            }
            if (i == self.editVList.count - 1) {
                toolBar.nextBtn.selected = YES;
                toolBar.nextBtn.userInteractionEnabled = NO;
            }
            
            tf.inputAccessoryView = toolBar;
        }
    }
    
    if (!self.didAdd) {
        self.didAdd = YES;
        //增加监听，当键盘弹出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键盘修改时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        //增加监听，当键盘退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeNotifiCation {
    if (self.didAdd) {
        self.didAdd = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    for (UIView * editV in self.editVList) {
        if (editV.isFirstResponder) {
            self.currentEditV = editV;
            if ([editV.inputAccessoryView isKindOfClass:[BQKeyBoardToolBar class]] && [editV isKindOfClass:[UITextField class]]) {
                UITextField * tf = (UITextField *)editV;
                BQKeyBoardToolBar * bar = (BQKeyBoardToolBar *)tf.inputAccessoryView;
                bar.tipLab.text = tf.placeholder;
            }
            //回归原视图，这样不影响获取正确的视图最低点
            self.responseV.transform = CGAffineTransformIdentity;
            //获取键盘的y值
            NSDictionary *userInfo = [notifi userInfo];
            NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardRect = [aValue CGRectValue];
            NSInteger height = keyboardRect.size.height;
            CGFloat keyBoardY = [UIScreen mainScreen].bounds.size.height - height;
            
            //响应视图的最低点
            CGRect rect = [editV.superview convertRect:editV.frame toView:[UIApplication sharedApplication].keyWindow];
            CGFloat vMaxY = CGRectGetMaxY(rect);
            //键盘挡住了响应式图
            if (keyBoardY < vMaxY) {
                self.responseV.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0,keyBoardY - vMaxY);
            }
            return;
        }
    }
}

- (void)keyboardHide:(NSNotification *)notifi {
    self.responseV.transform = CGAffineTransformIdentity;
}

#pragma mark - Get & Set

- (void)setResponseV:(UIView *)responseV {
    _responseV = responseV;
    if (responseV) {
        [self addNotifiCation];
    } else {
        [self removeNotifiCation];
    }
}

@end


@implementation BQKeyBoardToolBar

+ (instancetype)toolBar {
    return [[BQKeyBoardToolBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(0, 0, 44, 44);
    [preBtn setImage:[UIImage arrowImgWithFrame:CGRectMake(10, 0, 22, 12) color:[UIColor colorWithWhite:0.3 alpha:1] lineWidth:2 direction:BQArrowDirection_Top] forState:UIControlStateNormal];
    [preBtn setImage:[UIImage arrowImgWithFrame:CGRectMake(10, 0, 22, 12) color:[UIColor lightGrayColor] lineWidth:2 direction:BQArrowDirection_Top] forState:UIControlStateSelected];
    [self addSubview:preBtn];
    self.preBtn = preBtn;
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(CGRectGetMaxX(preBtn.frame), 0, 44, 44);
    [nextBtn setImage:[UIImage arrowImgWithFrame:CGRectMake(0, 0, 22, 12) color:[UIColor colorWithWhite:0.3 alpha:1] lineWidth:2 direction:BQArrowDirection_bottom] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage arrowImgWithFrame:CGRectMake(0, 0, 22, 12) color:[UIColor lightGrayColor] lineWidth:2 direction:BQArrowDirection_bottom] forState:UIControlStateSelected];
    [self addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UILabel * lab = [UILabel labWithFrame:CGRectMake(100, 0, self.bounds.size.width - 160, self.bounds.size.height) title:@"" fontSize:14 textColor:[UIColor blackColor]];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    self.tipLab = lab;
    
    UIButton * dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissBtn.frame = CGRectMake(self.bounds.size.width - 60, 0, 60, 44);
    dissBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [dissBtn setTitle:@"完成" forState:UIControlStateNormal];
    [dissBtn setTitleColor:[UIColor hexstr:@"0099ff"] forState:UIControlStateNormal];
    [self addSubview:dissBtn];
    self.dissBtn = dissBtn;
}

@end
