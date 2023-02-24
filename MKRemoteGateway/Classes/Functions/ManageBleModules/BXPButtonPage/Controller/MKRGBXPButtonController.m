//
//  MKRGBXPButtonController.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKRGBXPButtonController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKButtonMsgCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertView.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKRGMQTTDataManager.h"
#import "MKRGMQTTInterface.h"

#import "MKRGDeviceModeManager.h"
#import "MKRGDeviceModel.h"

@interface MKRGBXPButtonController ()<UITableViewDelegate,
UITableViewDataSource,
MKButtonMsgCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)NSDictionary *bxpStatusDic;

@end

@implementation MKRGBXPButtonController

- (void)dealloc {
    NSLog(@"MKRGBXPButtonController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self addNotifications];
    [self readDatasFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self disconnect];
    }];
    NSString *msg = @"Please confirm agian whether to disconnect the gateway from BLE devices?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_rg_needDismissAlert"];
}

- (void)leftButtonMethod {
    //用户点击左上角，则需要返回MKRGDeviceDataController
    [self popToViewControllerWithClassName:@"MKRGDeviceDataController"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.f;
    }
    if (section == 3) {
        return 55.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKButtonMsgCell *cell = [MKButtonMsgCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section2List[indexPath.row];
        return cell;
    }
    
    MKButtonMsgCell *cell = [MKButtonMsgCell initCellWithTableView:tableView];
    cell.dataModel =  self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKButtonMsgCellDelegate
/// 右侧按钮点击事件
/// @param index 当前cell所在index
- (void)mk_buttonMsgCellButtonPressed:(NSInteger)index {
    if (index == 0) {
        //Read battery and alarm info
        [self readDatasFromDevice];
        return;
    }
    if (index == 1) {
        //Dismiss alarm status
        [self dismissAlarmStatus];
        return;
    }
}

#pragma mark - notes
- (void)receiveDisconnect:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKRGDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    NSDictionary *dataDic = user[@"data"];
    if (![dataDic[@"mac"] isEqualToString:self.deviceBleInfo[@"data"][@"mac"]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_rg_needDismissAlert" object:nil];
    //返回上一级页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKRGMQTTInterface rg_readBXPButtonConnectedStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKRGDeviceModeManager shared].macAddress topic:[MKRGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        self.bxpStatusDic = returnData;
        [self updateStatusDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)dismissAlarmStatus {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKRGMQTTInterface rg_dismissBXPButtonAlarmStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKRGDeviceModeManager shared].macAddress topic:[MKRGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        [self readDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)disconnect {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKRGMQTTInterface rg_disconnectNormalBleDeviceWithBleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKRGDeviceModeManager shared].macAddress topic:[MKRGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateStatusDatas {
    MKNormalTextCellModel *cellModel1 = self.section2List[0];
    cellModel1.rightMsg = [NSString stringWithFormat:@"%@%@",self.bxpStatusDic[@"data"][@"battery_v"],@"mV"];
    
    MKNormalTextCellModel *cellModel2 = self.section2List[1];
    cellModel2.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"single_alarm_num"]];
    
    MKNormalTextCellModel *cellModel3 = self.section2List[2];
    cellModel3.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"double_alarm_num"]];
    
    MKNormalTextCellModel *cellModel4 = self.section2List[3];
    cellModel4.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"long_alarm_num"]];
    
    MKNormalTextCellModel *cellModel5 = self.section2List[4];
    NSString *statusValue = [MKBLEBaseSDKAdopter fetchHexValue:[self.bxpStatusDic[@"data"][@"alarm_status"] integerValue] byteLen:1];
    NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:statusValue];
    BOOL singleStatus = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
    BOOL doubleStatus = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    BOOL longStatus = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    BOOL abnormalStatus = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    if ([self.bxpStatusDic[@"data"][@"alarm_status"] integerValue] == 0) {
        //无触发
        cellModel5.rightMsg = @"Not triggered";
    }else {
        //有触发
        NSString *indexString = @"";
        if (singleStatus) {
            indexString = [indexString stringByAppendingString:@"&1"];
        }
        if (doubleStatus) {
            indexString = [indexString stringByAppendingString:@"&2"];
        }
        if (longStatus) {
            indexString = [indexString stringByAppendingString:@"&3"];
        }
        if (abnormalStatus) {
            indexString = [indexString stringByAppendingString:@"&4"];
        }
        if (indexString.length > 0 && [[indexString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"&"]) {
            //截取有效字符串
            indexString = [indexString substringFromIndex:1];
        }
        cellModel5.rightMsg = [NSString stringWithFormat:@"Mode %@ triggered",SafeStr(indexString)];
    }
    
    [self.tableView reloadData];
}

#pragma mark - private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDisconnect:)
                                                 name:MKRGReceiveGatewayDisconnectBXPButtonNotification
                                               object:nil];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    MKTableSectionLineHeaderModel *lastHeaderModel = [[MKTableSectionLineHeaderModel alloc] init];
    lastHeaderModel.text = @"Mode description in alrm status: mode 1: Single press, mode 2: Double press,mode 3: Long press, mode 4: Abnormal inactivity";
    lastHeaderModel.msgTextFont = MKFont(12.f);
    lastHeaderModel.msgTextColor = UIColorFromRGB(0xcccccc);
    [self.headerList addObject:lastHeaderModel];
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Product model";
    cellModel1.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"product_model"]);
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Manufacture";
    cellModel2.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"company_name"]);
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Firmware version";
    cellModel3.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"firmware_version"]);
    [self.section0List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftMsg = @"Hardware version";
    cellModel4.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"hardware_version"]);
    [self.section0List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"Software version";
    cellModel5.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"software_version"]);
    [self.section0List addObject:cellModel5];
    
    MKNormalTextCellModel *cellModel6 = [[MKNormalTextCellModel alloc] init];
    cellModel6.leftMsg = @"MAC address";
    cellModel6.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"mac"]);
    [self.section0List addObject:cellModel6];
}

- (void)loadSection1Datas {
    MKButtonMsgCellModel *cellModel = [[MKButtonMsgCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Read battery and alarm info";
    cellModel.buttonTitle = @"Read";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Battery voltage";
    [self.section2List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Single press event count";
    [self.section2List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Double press event count";
    [self.section2List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftMsg = @"Long press event count";
    [self.section2List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"Alarm status";
    
    [self.section2List addObject:cellModel5];
}

- (void)loadSection3Datas {
    MKButtonMsgCellModel *cellModel = [[MKButtonMsgCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Dismiss alarm status";
    cellModel.buttonTitle = @"Dismiss";
    [self.section3List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [MKRGDeviceModeManager shared].deviceName;
    [self.rightButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
