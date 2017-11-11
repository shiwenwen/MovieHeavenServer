//
//  ResponseCheckFilter.swift
//  WolfVideo
//
//  Created by 石文文 on 2017/4/27.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger
#if os(Linux)
#else
import Foundation
#endif

struct ResponseCheckFilter: HTTPResponseFilter {
    init(){}
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        
        if let body = String(bytes: response.bodyBytes, encoding: .utf8) {
            LogFile.debug("response:" + body)
        }else{
            LogFile.debug("response:" + "解析失败")
        }
        callback(.continue)

        
    }
    
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        
        callback(.continue)
    }
}
