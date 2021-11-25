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
@property (nonatomic, assign)BQDatePickerViewMode pickerViewMode;
@property (nonatomic,strong) UIView * bgView;                   ///< 背景View
@property (nonatomic,strong) UIView * bottomView;               ///< 下部视图
@property (nonatomic,strong) UIPickerView * pickerView;
@property (nonatomic,strong) UIButton *cancelButton;            ///< 左边退出按钮
@property (nonatomic,strong) UIButton *chooseButton;            ///< 右边的确定按钮
@property (nonatomic,strong) UILabel *titleLabel;               ///< 标题
@property (nonatomic,strong) UIView *splitView;                 ///< 分割线
@property (nonatomic,strong) NSArray *columnArray;//存放每种情况需要分割的列

@end

@implementation BQDatePickerView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                         mode:(BQDatePickerViewMode)dateModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.pickerViewMode = dateModel;
        [self setUpData];
        
        [self setUpUI];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDateTimePickerView)];
        [self.bgView addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Public method

+ (instancetype)configDateView:(BQDatePickerViewMode)dateMode {
    return [[BQDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds mode:dateMode];
}

- (void)showDateTimePickerView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomView.top = self.height - self.bottomView.height;
        self.bgView.alpha = 1;
    }];
    
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
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
    if ([self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
        NSDateComponents * comp = [[NSDateComponents alloc] init];
        comp.year = _selectedYear;
        comp.month = _selectedMonth;
        comp.day = _selectedDay;
        comp.hour = _selectedHour;
        comp.minute = _selectedMinute;
        comp.second = _selectedSecond;
        [self.delegate didClickFinishDateTimePickerView:comp];
    }
    [self hideDateTimePickerView];
}
#pragma mark - Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.columnArray[self.pickerViewMode] integerValue];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerViewMode <= 5) {
        switch (component) {
            case 0:
                return _yearRange;
            case 1:
                return 12;
            case 2:
                return _dayRange;
            case 3:
                return 24;
            case 4:
                return 60;
            case 5:
                return 60;
            default:
                break;
        }
    } else if (self.pickerViewMode <= 7) {
        switch (component) {
            case 0:
                return 24;
            case 1:
                return 60;
            case 2:
                return 60;
            default:
                break;
        }
    } else {
        switch (component) {
            case 0:
                return 60;
            case 1:
                return 60;
            default:
                break;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * label = (UILabel *)view;
    
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.frame = CGRectMake(self.width * component / 6.0, 0 ,self.width / 6.0, 30);
    
    if (self.pickerViewMode <= 5) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(_startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode <= 7){
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentLeft;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentCenter;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 2:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
            default:
                break;
        }
    } else {
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentLeft;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.width - 40) / [self.columnArray[self.pickerViewMode] integerValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerViewMode <= 5) {
        switch (component) {
            case 0:
            {
                _selectedYear = _startYear + row;
                _dayRange = [self allDaysAtMouth];
                [self.pickerView reloadAllComponents];
            }
                break;
            case 1:
            {
                _selectedMonth = row + 1;
                _dayRange = [self allDaysAtMouth];
                [self.pickerView reloadAllComponents];
            }
                break;
            case 2:
            {
                _selectedDay = row + 1;
            }
                break;
            case 3:
            {
                _selectedHour = row;
            }
                break;
            case 4:
            {
                _selectedMinute = row;
            }
                break;
            case 5:
            {
                _selectedSecond = row;
            }
                break;
            default:
                break;
        }
        if (_selectedDay > _dayRange) {
            _selectedDay = _dayRange;
        }
    } else if (self.pickerViewMode <= 7) {
        switch (component) {
            case 0:
            {
                _selectedHour = row;
            }
                break;
            case 1:
            {
                _selectedMinute = row;
            }
                break;
            case 2:
            {
                _selectedSecond = row;
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (component) {
            case 0:
            {
                _selectedMinute = row;
            }
                break;
            case 1:
            {
                _selectedSecond = row;
            }
                break;
                
            default:
                break;
        }
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
    self.pickerViewMode = BQDatePickerViewModeDate;
    self.columnArray = @[@(1),@(2),@(3),@(4),@(5),@(6),@(2),@(3),@(2)];
    
    _dayRange = 0;
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
        UIPickerView * pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 180)];
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
        titleLab.text = @"时间选择器";
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
    
    if (self.pickerViewMode <= 5) {
        [self.pickerView selectRow:_selectedYear - _startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:_selectedYear - _startYear inComponent:0];
        if (self.pickerViewMode >= 1) {
            [self.pickerView selectRow:_selectedMonth - 1 inComponent:1 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedMonth - 1 inComponent:1];
        }
        if (self.pickerViewMode >= 2) {
            [self.pickerView selectRow:_selectedDay - 1 inComponent:2 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedDay - 1 inComponent:2];
        }
        if (self.pickerViewMode >= 3) {
            [self.pickerView selectRow:_selectedHour inComponent:3 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedHour inComponent:3];
        }
        if (self.pickerViewMode >= 4) {
            [self.pickerView selectRow:_selectedMinute inComponent:4 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedMinute inComponent:4];
        }
        if (self.pickerViewMode >= 5) {
            [self.pickerView selectRow:_selectedSecond inComponent:5 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedSecond inComponent:5];
        }
    } else if (self.pickerViewMode <= 7) {
        [self.pickerView selectRow:_selectedHour inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:_selectedHour inComponent:0];
        
        [self.pickerView selectRow:_selectedMinute inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:_selectedMinute inComponent:1];
        if (self.pickerViewMode >= 7) {
            [self.pickerView selectRow:_selectedSecond inComponent:2 animated:NO];
            [self pickerView:self.pickerView didSelectRow:_selectedSecond inComponent:2];
        }
    } else {
        [self.pickerView selectRow:_selectedMinute inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:_selectedMinute inComponent:0];
        
        [self.pickerView selectRow:_selectedSecond inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:_selectedSecond inComponent:1];
    }
    
    for (UIView *subView in self.pickerView.subviews) {
        if (subView.frame.size.height <= 1) {//获取分割线view
            subView.hidden = NO;
            subView.backgroundColor = self.chooseButton.titleLabel.textColor;//设置分割线颜色
        }
    }
}

@end
