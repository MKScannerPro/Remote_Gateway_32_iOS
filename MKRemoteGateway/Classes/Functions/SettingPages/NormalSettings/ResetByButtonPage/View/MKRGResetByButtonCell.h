//
//  MKRGResetByButtonCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKRGResetByButtonCellDelegate <NSObject>

- (void)rg_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKRGResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKRGResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKRGResetByButtonCellModel *dataModel;

+ (MKRGResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
