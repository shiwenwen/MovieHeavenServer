//
//  RequestHandleUtil.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//
import PerfectLogger
import Foundation
import PerfectHTTPServer
import PerfectHTTP
class RequestHandleUtil {
    
    /// 生成相应Json字典
    ///
    /// - Parameters:
    ///   - data: 需要返回的数据
    ///   - txt: 返回的TXT提示 默认 成功
    ///   - status: 返回的业务状态 默认 成功
    ///   - code: 响应码 默认 0000
    ///   - msg: 响应信息 默认 成功
    /// - Returns:Json字典
    static func responseJson(data:[String:Any?],txt:String? = HandleSuccessTxt,status:ResponseStatus? = .success, code:ResponseCode = .success,msg:String = ResponseSuccessMsg) -> [String:Any?] {
        
        var json:[String:Any] = [
            "code":code.rawValue,
            "msg":msg,
            ]
        
        if code == .success {
            var tempData = data
            tempData["txt"] = txt
            tempData["status"] = status?.rawValue
            json["data"] = tempData
        } else {
            json["data"] = nil
        }
        LogFile.info("response:\n\(json)")
        return json
    }
    
    /// 签名认证
    ///
    /// - Parameters:
    ///   - paramsString: 需要认证的json参数字符串
    ///   - sign: 签名串
    /// - Returns: 认证结果
    static func signatureVerification(paramsString:String, sign:String?) -> Bool{
        var paramsStr = paramsString
        guard sign != nil else {
            
            return false
            
        }
        if paramsString.count < 2 {
            return false
        }
        paramsStr.remove(at: paramsStr.startIndex)
        paramsStr.remove(at: paramsStr.index(before: paramsStr.endIndex))
        
        guard let range1 = paramsStr.range(of: "{") else {
            return false
        }
        paramsStr.removeSubrange(paramsStr.startIndex ..< range1.lowerBound)
        guard let range2 = paramsStr.range(of: "}", options: String.CompareOptions.backwards, range: nil, locale: nil) else {
            return false
        }
        paramsStr.removeSubrange(range2.upperBound ..< paramsStr.endIndex)
        let parStr = paramsStr.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: " ", with: "") + MD5_KEY
        
        guard let md5Byte = parStr.digest(.md5), let hexBytes = md5Byte.encode(.hex), let md5 = String(validatingUTF8:hexBytes) else {
            return false
        }
        LogFile.info("originString = \(parStr)---sign = \(md5)")
        if md5 != sign{
            
            return false
        }
        
        return true
    }
    
    /// session检查
    ///
    /// - Parameters:
    ///   - request: request
    ///   - response: response
    /// - Returns: uid
    static func sessionAuth(request: HTTPRequest, response:HTTPResponse) -> String? {
        guard let session = request.session else {
            LogFile.info("session不存在")
            do {
                try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .logonFailure, msg: "登录失效,请登录后操作"))
            } catch {
                
            }
            response.completed()
            return nil
            
        }
        if !session.isValid(request) || session.userid.isEmpty {
            LogFile.info("\(session)")
            LogFile.info("session失效或找不到对应userid")
            request.session!.idle = 0
            do {
                try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .logonFailure, msg: "登录失效,请登录后操作"))
            } catch {
                
            }
            response.completed()
            return nil
        }
        request.session!.touch()
        LogFile.info("session更新成功")
        return session.userid
        
    }
    /// postParams 转换json字典
    ///
    /// - Parameter postParams: postParams
    /// - Returns: json字典
    /// - Throws: JSONConvertible
    static func postParams2JsonDictionary(postParams: [(String, String)]) throws -> [String:Any?] {
        
        return try (postParams.first!.0 + postParams.first!.1).jsonDecode() as! [String:Any?]
    }
}
