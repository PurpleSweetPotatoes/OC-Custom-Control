//
//  DatePickView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/5/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQDatePickerView.h"

#import "CALayer+Custom.h"
#import "UIColor+Custom.h"
#import "UIView+Custom.h"
#import "NSDate+Custom.h"

@interface BQDatePickerView ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
{
    NSInteger _yearRange;
    NSInteger _dayRange;
    NSInteger _startYear;
    NSInteger _selectedYear;
    NSInteger _selectedMonth;
    NSInteger _selectedDay;
    NSInteger _selectedHour;
    NSInteger _selectedMinute;
    NSInteger _selectedSecond;
}
@property (nonatomic,strong ) UIView            * bgView;       ///< 背景View
@property (nonatomic,strong ) UIView            * bottomView;   ///< 下部视图
@property (nonatomic,strong ) UIPickerView      * pickerView;
@property (nonatomic,strong ) UIButton          * cancelButton; ///< 左边退出按钮
@property (nonatomic,strong ) UIButton          * chooseButton; ///< 右边的确定按钮
@property (nonatomic,strong ) UILabel           * titleLabel;   ///< 标题
@property (nonatomic,strong ) UIView            * splitView;    ///< 分割线
@property (nonatomic, assign) CGFloat           labWidth;       ///< 宽度
@end

@implementation BQDatePickerView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setUpData];
        [self setUpUI];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDateTimePickerView)];
        [self.bgView addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Public method

+ (instancetype)pickView {
    return [[self alloc] initWithFrame:CGRectZero];
}

- (void)showDateTimePickerView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomView.top = self.height - self.bottomView.height;
        self.bgView.alpha = 1;
    }];

    self.currentDate = self.currentDate ?: [NSDate date];
    self.titleLabel.text = self.centerTitle;
    
    for (UIView *subView in self.pickerView.subviews) {
        if (subView.frame.size.height <= 1) {//获取分割线view
            subView.hidden = NO;
            subView.backgroundColor = self.chooseButton.titleLabel.textColor;//设置分割线颜色
        }
    }
}

- (void)hideDateTimePickerView {    
    [UIView animateWithDuration:0.2f animations:^{
        self.bottomView.top = self.height;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - NetWork method

#pragma mark - Btn Action

- (void)cancelBtnAction:(UIButton *)sender {
    NSLog(@"隐藏");
    [self hideDateTimePickerView];
}

- (void)chooseBtnAction:(UIButton *)sender {
    NSLog(@"选择");
    if ([self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:formatStr:)]) {
        
        NSString * str = [NSString stringWithFormat:@"%zd-%02zd-%02zd %02zd:%02zd:%02zd", _selectedYear, _selectedMonth, _selectedDay, _selectedHour, _selectedMinute, _selectedSecond];
        NSDate * date = [NSDate dateFromString:str style:@"yyyy-MM-dd HH:mm:ss"];
        
        [self.delegate didClickFinishDateTimePickerView:date formatStr:[date getTimeStringFormat:self.formatStr]];
        
    }
    [self hideDateTimePickerView];
}

#pragma mark - Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray * arr = @[@(_yearRange), @12, @(_dayRange), @24, @60, @60];
    if (_model & (1 << component)) {
        return [arr[component] integerValue];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * label = (UILabel *)view;
    
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.width - 30) / 6, 30)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
    }

    switch ((1 << component)) {
        case BQDatePickerModelYear:
            label.text = [NSString stringWithFormat:@"%ld年",(long)(_startYear + row)];
            break;
        case BQDatePickerModelMonth:
            label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            break;
        case BQDatePickerModelDay:
            label.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
            break;
        case BQDatePickerModelHour:
            label.text = [NSString stringWithFormat:@"%ld时",(long)row];
            break;
        case BQDatePickerModelMinute:
            label.text = [NSString stringWithFormat:@"%ld分",(long)row];
            break;
        case BQDatePickerModelSecond:
            label.text = [NSString stringWithFormat:@"%ld秒",(long)row];
            break;
        default:
            break;
    }
    
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if ([self pickerView:pickerView numberOfRowsInComponent:component]) {
        return self.labWidth;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
        switch (1 << component) {
            case BQDatePickerModelYear:
            {
                _selectedYear = _startYear + row;
                _dayRange = [self allDaysAtMouth];
                [self.pickerView reloadAllComponents];
            }
                break;
            case BQDatePickerModelMonth:
            {
                _selectedMonth = row + 1;
                _dayRange = [self allDaysAtMouth];
                [self.pickerView reloadAllComponents];
            }
                break;
            case BQDatePickerModelDay:
                _selectedDay = row + 1;
                break;
            case BQDatePickerModelHour:
                _selectedHour = row;
                break;
            case BQDatePickerModelMinute:
                _selectedMinute = row;
                break;
            case BQDatePickerModelSecond:
                _selectedSecond = row;
                break;
            default:
                break;
        }
    
        if (_selectedDay > _dayRange) {
            _selectedDay = _dayRange;
        }
}

#pragma mark - UI method

- (void)setUpUI {
    
    [self addSubview:self.bgView];
    [self addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.chooseButton];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.pickerView];
}

- (UIButton *)configBtnWithWithTitle:(NSString *)title {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor hexstr:@"0d8bf5"] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Instance method

- (void)setUpData {
    
    self.model = BQDatePickerModelYear | BQDatePickerModelMonth | BQDatePickerModelDay | BQDatePickerModelHour | BQDatePickerModelMinute | BQDatePickerModelSecond;
    _formatStr = @"yyyy-MM-dd HH:mm:ss";
    _dayRange = 28;
    _startYear = 1980;
    _yearRange = 100;
    _selectedYear = 0;
    _selectedMonth = 0;
    _selectedDay = 0;
    _selectedHour = 0;
    _selectedMinute = 0;
    _selectedSecond = 0;
}

- (NSInteger)allDaysAtMouth {
    switch(_selectedMonth)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        case 2:
        {
            if ((_selectedYear % 4 == 0 && _selectedYear % 100 != 0) || (_selectedYear % 400 == 0)) {
                return 29;
            }
            return 28;
        }
        default:
            break;
    }
    return 0;
}

#pragma mark - Get & Set

- (UIView *)bgView {
    if (_bgView == nil) {
        UIView * bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.alpha = 0;
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bgView = bgView;
    }
    return _bgView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 224)];
        bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        UIPickerView * pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, 180)];
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        [pickView.layer addSublayer:[CALayer cellLineLayerWithFrame:CGRectMake(0, 0, self.width, 1)]];
        _pickerView = pickView;
    }
    return _pickerView;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        UIButton * btn = [self configBtnWithWithTitle:@"取消"];
        btn.frame = CGRectMake(12, 0, 44, 44);
        [btn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = btn;
    }
    return _cancelButton;
}

- (UIButton *)chooseButton {
    if (_chooseButton == nil) {
        UIButton * btn = [self configBtnWithWithTitle:@"确定"];
        btn.frame = CGRectMake(self.width - 54, 0, 44, 44);
        [btn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton = btn;
    }
    return _chooseButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.cancelButton.right, 0, self.width - 108, 44)];
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"时间选择";
        _titleLabel = titleLab;
    }
    return _titleLabel;
}

- (void)setCurrentDate:(NSDate *)currentDate {
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:currentDate];
    
    _selectedYear = [comps year];
    _selectedMonth = [comps month];
    _selectedDay = [comps day];
    _selectedHour = [comps hour];
    _selectedMinute = [comps minute];
    _selectedSecond  = [comps second];
    _currentDate = currentDate;
    _dayRange = [self allDaysAtMouth];

    [self.pickerView reloadAllComponents];
    
    NSArray * starts = @[@(_selectedYear),@(_selectedMonth),@(_selectedDay),@(_selectedHour),@(_selectedMinute),@(_selectedSecond)];
    
    for (NSInteger i = 0; i < starts.count; i++) {
        if ((self.model & (1 << i)) && [self pickerView:self.pickerView numberOfRowsInComponent:i] > 0) {
            NSInteger start = [starts[i] intValue];
            NSInteger row = start;
            if (i == 0) {
                row -= _startYear;
            } else if (i < 3) {
                row -= 1;
            }
            [self.pickerView selectRow:row inComponent:i animated:NO];
        }
    }
}

- (void)setModel:(BQDatePickerModel)model {
    if (model == 0) model = BQDatePickerModelYear | BQDatePickerModelMonth | BQDatePickerModelDay;
    
    if (_model != model) {
        _model = model;
        NSInteger num = 0;
        if (model & BQDatePickerModelYear)  num += 1;
        if (model & BQDatePickerModelMonth) num += 1;
        if (model & BQDatePickerModelDay)  num += 1;
        if (model & BQDatePickerModelHour) num += 1;
        if (model & BQDatePickerModelMinute) num += 1;
        if (model & BQDatePickerModelSecond) num += 1;
        _labWidth = (self.width - 30) / num;
    }
}

@end
