//
//  MKRGScanPageCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKRGScanPageModel;
@interface MKRGScanPageCell : MKBaseCell

@property (nonatomic, strong)MKRGScanPageModel *dataModel;

+ (MKRGScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
