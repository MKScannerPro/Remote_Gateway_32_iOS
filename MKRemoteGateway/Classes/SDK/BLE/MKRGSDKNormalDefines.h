
typedef NS_ENUM(NSInteger, mk_rg_centralConnectStatus) {
    mk_rg_centralConnectStatusUnknow,                                           //未知状态
    mk_rg_centralConnectStatusConnecting,                                       //正在连接
    mk_rg_centralConnectStatusConnected,                                        //连接成功
    mk_rg_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_rg_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_rg_centralManagerStatus) {
    mk_rg_centralManagerStatusUnable,                           //不可用
    mk_rg_centralManagerStatusEnable,                           //可用状态
};


typedef NS_ENUM(NSInteger, mk_rg_wifiSecurity) {
    mk_rg_wifiSecurity_personal,
    mk_rg_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_rg_eapType) {
    mk_rg_eapType_peap_mschapv2,
    mk_rg_eapType_ttls_mschapv2,
    mk_rg_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_rg_connectMode) {
    mk_rg_connectMode_TCP,                                          //TCP
    mk_rg_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_rg_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_rg_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_rg_mqttServerQosMode) {
    mk_rg_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_rg_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_rg_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_rg_filterRelationship) {
    mk_rg_filterRelationship_null,
    mk_rg_filterRelationship_mac,
    mk_rg_filterRelationship_advName,
    mk_rg_filterRelationship_rawData,
    mk_rg_filterRelationship_advNameAndRawData,
    mk_rg_filterRelationship_macAndadvNameAndRawData,
    mk_rg_filterRelationship_advNameOrRawData,
    mk_rg_filterRelationship_advNameAndMacData,
};


@protocol mk_rg_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_rg_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_rg_startScan;

/// Stops scanning equipment.
- (void)mk_rg_stopScan;

@end
