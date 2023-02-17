//
//  MKRGBleWifiSettingsCertCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKRGBleWifiSettingsCertCellDelegate <NSObject>

- (void)rg_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKRGBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKRGBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKRGBleWifiSettingsCertCellDelegate>delegate;

+ (MKRGBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
