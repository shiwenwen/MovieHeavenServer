//
//  Push.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/26.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct Push {
    /// 发布视频推送
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func sendVideoPush(data: [String:Any]) -> RequestHandler {
        return { request, response in
//            defer {
//                response.completed()
//            }
            //            已经在过滤器校验过，可以强制转换解包
            let json = try! RequestHandleUtil.postParams2JsonDictionary(postParams: request.postParams)
            let data = json["data"] as! [String:Any?]
            
            do {
                
                guard let videoId = data["videoId"] as? Int, let videoName = data["videoName"] as? String, let content = data["content"] as? String else {
                    
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "参数不完整", status:.defaulErrortStatus))
                    response.completed()
                    return
                }
                let data: [String:Any] = [
                    "platform": "ios",
                    "audience": "all",
                    "notification": [
                        "ios": [
                            "alert": content ,
                            "sound": "default",
                            "badge": "+1",
                            "extras": [
                                "target":"play",
                                "className":"AppDelegate",
                                "method":"toVideoDetail:",
                                "isClassMethod":"1",
                                "object":"\(videoId)",
                                "delay":"0.5"
                            ]
                        ]
                        
                    ]
                ]
                
                JpushUtil.sendNotification(data, completion: { (error, result) in
                    
                    defer {
                        response.completed()
                    }

                    if let error = error {
                        LogFile.error("通知发送失败\(error)")
                        let _ = try? response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "通知发送失败\(error)", status:.defaulErrortStatus))
                        
                    } else{
                        if let result = result {
                            if let resultError = result["error"] as? [String:Any] {
                                LogFile.error("通知发送失败:\(resultError["message"] as? String ?? "")")
                                let _ = try? response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "通知发送失败:\(resultError["message"] as? String ?? "")", status:.defaulErrortStatus))
                            }else {
                                LogFile.info("通知发送成功\(result)")
                                let _ = try? response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "发送成功"))
                            }
                        } else {
                            
                            LogFile.error("未知错误")
                            let _ = try? response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "位置错误", status:.defaulErrortStatus))
                        }
                    }
                })
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
                response.completed()
            }
        }
    }
}
