//
//  MKRGSystemTimeCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKRGSystemTimeCellDelegate <NSObject>

- (void)rg_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKRGSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKRGSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKRGSystemTimeCellDelegate>delegate;

+ (MKRGSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
