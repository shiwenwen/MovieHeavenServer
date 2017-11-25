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
    //登录
    routes.append(["method":"post", "uri":APIV1 + auth + "/login", "handler":Auth.login])
    //退出登录
    routes.append(["method":["get", "post"], "uri":APIV1 + auth + "/sign_out", "handler":Auth.signOut])
//------- Handler for User --------------------------------
    let user = "user/"
    //获取用户信息
    routes.append(["method":["get", "post"], "uri":APIV1 + user + "/info", "handler":User.getUserInfo])

//------- Handler for Collect --------------------------------
    let collect = "collect/"
    //收藏
    routes.append(["method":"post", "uri":APIV1 + collect + "/add", "handler":Collect.addtoCollection])
    //取消收藏
    routes.append(["method":"post", "uri":APIV1 + collect + "/cancel", "handler":Collect.cancelCollection])
    //收藏列表
    routes.append(["method":"get", "uri":APIV1 + collect + "/get_collection_list", "handler":Collect.getCollectionList])
    //检查收藏状态
    routes.append(["method":"get", "uri":APIV1 + collect + "/check", "handler":Collect.checkCollectionState])
    
//------- Handler for history --------------------------------
    let history = "history/"
    //添加历史
    routes.append(["method":"post", "uri":APIV1 + history + "/add", "handler":History.addHistory])
    //获取历史列表
    routes.append(["method":"get", "uri":APIV1 + history + "/get_history_list", "handler":History.getHistoryList])
    //获取视频历史状态
    routes.append(["method":"get", "uri":APIV1 + history + "/get_history", "handler":History.getHistory])
    //删除历史
    routes.append(["method":"post", "uri":APIV1 + history + "/delete_history", "handler":History.deleteHistory])
//------- Handler for videoDetail --------------------------------
    let videoDetail = "video_detail/"
    //获取视频收藏 历史状态
    routes.append(["method":"get", "uri":APIV1 + videoDetail + "/state", "handler":VideoDetail.getState])
    
//------- Handler for AppUpdate --------------------------------
    let appUpdate = "app_update/"
    //检查更新
    routes.append(["method":"get", "uri":APIV1 + appUpdate + "/check", "handler":AppUpdate.checkUpdate])
    //更新历史
    routes.append(["method":"get", "uri":APIV1 + appUpdate + "/history", "handler":AppUpdate.updateHistory])
    
//------- Handler for VideoComment --------------------------------
    let videoComment = "video_comment"
    //添加评论
    routes.append(["method":"post", "uri":APIV1 + videoComment + "/add_comment", "handler":VideoComment.addComment])
    //评论列表
    routes.append(["method":"get", "uri":APIV1 + videoComment + "/comments", "handler":VideoComment.getComments])
    
//    -------------- 管理后台相关-------------
    
    let management = "management"
//发布APP更新
    routes.append(["method":"post", "uri":APIV1 + management + "/app_update_publish/submit", "handler":AppUpdatePublish.submit])
    
    
    
    return routes
}
