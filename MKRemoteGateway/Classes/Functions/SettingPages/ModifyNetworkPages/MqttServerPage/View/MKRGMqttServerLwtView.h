//
//  MKRGMqttServerLwtView.h
//  MKRemoteGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRGMqttServerLwtViewModel : NSObject

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@end

@protocol MKRGMqttServerLwtViewDelegate <NSObject>

- (void)rg_lwt_statusChanged:(BOOL)isOn;

- (void)rg_lwt_retainChanged:(BOOL)isOn;

- (void)rg_lwt_qosChanged:(NSInteger)qos;

- (void)rg_lwt_topicChanged:(NSString *)text;

- (void)rg_lwt_payloadChanged:(NSString *)text;

@end

@interface MKRGMqttServerLwtView : UIView

@property (nonatomic, strong)MKRGMqttServerLwtViewModel *dataModel;

@property (nonatomic, weak)id <MKRGMqttServerLwtViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
