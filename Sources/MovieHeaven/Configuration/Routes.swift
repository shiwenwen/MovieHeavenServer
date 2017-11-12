//
//  Routes.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//
import PerfectHTTPServer
import PerfectLib
import PerfectHTTP

let BaseURL = "/movie_heaven/"
let APIV1 = BaseURL + "api/v1/"

func mainRoutes() -> [[String: Any]] {
    
    
    
    var routes: [[String: Any]] = [[String: Any]]()
    
    routes.append(["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
                   "documentRoot":"./webroot",
                   "allowRequestFilter":false,
                   "allowResponseFilters":true])
    
    
    
//------- Handler for Auth--------------------------------
    let auth = "auth/"
//
    routes.append(["method":"post", "uri":APIV1 + auth + "/login", "handler":Auth.login])
 
    
    return routes
}
