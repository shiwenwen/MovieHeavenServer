//
//  Filter404.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//
import PerfectHTTP
import PerfectLib

func custom404(data: [String:Any]) throws -> HTTPResponseFilter {
    
    struct Filter404: HTTPResponseFilter {
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setBody(string: "404 Not Found")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                
            }
            return callback(.continue)
        }
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
    }
    return Filter404()
    
}
