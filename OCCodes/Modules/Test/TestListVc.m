// *******************************************
//  File Name:      TestListVc.m       
//  Author:         MrBai
//  Created Date:   2021/12/14 4:40 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "TestListVc.h"

#import "BQCrashHelper.h"
#import "BQCrashHelper.h"
#import "BQUserDefault.h"
#import "NSArray+Custom.h"
#import "NSData+Custom.h"
#import "NSString+Custom.h"
#import "NSString+Custom.h"
#import "UITableView+Custom.h"
#import "VcInfoCell.h"
#import "VcModel.h"

@interface TestListVc ()
<
UITableViewDelegate
,UITableViewDataSource
>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray<VcModel *> * list;
@end

@implementation TestListVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.list = @[
        [VcModel modelWithDic:@{@"clsName":@"DatePickView",@"titleName":@"时间选择控件",@"descStr":@"时间选择"}]
        ,[VcModel modelWithDic:@{@"clsName":@"VideoPlayerVc",@"titleName":@"播放器控件",@"descStr":@"视频播放"}]
        ,[VcModel modelWithDic:@{@"clsName":@"CameraVc",@"titleName":@"摄像头控件",@"descStr":@"摄像头调用"}]
        ,[VcModel modelWithDic:@{@"clsName":@"KeyBoardManagerVc",@"titleName":@"键盘管理控件",@"descStr":@"键盘管理器+文本输入限制"}]
        ,[VcModel modelWithDic:@{@"clsName":@"CollectionViewVc",@"titleName":@"CollectionView布局",@"descStr":@"列表布局设计"}]
        ,[VcModel modelWithDic:@{@"clsName":@"SpeedVc",@"titleName":@"速度检测",@"descStr":@"gps检测"}]
    ];
    
    [self configUI];
    [BQCrashHelper startCrashRecord];
    NSLog(@"开始测试");
    [self testMethod];
    NSLog(@"测试结束");
}

#pragma mark - *** NetWork method

- (void)testMethod {

}

#pragma mark - *** Event Action

- (void)showCrashInfo {
    [BQCrashHelper showCrashInfo];
}

#pragma mark - *** Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VcInfoCell * cell = [VcInfoCell loadFromTableView:tableView indexPath:indexPath];
    [cell configInfo:self.list[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.list[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VcModel * model = self.list[indexPath.row];
    UIViewController * vc = [model coverVc];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Crash Info" style:UIBarButtonItemStylePlain target:self action:@selector(showCrashInfo)];
    
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [tableView registerCell:[VcInfoCell class] isNib:NO];
        tableView.tableFooterView = [UIView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
    }
    return _tableView;
}

@end
