//
//  History.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/15.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct History {
    
    /// 添加历史
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func addHistory(data: [String:Any]) -> RequestHandler {
        return { request, response in
            defer {
                response.completed()
            }
            guard let uid = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            //            已经在过滤器校验过，可以强制转换解包
            let json = try! RequestHandleUtil.postParams2JsonDictionary(postParams: request.postParams)
            let data = json["data"] as! [String:Any?]
            
            do {
                
                guard let videoId = data["videoId"] as? Int, let vid = data["vid"] as? Int, let sourceType = data["sourceType"] as? String, let sourceName = data["sourceName"] as? String, let partName = data["partName"] as? String  else {
                    
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "参数不完整", status:.defaulErrortStatus))
                    
                    return
                }
                
                let rows: [HistoryModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from history_tbl where videoId=? and uid=?", [videoId,uid])
                }
                if rows.count < 1 {
//                    新加历史
                    let history = HistoryModel(hid: 0, videoId: videoId, videoName: data["videoName"] as? String, videoStatus: data["videoStatus"] as? String, score: data["score"] as? String, videoType: data["videoType"] as? String, actors: data["actors"] as? String, uid: uid, img: data["img"] as? String, sourceType: sourceType, sourceName: sourceName, partName: partName, vid: vid, playingTime: data["playingTime"] as? Double ?? 0.0, isFinish: data["isFinish"] as? Int ?? 0, update_time: Date())
                    
                    let status = try MySQLConnectionPool.execute{ connection in
                        
                        return try connection.query("insert into history_tbl set ?", [history]) as QueryStatus
                    }
                    if status.affectedRows > 0 {
//                        新历史加入成功
                        try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "历史添加成功", status: .success))
                    } else {
                        try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    }
                    
                } else{
//                    更新历史
                    let hid = rows.first!.hid
                    let params = [sourceType,sourceName,partName,vid,data["playingTime"] as? Double ?? 0.0,data["isFinish"] as? Int ?? 0,Date(),hid] as [QueryParameter]
                    
                    let status = try MySQLConnectionPool.execute{ coonection in
                        try coonection.query("update history_tbl set source_type=?,source_name=?,part_name=?,vid=?,playing_time=?,is_finish=?,update_time=? where hid=?",params)
                    }
                    
                    if  status.affectedRows > 0{
                        //                    更新成功
                        try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "历史更新成功", status: .success))
                        
                    } else {
                        //                    更新失败
                        try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "历史未更新", status: .success))
                    }
                }
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
    }
    /// 获取历史状态
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func getHistory(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }
            guard let uid = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            
            
            do {
                guard let videoId = Int(request.param(name: "videoId", defaultValue: "0")!) else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                
                let rows: [HistoryModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from history_tbl where videoId=? and uid=?", [videoId,uid])
                }
                if rows.count > 0 {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["history":rows.first!.toDictionary()]))
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:]))
                }
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
    /// 获取历史列表
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func getHistoryList(data: [String:Any]) -> RequestHandler {
        return { request, response in
            defer {
                response.completed()
            }
            guard let uid = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            
            
            do {
                guard let pageNum = Int(request.param(name: "pageNum", defaultValue: "0")!), let pageSize = Int(request.param(name: "pageSize", defaultValue: "10")!) else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                
                let rows: [HistoryModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from history_tbl where uid=? order by update_time desc limit ?,?;", [uid,pageNum * pageSize,pageSize])
                }
                var historyList = [[String:Any?]]()
                for history in rows {
                    historyList.append(history.toDictionary())
                }
                try response.setBody(json: RequestHandleUtil.responseJson(data: ["historyList":historyList]))
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
    }
    
}
