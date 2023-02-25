//
//  MKRGDeviceDataPageHeaderView.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGDeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKRGDeviceDataPageHeaderViewDelegate <NSObject>

- (void)rg_updateLoadButtonAction;

- (void)rg_scannerStatusChanged:(BOOL)isOn;

- (void)rg_manageBleDeviceAction;

@end

@interface MKRGDeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKRGDeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKRGDeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
