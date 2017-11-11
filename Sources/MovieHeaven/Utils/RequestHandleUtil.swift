//
//  RequestHandleUtil.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//
import PerfectLogger

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
    class func responseJson(data:[String:Any?],txt:String? = HandleSuccessTxt,status:ResponseStatus? = .success, code:ResponseCode = .success,msg:String = ResponseSuccessMsg) -> [String:Any?] {
        
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
        
        return json
    }
    
    /// 签名认证
    ///
    /// - Parameters:
    ///   - paramsString: 需要认证的json参数字符串
    ///   - sign: 签名串
    /// - Returns: 认证结果
    class func signatureVerification(paramsString:String, sign:String?) -> Bool{
        var paramsString = paramsString
        guard sign != nil else {
            
            return false
            
        }
        if paramsString.count < 2 {
            return false
        }
        paramsString.remove(at: paramsString.startIndex)
        paramsString.remove(at: paramsString.index(before: paramsString.endIndex))
        
        guard let range1 = paramsString.range(of: "{") else {
            return false
        }
        paramsString.removeSubrange(paramsString.startIndex ..< range1.lowerBound)
        guard let range2 = paramsString.range(of: "}", options: String.CompareOptions.backwards, range: nil, locale: nil) else {
            return false
        }
        paramsString.removeSubrange(range2.upperBound ..< paramsString.endIndex)
        guard let md5Byte = (paramsString + MD5_KEY).digest(.md5), let hexBytes = md5Byte.encode(.hex), let md5 = String(validatingUTF8:hexBytes) else {
            return false
        }
        LogFile.info("originString = \(paramsString)---sign = \(md5)")
        if md5 != sign{
            
            return false
        }
        
        return true
    }
    
}
