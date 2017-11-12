//
//  FilterHttp.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/11.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger
import Foundation

struct FilterHttp {
    static func requestCheckFilter(data: [String:Any]) throws -> HTTPRequestFilter {
        /// 请求校验过滤器
        struct RequestCheckFilter: HTTPRequestFilter {
            func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
                LogFile.debug("\(Date()) Request:\(request.serverName + request.uri)\nMethod:\(request.method)\ncontentType:\(request.header(.contentType) ?? "")")
                
                guard request.method == .post else {
                    //GET
                    LogFile.debug("params:\(request.params())")
                    callback(.continue(request, response))
                    return
                }
                //POST
                //如果是文件上传 则不过滤
                if let contentType = request.header(.contentType),contentType.hasPrefix("multipart/form-data") {
                    callback(.continue(request, response))
                    return;
                }
//                请求只接受 application/json 类型
                if let contentType = request.header(.contentType),contentType.hasPrefix("application/json") == false {
                    let body = RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .requestParamsError, msg: "请求参数格式错误")
                    LogFile.debug("\(body)")
                    do {
                        try response.setBody(json: body)
                    } catch {
                        LogFile.error("\(error)")
                    }
                    response.completed()
                    callback(.halt(request, response))
                    return;
                }
                
                //校验参数格式
//                LogFile.debug("postParams:\(request.postParams)")
                guard let params = request.postParams.first,let jsonDecode = try? (params.0+params.1).jsonDecode(),let json = jsonDecode as? [String:Any?] else {
                    let body = RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .requestParamsError, msg: "请求参数格式错误")
                    LogFile.debug("\(body)")
                    do {
                        try response.setBody(json: body)
                    } catch {
                        LogFile.error("\(error)")
                    }
                    response.completed()
                    callback(.halt(request, response))
                    
                    return
                }
                LogFile.debug("Params:\n\(json)")
                //data参数校验
                guard let _ = json["data"] as? [String:Any?] else{
                    let body = RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .requestParamsError, msg: "请求参数格式错误")
                    LogFile.debug("\(body)")
                    do {
                        try response.setBody(json: body)
                    } catch {
                        LogFile.error("\(error)")
                    }
                    
                    response.completed()
                    callback(.halt(request, response))
                    return
                }
                
                //签名校验
//                guard RequestHandleUtil.signatureVerification(paramsString: params.0, sign: json["sign"] as? String) else{
//                    let body = RequestHandleUtil .responseJson(data:[:], txt: nil, status:nil, code:.signError, msg: "签名错误")
//                    LogFile.debug("\(body)")
//                    do {
//                        try response.setBody(json: body)
//                    } catch {
//                        LogFile.error("\(error)")
//                    }
//                    response.completed()
//                    callback(.halt(request, response))
//                    return
//                }
                callback(.continue(request, response))
                
            }
        }
        
        return RequestCheckFilter()
    }
    
    static func responseCheckFilter(data: [String:Any]) throws -> HTTPResponseFilter {
        
        struct ResponseCheckFilter: HTTPResponseFilter {
            func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
                
//                if let body = String(bytes: response.bodyBytes, encoding: .utf8) {
//                    LogFile.debug("response:" + body)
//                }else{
//                    LogFile.debug("response:" + "解析失败")
//                }
                callback(.continue)
                
            }
            
            func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
                
                callback(.continue)
            }
        }
        return ResponseCheckFilter()
    }
    
}
