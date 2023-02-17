//
//  MKRGDeviceMQTTParamsModel.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKRGDeviceMQTTParamsModel.h"

#import "MKRGDeviceModel.h"

static MKRGDeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKRGDeviceMQTTParamsModel

+ (MKRGDeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKRGDeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKRGDeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKRGDeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
