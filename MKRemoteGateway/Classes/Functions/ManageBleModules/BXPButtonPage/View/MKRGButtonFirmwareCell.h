//
//  MKRGButtonFirmwareCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/3/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGButtonFirmwareCellModel : NSObject

/// cell唯一识别号
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

@property (nonatomic, copy)NSString *rightButtonTitle;

@end

@protocol MKRGButtonFirmwareCellDelegate <NSObject>

- (void)rg_buttonFirmwareCell_buttonAction:(NSInteger)index;

@end

@interface MKRGButtonFirmwareCell : MKBaseCell

@property (nonatomic, strong)MKRGButtonFirmwareCellModel *dataModel;

@property (nonatomic, weak)id <MKRGButtonFirmwareCellDelegate>delegate;

+ (MKRGButtonFirmwareCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
