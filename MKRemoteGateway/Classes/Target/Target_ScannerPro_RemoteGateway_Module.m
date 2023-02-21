//
//  Target_ScannerPro_RemoteGateway_Module.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "Target_ScannerPro_RemoteGateway_Module.h"

#import "MKRGDeviceListController.h"

@implementation Target_ScannerPro_RemoteGateway_Module

- (UIViewController *)Action_MKScannerPro_RemoteGateway_DeviceListPage:(NSDictionary *)params {
    MKRGDeviceListController *vc = [[MKRGDeviceListController alloc] init];
    vc.connectServer = YES;
    return vc;
}

@end
