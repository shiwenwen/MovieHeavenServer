//
//  Filters.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//


import PerfectHTTPServer
import PerfectRequestLogger
import PerfectSession

func filters() -> [[String: Any]] {
    
    
    var filters: [[String: Any]] = [[String: Any]]()
    filters.append(["type":"response","priority":"high","name":PerfectHTTPServer.HTTPFilter.contentCompression])
    filters.append(["type":"request","priority":"high","name":RequestLogger.filterAPIRequest])
    filters.append(["type":"response","priority":"low","name":RequestLogger.filterAPIResponse])
    
    // added for sessions
    filters.append(["type":"request","priority":"high","name":SessionMemoryFilter.filterAPIRequest])
    filters.append(["type":"response","priority":"row","name":SessionMemoryFilter.filterAPIResponse])
    
    
//    add for custom
    filters.append(["type":"response","priority":"high","name":custom404])
    
    return filters
}
