//
//  CurlUtil.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/25.
//

import Foundation
import PerfectCURL
import PerfectLogger
import PerfectCrypto
typealias successCallback = (_ response: CURLResponse,_ jsonData:[String:Any?]) -> Void
typealias failureCallback = (_ error: Error) -> Void

struct CurlUtil {
    
    /// CURL POST application/json
    ///
    /// - Parameters:
    ///   - url: url
    ///   - headers: 请求头
    ///   - json: 数据
    ///   - success: 成功回到
    ///   - failuer: 失败回调
    /// - Returns: 请求request对象
    @discardableResult
    static func PostRequest(url:String,headers:[CURLRequest.Option],json:[String:Any?],success: @escaping successCallback, failuer: @escaping failureCallback) -> CURLRequest? {
        LogFile.info("CURL POST:\nurl:\(url)")
        
        do {
            let postJson = try json.jsonEncodedString()
            let options = headers + [.postString(postJson)]
            let request = CURLRequest(url, options: options)
            LogFile.info("params:\n\(postJson)")
            request.perform {
                confirmation in
                do {
                    let response = try confirmation()
                    let json: [String:Any] = response.bodyJSON
                    LogFile.info("response:\n\(json)")
                    success(response,json)
                } catch let error as CURLResponse.Error {
                    LogFile.error("出错，响应代码为： \(error.response.responseCode)")
                } catch {
                    LogFile.error("致命错误： \(error)")
                    failuer(error)
                }
            }
            
        } catch  {
            failuer(error)
        }
        return nil
    }
}


