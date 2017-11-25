//
//  JpushUtil.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/25.
//

let JPUSH_SEND_URL = "https://bjapi.push.jiguang.cn/v3/push"
let JPUSH_KEY = "f050fe4dc1ff9f4772dc2e89"
let JPUSH_SERCRET = "87d3a40c77aa2532ae602768"

import Foundation
import PerfectCURL
import PerfectLogger
import PerfectCrypto

struct JpushUtil {
    
    enum platform: String {
        case ios = "ios"
        case android = "android"
        case all = "all"
    }
    
    /// 发送通知
    ///
    /// - Parameters:
    ///   - notification: 消息体
    ///   - completion: 完成回调
    static func sendNotification(_ notification:[String:Any], completion:@escaping (_ error: Error?,_ response: [String:Any?]?) -> Void) -> Void {
        var mutableNotification = notification
        let encode = (JPUSH_KEY + ":" + JPUSH_SERCRET).encode(.base64) ?? [0]
        let authorization = "Basic " + (String(validatingUTF8: encode) ?? "")
        var apns_production = true
        
        #if os(Linux)
            apns_production = true
        #else
            apns_production = false
        #endif
        let options = [
            "apns_production": apns_production
        ]
        mutableNotification["options"] = options
        let headers = [CURLRequest.Option.addHeader(.authorization, authorization)]
        CurlUtil.PostRequest(url: JPUSH_SEND_URL, headers: headers, json: mutableNotification, success: { (response, jsonData) in
            completion(nil, jsonData)
        }) { (error) in
            completion(error, nil)
        }
        
    }
}
/*
func pushTest() {
    let data: [String:Any] = [
        "platform": "ios",
        "audience": [
            "alias": ["100"]
        ],
        "notification": [
            "ios": [
                "alert": "哈喽, 石文文",
                "sound": "default",
                "badge": "+1",
                "extras": [:]
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
 */
