//
//  MKRGCentralManager.m
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKRGCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKRGPeripheral.h"
#import "MKRGOperation.h"
#import "CBPeripheral+MKRGAdd.h"

static NSString *const mk_rg_logName = @"mk_rg_bleLog";

NSString *const mk_rg_peripheralConnectStateChangedNotification = @"mk_rg_peripheralConnectStateChangedNotification";
NSString *const mk_rg_centralManagerStateChangedNotification = @"mk_rg_centralManagerStateChangedNotification";

NSString *const mk_rg_deviceDisconnectTypeNotification = @"mk_rg_deviceDisconnectTypeNotification";

static MKRGCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKRGCentralManager ()

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, assign)mk_rg_centralConnectStatus connectStatus;

@end

@implementation MKRGCentralManager

- (void)dealloc {
    [self logToLocal:@"MKRGCentralManager销毁"];
    NSLog(@"MKRGCentralManager销毁");
}

- (instancetype)init {
    if (self = [super init]) {
        [self logToLocal:@"MKRGCentralManager初始化"];
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKRGCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKRGCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",advertisementData);
        NSDictionary *dataModel = [self parseModelWithRssi:RSSI advDic:advertisementData peripheral:peripheral];
        if (!MKValidDict(dataModel)) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mk_rg_receiveDevice:)]) {
                [self.delegate mk_rg_receiveDevice:dataModel];
            }
        });
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    [self logToLocal:@"开始扫描"];
    if ([self.delegate respondsToSelector:@selector(mk_rg_startScan)]) {
        [self.delegate mk_rg_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    [self logToLocal:@"停止扫描"];
    if ([self.delegate respondsToSelector:@selector(mk_rg_stopScan)]) {
        [self.delegate mk_rg_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    NSLog(@"蓝牙中心改变");
    NSString *string = [NSString stringWithFormat:@"蓝牙中心改变:%@",@(centralManagerState)];
    [self logToLocal:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_rg_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_rg_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_rg_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_rg_centralConnectStatusConnectedFailed;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_rg_centralConnectStatusDisconnect;
    }
    NSLog(@"当前连接状态发生改变了:%@",@(connectState));
    NSString *string = [NSString stringWithFormat:@"连接状态发生改变:%@",@(connectState)];
    [self logToLocal:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_rg_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self logToLocal:@"+++++++++++++++++接收数据出错"];
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    NSString *string = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
    [self saveToLogData:string appToDevice:NO];
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_rg_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":[content substringWithRange:NSMakeRange(8, 2)]}];
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        [self logToLocal:@"发送数据出错"];
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_rg_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_rg_centralManagerStatusEnable
    : mk_rg_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"AA0B"]] options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password) || password.length > 10 || password.length < 6 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"Password Error" failedBlock:failedBlock];
        return;
    }
    self.password = nil;
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_rg_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKRGOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                   characteristic:characteristic
                                                                                      commandData:commandData
                                                                                     successBlock:successBlock
                                                                                     failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_rg_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKRGOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                       characteristic:characteristic
                                                                                         successBlock:successBlock
                                                                                         failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addOperation:(MKRGOperation *)operation {
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKRGPeripheral *trackerPeripheral = [[MKRGPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:trackerPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self sendPasswordToDevice];
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *commandData = [NSString stringWithFormat:@"ed0101%@",[MKBLEBaseSDKAdopter fetchHexValue:self.password.length byteLen:1]];
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKRGOperation *operation = [[MKRGOperation alloc] initOperationWithID:mk_rg_connectPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.rg_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"state"] isEqualToString:@"01"]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_rg_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_rg_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKRGOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_rg_taskOperationID)operationID
                                                                 characteristic:(CBCharacteristic *)characteristic
                                                                    commandData:(NSString *)commandData
                                                                   successBlock:(void (^)(id returnData))successBlock
                                                                   failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKRGOperation <MKBLEBaseOperationProtocol>*operation = [[MKRGOperation alloc] initOperationWithID:operationID commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [self saveToLogData:commandData appToDevice:YES];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKRGOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_rg_taskOperationID)operationID
                                                                     characteristic:(CBCharacteristic *)characteristic
                                                                       successBlock:(void (^)(id returnData))successBlock
                                                                       failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKRGOperation <MKBLEBaseOperationProtocol>*operation = [[MKRGOperation alloc] initOperationWithID:operationID commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        NSString *charID = [NSString stringWithFormat:@"Read %@",characteristic.UUID.UUIDString];
        [self saveToLogData:charID appToDevice:YES];
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

#pragma mark - private method
- (NSDictionary *)parseModelWithRssi:(NSNumber *)rssi advDic:(NSDictionary *)advDic peripheral:(CBPeripheral *)peripheral {
    if ([rssi integerValue] == 127 || !MKValidDict(advDic) || !peripheral) {
        return @{};
    }
    NSDictionary *manuParams = advDic[CBAdvertisementDataServiceDataKey];
    NSData *manufacturerData = manuParams[[CBUUID UUIDWithString:@"AA0B"]];
    NSData *normalData = advDic[CBAdvertisementDataManufacturerDataKey];
    if (!MKValidData(manufacturerData) || manufacturerData.length != 1
        || !MKValidData(normalData) || normalData.length < 8) {
        return @{};
    }
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:[normalData subdataWithRange:NSMakeRange(2, 6)]];
    
    NSString *deviceType = [MKBLEBaseSDKAdopter hexStringFromData:manufacturerData];
    
    if (![deviceType isEqualToString:@"00"] && ![deviceType isEqualToString:@"10"] && ![deviceType isEqualToString:@"20"] && ![deviceType isEqualToString:@"30"]) {
        return @{};
    }
    
    NSString *tempMac = [content uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    
    [self logToLocal:[@"扫描到设备:" stringByAppendingString:content]];
    
    return @{
        @"rssi":rssi,
        @"peripheral":peripheral,
        @"macAddress":macAddress,
        @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
        @"deviceType":deviceType,
        @"connectable":advDic[CBAdvertisementDataIsConnectable],
    };
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BGCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

- (void)saveToLogData:(NSString *)string appToDevice:(BOOL)app {
    if (!MKValidStr(string)) {
        return;
    }
    NSString *fuction = (app ? @"App To Device" : @"Device To App");
    NSString *recordString = [NSString stringWithFormat:@"%@---->%@",fuction,string];
    [self logToLocal:recordString];
}

- (void)logToLocal:(NSString *)string {
    if (!MKValidStr(string)) {
        return;
    }
    [MKBLEBaseLogManager saveDataWithFileName:mk_rg_logName dataList:@[string]];
}

@end
