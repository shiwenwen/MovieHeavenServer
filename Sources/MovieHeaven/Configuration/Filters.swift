//
//  Filters.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//


import PerfectHTTPServer
import PerfectRequestLogger
import PerfectSession
import PerfectSessionMySQL
func filters() -> [[String: Any]] {
    
    
    var filters: [[String: Any]] = [[String: Any]]()
    filters.append(["type":"response","priority":"high","name":PerfectHTTPServer.HTTPFilter.contentCompression])
//    filters.append(["type":"request","priority":"high","name":RequestLogger.filterAPIRequest])
//    filters.append(["type":"response","priority":"low","name":RequestLogger.filterAPIResponse])
    
    // added for sessions
//    filters.append(["type":"request","priority":"high","name":SessionMemoryFilter.filterAPIRequest])
//    filters.append(["type":"response","priority":"row","name":SessionMemoryFilter.filterAPIResponse])

    filters.append(["type":"request","priority":"high","name":SessionMySQLFilter.filterAPIRequest])
    filters.append(["type":"response","priority":"row","name":SessionMySQLFilter.filterAPIResponse])
    
//    added for request response
    filters.append(["type":"request","priority":"high","name":FilterHttp.requestCheckFilter])
    filters.append(["type":"response","priority":"high","name":FilterHttp.responseCheckFilter])
    
    
//    add for custom
    filters.append(["type":"response","priority":"high","name":custom404])
    
    return filters
}
