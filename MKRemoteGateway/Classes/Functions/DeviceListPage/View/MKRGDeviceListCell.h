//
//  MKRGDeviceListCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKRGDeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)rg_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKRGDeviceListModel;
@interface MKRGDeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKRGDeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKRGDeviceListModel *dataModel;

+ (MKRGDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
