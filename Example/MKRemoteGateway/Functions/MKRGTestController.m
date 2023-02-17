//
//  MKRGTestController.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKRGTestController.h"

#import "MKRGDeviceListController.h"

@interface MKRGTestController ()

@end

@implementation MKRGTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTitle = @"测试页面";
    // Do any additional setup after loading the view.
}

- (void)leftButtonMethod {
    MKRGDeviceListController *vc = [[MKRGDeviceListController alloc] init];
    vc.connectServer = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
