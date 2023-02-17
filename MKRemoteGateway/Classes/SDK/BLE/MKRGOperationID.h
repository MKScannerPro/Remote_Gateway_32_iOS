

typedef NS_ENUM(NSInteger, mk_rg_taskOperationID) {
    mk_rg_defaultTaskOperationID,
    
#pragma mark - Read
    mk_rg_taskReadDeviceModelOperation,        //读取产品型号
    mk_rg_taskReadFirmwareOperation,           //读取固件版本
    mk_rg_taskReadHardwareOperation,           //读取硬件类型
    mk_rg_taskReadSoftwareOperation,           //读取软件版本
    mk_rg_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_rg_taskReadDeviceNameOperation,         //读取设备名称
    mk_rg_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_rg_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_rg_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_rg_taskReadTimeZoneOperation,            //读取时区
    
#pragma mark - Wifi Params
    mk_rg_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_rg_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_rg_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_rg_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_rg_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_rg_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_rg_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_rg_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_rg_taskReadDHCPStatusOperation,              //读取DHCP开关
    mk_rg_taskReadNetworkIpInfosOperation,          //读取IP信息
    
#pragma mark - MQTT Params
    mk_rg_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_rg_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_rg_taskReadClientIDOperation,            //读取Client ID
    mk_rg_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_rg_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_rg_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_rg_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_rg_taskReadServerQosOperation,           //读取MQTT Qos
    mk_rg_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_rg_taskReadPublishTopicOperation,        //读取Publish topic
    mk_rg_taskReadLWTStatusOperation,           //读取LWT开关状态
    mk_rg_taskReadLWTQosOperation,              //读取LWT Qos
    mk_rg_taskReadLWTRetainOperation,           //读取LWT Retain
    mk_rg_taskReadLWTTopicOperation,            //读取LWT topic
    mk_rg_taskReadLWTPayloadOperation,          //读取LWT Payload
    mk_rg_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - Filter Params
    mk_rg_taskReadRssiFilterValueOperation,             //读取扫描RSSI过滤
    mk_rg_taskReadFilterRelationshipOperation,          //读取扫描过滤逻辑
    mk_rg_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_rg_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    
    
#pragma mark - 密码特征
    mk_rg_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_rg_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_rg_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_rg_taskConfigTimeZoneOperation,              //配置时区
    
#pragma mark - Wifi Params
    
    mk_rg_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_rg_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_rg_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_rg_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_rg_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_rg_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_rg_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_rg_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_rg_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_rg_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_rg_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_rg_taskConfigDHCPStatusOperation,                //配置DHCP开关
    mk_rg_taskConfigIpInfoOperation,                    //配置IP地址相关信息
    
#pragma mark - MQTT Params
    mk_rg_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_rg_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_rg_taskConfigClientIDOperation,              //配置ClientID
    mk_rg_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_rg_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_rg_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_rg_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_rg_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_rg_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_rg_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_rg_taskConfigLWTStatusOperation,             //配置LWT开关
    mk_rg_taskConfigLWTQosOperation,                //配置LWT Qos
    mk_rg_taskConfigLWTRetainOperation,             //配置LWT Retain
    mk_rg_taskConfigLWTTopicOperation,              //配置LWT topic
    mk_rg_taskConfigLWTPayloadOperation,            //配置LWT payload
    mk_rg_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_rg_taskConfigCAFileOperation,                //配置CA证书
    mk_rg_taskConfigClientCertOperation,            //配置设备证书
    mk_rg_taskConfigClientPrivateKeyOperation,      //配置私钥
        
#pragma mark - 过滤参数
    mk_rg_taskConfigRssiFilterValueOperation,                   //配置扫描RSSI过滤
    mk_rg_taskConfigFilterRelationshipOperation,                //配置扫描过滤逻辑
    mk_rg_taskConfigFilterMACAddressListOperation,           //配置MAC过滤规则
    mk_rg_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
};

