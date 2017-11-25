//
//  AppUpdatePublish.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/25.
//

import Foundation
import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct AppUpdatePublish {
    
    static func submit(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer{
                response.completed()
            }
            // 通过操作fileUploads数组来掌握文件上传的情况
            // 如果这个POST请求不是分段multi-part类型，则该数组内容为空
            // 创建路径用于存储已上传文件
            let webroot = Dir("./webroot")
            let fileDir = Dir(webroot.path + "movie_heaven/apps/MovieHeaven")
            LogFile.info("path:\(fileDir.path)")
            if !fileDir.exists {
                do {
                    try fileDir.create()
                    
                } catch {
                    LogFile.error("\(error)")
                    response.setBody(string: "\(error)");
                }
            }
            do {
                var appName: String?, bundleId: String?, version: String?, build: Int?, force = 0, description: String?, userName: String?, password: String?
                
                if let uploads = request.postFileUploads, uploads.count > 0 {
                    
                    for upload in uploads {
                        LogFile.info("upload:[\(upload.fieldName),\(upload.fileSize),\(upload.fieldValue),\(upload.fileName)]")
                        switch upload.fieldName {
                        case "package":
                            if upload.fileSize > 0 && upload.fileName.contains(string: ".ipa") {
                                let thisFile = File(upload.tmpFileName)
                                let _ = try thisFile.moveTo(path: fileDir.path + "MovieHeaven.ipa", overWrite: true)
                            } else {
                                response.setBody(string: "ipa error");
                                return;
                            }
                            
                        case "appName":
                            appName = upload.fieldValue

                        case "bundleId":
                            bundleId = upload.fieldValue
                        case "version":
                            version = upload.fieldValue
                        case "build":
                            build = Int(upload.fieldValue) ?? 0
                        case "force":
                            force = Int(upload.fieldValue) ?? 0
                        case "description":
                            description = upload.fieldValue
                        case "userName":
                            userName = upload.fieldValue
                        case "password":
                            password = upload.fieldValue
                        default:
                            
                            break
                        }
                        
                    }
                    
                    guard let build = build, let bundle_id = bundleId, let version = version, let password = password, let userName = userName else {
                        response.setBody(string: "params error");
                        return
                    }
                    if build < 1 || bundle_id.length < 1 || version.length < 1 {
                        response.setBody(string: "params error");
                        return
                    }
                    guard userName == "shiwenwen" && password == "Sww13156537832" else {
                        response.setBody(string: "Incorrect user name password");
                        return;
                    }
                    let update = AppUpdateModel(bundleId: bundle_id, build: build, version: version, appName: appName, update_time: Date(), forceUpdate: force, description: description)
                    let _ = try MySQLConnectionPool.execute{ connection -> QueryStatus in
                        
                        return try connection.query("insert into app_update_tbl set ?", [update]) as QueryStatus
                    }
                    response.setBody(string: "success");
                    pushNotification(description ?? "")
                    
                    
                }else{
                    response.setBody(string: "no data");
                }
            } catch  {
                LogFile.error("\(error)")
                response.setBody(string: "\(error)");
            }
            
            
        }
        
    }
    //MARK:
    fileprivate static func pushNotification(_ content: String) {
        let data: [String:Any] = [
            "platform": "ios",
            "audience": "all",
            "notification": [
                "ios": [
                    "alert": "观影天堂发布更新啦\n" + content,
                    "sound": "default",
                    "badge": "+1",
                    "extras": [
                        "target":"check_update",
                        "className":"Tools",
                        "method":"checkAPPUpdate",
                        "isClassMethod":"1"
                    ]
                ]
                
            ]
        ]
        JpushUtil.sendNotification(data) { (error, result) in
            if let error = error {
                LogFile.error("通知发送失败\(error)")
                
            } else{
                if let result = result {
                    if let resultError = result["error"] as? [String:Any] {
                        LogFile.error("通知发送失败:\(resultError["message"] as? String ?? "")")
                    }else {
                        LogFile.info("通知发送成功\(result)")
                    }
                } else {
                    
                    LogFile.error("未知错误")
                }
            }
        }
    }
    
}
