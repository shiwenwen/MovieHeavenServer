//
//  Collect.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/14.
//
import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct Collect {
    
    /// 添加收藏
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func addtoCollection(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }
            guard let uid = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            let json = try! RequestHandleUtil.postParams2JsonDictionary(postParams: request.postParams)
            let data = json["data"] as! [String:Any?]
            
            do {
                guard let videoId = data["videoId"] as? Int else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                let rows: [CollectModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from collect_tbl where videoId=? and uid=?;", [videoId,uid])
                }
                guard rows.isEmpty else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "您已收藏过该视频了", status: .b0010))
                    return
                }
                let collect = CollectModel(cid: 0, videoId: videoId, videoName: data["videoName"] as? String, videoStatus: data["videoStatus"] as? String, score: data["score"] as? String, videoType: data["videoType"] as? String, actors: data["actors"] as? String, uid: uid, create_time: Date())
                
                let status = try MySQLConnectionPool.execute{ connection -> QueryStatus in
                    
                    return try connection.query("insert into collect_tbl set ?", [collect]) as QueryStatus
                }
                if status.affectedRows > 0 {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["cid":status.insertedID], txt: "收藏成功", status: .success))
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                }
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
    
    /// 取消收藏
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func cancelCollection(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }
            guard let _ = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            let json = try! RequestHandleUtil.postParams2JsonDictionary(postParams: request.postParams)
            let data = json["data"] as! [String:Any?]
            do {
                guard let cid = data["cid"] as? Int else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                let status = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("delete from collect_tbl where cid=?;", [cid])
                }
                if status.affectedRows > 0 {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "收藏已取消", status: .success))
                }else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "该收藏不存在", status: .defaulErrortStatus))
                }
            } catch  {
                
            }
        }
    }
    
    /// 收藏列表
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func getCollectionList(data: [String:Any]) -> RequestHandler {
        
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
                
                let rows: [CollectModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from collect_tbl where uid=? order by create_time desc limit ?,?;", [uid,pageNum * pageSize,pageSize])
                }
                var collects = [[String:Any?]]()
                for collect in rows {
                    collects.append(collect.toDictionary())
                }
                try response.setBody(json: RequestHandleUtil.responseJson(data: ["collects":collects]))

            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
    
    /// 检查收藏状态
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func checkCollectionState(data: [String:Any]) -> RequestHandler {
        
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
                
                let rows: [CollectModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from collect_tbl where videoId=? and uid=?", [videoId,uid])
                }
                if rows.count > 0 {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["isCollected": true,"cid": rows.first!.cid]))
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["isCollected": false]))
                }
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
    
}
