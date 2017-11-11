//
//  File.swift
//  WolfVideo
//
//  Created by 石文文 on 2017/4/27.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger
/// 请求校验过滤器
struct RequestCheckFilter: HTTPRequestFilter {
    init(){}
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        LogFile.debug("Request:\(request.serverName + request.uri)\nMethod:\(request.method)\ncontentType:\(request.header(.contentType) ?? "")")
        
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
        //校验参数格式
        //            LogFile.debug("postParams:\(request.postParams)")
        guard let params = request.postParams.first,let jsonDecode = try? params.0.jsonDecode(),let json = jsonDecode as? [String:Any] else {
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
        LogFile.debug("Params:\(json)")
        //data参数校验
        guard let _ = json["data"] as? [String:Any] else{
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
        guard RequestHandleUtil.signatureVerification(paramsString: params.0, sign: json["sign"] as? String) else{
            let body = RequestHandleUtil .responseJson(data:[:], txt: nil, status:nil, code:.signError, msg: "签名错误")
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
        callback(.continue(request, response))
        
    }
}
