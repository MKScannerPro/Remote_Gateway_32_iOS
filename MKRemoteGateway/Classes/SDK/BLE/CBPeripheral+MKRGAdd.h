//
//  CBPeripheral+MKRGAdd.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKRGAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *rg_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *rg_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *rg_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *rg_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *rg_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *rg_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *rg_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *rg_custom;

- (void)rg_updateCharacterWithService:(CBService *)service;

- (void)rg_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)rg_connectSuccess;

- (void)rg_setNil;

@end

NS_ASSUME_NONNULL_END
