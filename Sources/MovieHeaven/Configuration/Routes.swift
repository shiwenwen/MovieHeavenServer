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
    
    
    
//------- Handler for Auth --------------------------------
    let auth = "auth/"

    routes.append(["method":"post", "uri":APIV1 + auth + "/login", "handler":Auth.login])
    routes.append(["method":["get", "post"], "uri":APIV1 + auth + "/sign_out", "handler":Auth.signOut])
//------- Handler for User --------------------------------
    let user = "user/"
    routes.append(["method":["get", "post"], "uri":APIV1 + user + "/info", "handler":User.getUserInfo])

//------- Handler for Collect --------------------------------
    let collect = "collect/"
    routes.append(["method":"post", "uri":APIV1 + collect + "/add", "handler":Collect.addtoCollection])
    routes.append(["method":"post", "uri":APIV1 + collect + "/cancel", "handler":Collect.cancelCollection])
    routes.append(["method":"get", "uri":APIV1 + collect + "/get_collection_list", "handler":Collect.getCollectionList])
    routes.append(["method":"get", "uri":APIV1 + collect + "/check", "handler":Collect.checkCollectionState])
    
//------- Handler for history --------------------------------
    let history = "history/"
    routes.append(["method":"post", "uri":APIV1 + history + "/add", "handler":History.addHistory])
    routes.append(["method":"get", "uri":APIV1 + history + "/get_history_list", "handler":History.getHistoryList])
    routes.append(["method":"get", "uri":APIV1 + history + "/get_history", "handler":History.getHistory])
    routes.append(["method":"post", "uri":APIV1 + history + "/delete_history", "handler":History.deleteHistory])
//------- Handler for videoDetail --------------------------------
    let videoDetail = "video_detail/"
    routes.append(["method":"get", "uri":APIV1 + videoDetail + "/state", "handler":VideoDetail.getState])
    
//------- Handler for AppUpdate --------------------------------
let appUpdate = "app_update/"
routes.append(["method":"get", "uri":APIV1 + appUpdate + "/check", "handler":AppUpdate.checkUpdate])

    return routes
}
