//
//  CBPeripheral+MKRGAdd.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKRGAdd.h"

#import <objc/runtime.h>

static const char *rg_manufacturerKey = "rg_manufacturerKey";
static const char *rg_deviceModelKey = "rg_deviceModelKey";
static const char *rg_hardwareKey = "rg_hardwareKey";
static const char *rg_softwareKey = "rg_softwareKey";
static const char *rg_firmwareKey = "rg_firmwareKey";

static const char *rg_passwordKey = "rg_passwordKey";
static const char *rg_disconnectTypeKey = "rg_disconnectTypeKey";
static const char *rg_customKey = "rg_customKey";

static const char *rg_passwordNotifySuccessKey = "rg_passwordNotifySuccessKey";
static const char *rg_disconnectTypeNotifySuccessKey = "rg_disconnectTypeNotifySuccessKey";
static const char *rg_customNotifySuccessKey = "rg_customNotifySuccessKey";

@implementation CBPeripheral (MKRGAdd)

- (void)rg_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &rg_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &rg_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &rg_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &rg_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &rg_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &rg_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &rg_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &rg_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)rg_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &rg_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &rg_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &rg_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)rg_connectSuccess {
    if (![objc_getAssociatedObject(self, &rg_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &rg_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &rg_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.rg_hardware || !self.rg_firmware) {
        return NO;
    }
    if (!self.rg_password || !self.rg_disconnectType || !self.rg_custom) {
        return NO;
    }
    return YES;
}

- (void)rg_setNil {
    objc_setAssociatedObject(self, &rg_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &rg_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &rg_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rg_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)rg_manufacturer {
    return objc_getAssociatedObject(self, &rg_manufacturerKey);
}

- (CBCharacteristic *)rg_deviceModel {
    return objc_getAssociatedObject(self, &rg_deviceModelKey);
}

- (CBCharacteristic *)rg_hardware {
    return objc_getAssociatedObject(self, &rg_hardwareKey);
}

- (CBCharacteristic *)rg_software {
    return objc_getAssociatedObject(self, &rg_softwareKey);
}

- (CBCharacteristic *)rg_firmware {
    return objc_getAssociatedObject(self, &rg_firmwareKey);
}

- (CBCharacteristic *)rg_password {
    return objc_getAssociatedObject(self, &rg_passwordKey);
}

- (CBCharacteristic *)rg_disconnectType {
    return objc_getAssociatedObject(self, &rg_disconnectTypeKey);
}

- (CBCharacteristic *)rg_custom {
    return objc_getAssociatedObject(self, &rg_customKey);
}

@end
