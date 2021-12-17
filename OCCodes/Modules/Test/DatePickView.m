// *******************************************
//  File Name:      DatePickView.m       
//  Author:         MrBai
//  Created Date:   2021/12/16 2:21 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "DatePickView.h"

#import "BQDatePickerView.h"
#import "BQTipView.h"
#import "NSDate+Custom.h"
#import "UIColor+Custom.h"
#import "UILabel+Custom.h"

@interface DatePickView ()
<
BQDatePickerViewDelegate
>
@property (nonatomic, strong) NSArray<UIButton *>   * btnList;
@property (nonatomic, strong) UIView                * paramsV;
@property (nonatomic, copy  ) NSString              * formatStr;
@property (nonatomic, strong) UILabel               * formatLab;
@property (nonatomic, strong) UILabel               * timeLab;
@property (nonatomic, strong) UIButton              * showBtn;
@end

@implementation DatePickView


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self paramsBtnClick:nil];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)paramsBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSMutableString * str = [NSMutableString string];
    NSArray * arr = @[@"yyyy",@"-MM",@"-dd",@" HH",@":mm",@":ss"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton * btn = self.btnList[i];
        if (btn.selected) {
            [str appendString:arr[i]];
        }
    }
    if ([str hasPrefix:@"-"] || [str hasPrefix:@" "] || [str hasPrefix:@":"]) {
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    _formatStr = [str copy];
    self.formatLab.text = [NSString stringWithFormat:@"当前格式: %@", _formatStr];
}

- (void)showDatePick {
    NSInteger i = 0;
    for (UIButton * btn in self.btnList) {
        if (btn.isSelected) i |= ( 1 << btn.tag);
    }
    if (i == 0) {
        [BQTipView showInfo:@"至少选择一项参数"];
        return;
    }
    
    BQDatePickerView * pickView = [BQDatePickerView pickView];
    pickView.model = i;
    pickView.formatStr = _formatStr;
    pickView.centerTitle = @"测试";
    pickView.delegate = self;
    [pickView showDateTimePickerView];
}
#pragma mark - *** Delegate
- (void)didClickFinishDateTimePickerView:(NSDate *)date formatStr:(NSString *)formatStr {
    self.timeLab.text = [NSString stringWithFormat:@"选择结果: %@",formatStr];
}
#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.paramsV];
    [self.view addSubview:self.formatLab];
    [self.view addSubview:self.timeLab];
    [self.view addSubview:self.showBtn];
}

#pragma mark - *** Set

#pragma mark - *** Get

- (UIButton *)showBtn {
    if (_showBtn == nil) {
        UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showBtn.backgroundColor = [UIColor hex:0x0099ff];
        showBtn.frame = CGRectMake((self.view.width - 120) * 0.5, self.timeLab.bottom + 30, 120, 40);
        showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [showBtn setRadius:4];
        [showBtn setTitle:@"弹出选择控件" forState:UIControlStateNormal];
        [showBtn addTarget:self action:@selector(showDatePick) forControlEvents:UIControlEventTouchUpInside];
        _showBtn = showBtn;
    }
    return _showBtn;
}

- (UIView *)paramsV {
    if (_paramsV == nil) {
        UIView * paramsV = [[UIView alloc] initWithFrame:CGRectMake(15, self.navbarBottom, self.view.width - 30, 100)];
        UILabel * lab = [UILabel labWithFrame:CGRectMake(0, 0, paramsV.width, 40) title:@"参数选择:" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
        [paramsV addSubview:lab];
        
        CGFloat btnW = paramsV.width / 3;
        NSArray * arr = @[@"  年", @"  月", @"  日", @"  时", @"  分", @"  秒"];
        NSMutableArray<UIButton *> * btnList = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSInteger i = 0; i < arr.count; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake((i % 3) * btnW, lab.bottom + (i / 3) * 40, btnW, 40);
            [btn setImage:[UIImage imageNamed:@"login_info_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"login_info_select"] forState:UIControlStateSelected];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitle:arr[i] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState: UIControlStateSelected];
            [paramsV addSubview:btn];
            [btn addTarget:self action:@selector(paramsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = YES;
            [btnList addObject:btn];
        }
        _btnList = [btnList copy];
        paramsV.height = btnList.lastObject.bottom;
        _paramsV = paramsV;
    }
    return _paramsV;
}

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.formatLab.bottom, self.view.width - 30, 40)];
        timeLab.text = @"选择结果: ";
        _timeLab = timeLab;
    }
    return _timeLab;
}


- (UILabel *)formatLab {
    if (_formatLab == nil) {
        UILabel * formatLab = [[UILabel alloc] initWithFrame:CGRectMake(self.paramsV.left, self.paramsV.bottom, self.paramsV.width, 40)];
        formatLab.text = @"当前格式: ";
        _formatLab = formatLab;
    }
    return _formatLab;
}

@end
