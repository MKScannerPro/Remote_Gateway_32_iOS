//
//  MKRGUserCredentialsView.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKRGUserCredentialsViewDelegate <NSObject>

- (void)rg_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)rg_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKRGUserCredentialsView : UIView

@property (nonatomic, strong)MKRGUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKRGUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
