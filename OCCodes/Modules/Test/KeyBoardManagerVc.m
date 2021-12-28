// *******************************************
//  File Name:      KeyBoardManagerVc.m       
//  Author:         MrBai
//  Created Date:   2021/12/27 10:14 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "KeyBoardManagerVc.h"

#import "BQKeyBoardManager.h"
#import "BQTextRule.h"
#import "CALayer+Custom.h"
#import "UILabel+Custom.h"
#import "UITextField+Custom.h"

@interface KeyBoardManagerVc ()

@end

@implementation KeyBoardManagerVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BQKeyBoardManager startResponseView:self.view space:3];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BQKeyBoardManager closeResponse];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    
    UILabel * tipLab = [UILabel labWithFrame:CGRectMake(0, self.navbarBottom, self.view.width, 50) title:@"个人信息输入模拟" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    
    NSArray * arr = @[@"中文名", @"英文名", @"年    龄", @"身份证", @"电    话", @"地    址"];
    CGFloat top = tipLab.bottom + 20;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSString * name = arr[i];
        UITextField * tf = [self configTextWithTop:top name:name];
        top = tf.bottom + 20;
        if (i == 0) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_Chinese];
            tf.rule.maxLength = 4;
        } else if (i == 1) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_Char];
            tf.rule.maxLength = 20;
        } else if (i == 2) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_Num];
            tf.rule.maxLength = 3;
        } else if (i == 3) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_NumChar];
            tf.rule.maxLength = 18;
        } else if (i == 4) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_Num];
            tf.rule.maxLength = 11;
        } else if (i == 5) {
            tf.rule = [BQTextRule textRuleType:BQTextRuleType_Normal];
            tf.rule.maxLength = 100;
        }
    }
    CALayer * lineLayer = [CALayer cellLineLayerWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 1)];
    [self.view.layer addSublayer:lineLayer];
    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(15,  lineLayer.bottom + 3, self.view.width - 30, 34)];
    tf.placeholder = @"底部输入框";
    [tf setRadius:4];
    [tf addLeftSpace:8];
    [tf setBorderWidth:1 color:[UIColor lightGrayColor]];
    [self.view addSubview:tf];
}


- (UITextField *)configTextWithTop:(CGFloat)top name:(NSString *)name {
    UILabel * lab = [UILabel labWithFrame:CGRectMake(15, top, 60, 35) title:name font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    [self.view addSubview:lab];
    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(lab.right, lab.top, self.view.width - lab.right - 15, lab.height)];
    tf.font = lab.font;
    tf.placeholder = [NSString stringWithFormat:@"请输入%@", [name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [tf setRadius:4];
    [tf setBorderWidth:1 color:[UIColor lightGrayColor]];
    [tf addLeftSpace:8];
    [self.view addSubview:tf];
    return tf;
}
#pragma mark - *** Set

#pragma mark - *** Get
    

@end
