//
//  MKRGFilterBeaconCell.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKRGFilterBeaconCellDelegate <NSObject>

- (void)mk_rg_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_rg_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKRGFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKRGFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKRGFilterBeaconCellDelegate>delegate;

+ (MKRGFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
