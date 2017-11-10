//
//  Config.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//

import PerfectRequestLogger
import PerfectLogger
import PerfectLib
import MySQLStORM
import PerfectCrypto
import PerfectSession
import PerfectHTTPServer
/// 配置服务
func configServer() {
    // 初始化加密
    PerfectCrypto.isInitialized = true
    configLogFile()
    configWebroot()
    configMySQL()
    configSession()
    
    
    
}

/// 启动服务
func startServer() {
    // Configure Server
    let confData: [String:[[String:Any]]] = [
        "servers": [
            [   "name":"www.gallifrey.cn",
                "port":SERVER_PORT,
                "filters":filters()
            ]
        ]
    ]
    
    
    do {
        // Launch the servers based on the configuration data.
        try HTTPServer.launch(configurationData: confData)
        
        
    } catch let error{
        LogFile.error("服务启动失败\(error)")
        
    }

}
/// 配置LogFile
fileprivate func configLogFile() {
    
    RequestLogFile.location = "./MovieHeaven.log"
}
fileprivate func configSession() {
    
    // 会话名称
    // 这个名称也会成为浏览器cookie的名称
    SessionConfig.name = "PerfectSession"
    // 允许处于零活动连接的时间限制，单位是秒
    // 86400 秒表示一天。
    SessionConfig.idle = 86400 * 30
    // 可选项，设置 Cookie作用域
    SessionConfig.cookieDomain = "localhost"
}

/// 配置webroot
///
/// - Returns: webroot路径
@discardableResult
fileprivate func configWebroot() -> String {
    let webroot = Dir("./webroot")
    if !webroot.exists {
        do{
            try webroot.create()
            LogFile.error("创建./webroot成功")
        }catch{
            LogFile.error("创建./webroot失败:\(error)")
        }
        
    }
    LogFile.error("./webroot已经存在")
    return "./webroot"
}

/// 配置MySQL
fileprivate func configMySQL() {
    
    MySQLConnector.host = SQL_HOST
    MySQLConnector.username = SQL_USER
    MySQLConnector.password = SQL_PASSWORD
    MySQLConnector.port = SQL_PORT
    MySQLConnector.database = SQL_DB
}
