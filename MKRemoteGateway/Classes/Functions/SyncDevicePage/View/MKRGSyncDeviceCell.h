//
//  MKRGSyncDeviceCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2025/3/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKRGDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKRGSyncDeviceCellModel : MKRGDeviceModel

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKRGSyncDeviceCellDelegate <NSObject>

- (void)rg_syncDeviceCell_selected:(BOOL)selected index:(NSInteger)index;

@end

@interface MKRGSyncDeviceCell : MKBaseCell

@property (nonatomic, strong)MKRGSyncDeviceCellModel *dataModel;

@property (nonatomic, weak)id <MKRGSyncDeviceCellDelegate>delegate;

+ (MKRGSyncDeviceCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
