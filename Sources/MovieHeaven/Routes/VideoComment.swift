//
//  VideoComment.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/23.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct VideoComment {
    /// 添加评论
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func addComment(data: [String:Any]) -> RequestHandler {
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
                
                guard let videoId = data["videoId"] as? Int, let score = data["score"] as? Int else {
                    
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "参数不完整", status:.defaulErrortStatus))
                    
                    return
                }
            
                let commentModel = CommentModel(cmid: 0, videoId: videoId, source_type: data["sourceType"] as? String, source_name: data["sourceName"] as? String, part_name: data["partName"] as? String, vid: data["vid"] as? Int, create_time: Date(), content: data["content"] as? String, uid: uid, video_name: data["videoName"] as? String, score: score)
                
                let status = try MySQLConnectionPool.execute{ connection in
                    
                    return try connection.query("insert into comment_tbl set ?", [commentModel]) as QueryStatus
                }
                if status.affectedRows > 0 {
                    //评论成功
                    let counts:[CountModel] = try MySQLConnectionPool.execute{ connection in
                        try connection.query("select count(1) as num from comment_tbl where videoId=? and uid=?",[videoId,uid])
                    }
                    let num = counts.first!.num
                    LogFile.info("已经有\(num)条评论")
                    var accumulated_points = 0
                    //根据是否多次评论增加积分
                    if num > 1 {
                        let timeinterval = Int(Date().timeIntervalSince1970)
                        //多次评论
                         accumulated_points = timeinterval % 2 == 0 ? 1 : 0
                        let _ = try MySQLConnectionPool.execute{ connection in
                            try connection.query("update user_tbl set accumulated_points=accumulated_points+\(accumulated_points) where id=?", [uid])
                        }
                    } else {
                        //第一次评论
                        accumulated_points = 5
                       let _ = try MySQLConnectionPool.execute{ connection in
                            try connection.query("update user_tbl set accumulated_points=accumulated_points+\(accumulated_points) where id=?", [uid])
                        }
                    }
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "评论成功,增加了\(accumulated_points)积分", status: .success))
                    
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                }
                
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
    }
    /// 获取评论列表
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func getComments(data: [String:Any]) -> RequestHandler {
        return { request, response in
            defer {
                response.completed()
            }
            
            do {
                guard let pageNum = Int(request.param(name: "pageNum", defaultValue: "0")!), let pageSize = Int(request.param(name: "pageSize", defaultValue: "10")!), let videoId = request.param(name: "videoId", defaultValue: "") else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                
                let rows: [CommentListModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("SELECT comment_tbl.*,user_tbl.nickName,user_tbl.avatar FROM comment_tbl LEFT JOIN user_tbl ON comment_tbl.uid = user_tbl.id WHERE comment_tbl.videoId = ? ORDER BY comment_tbl.create_time DESC LIMIT ?,?;", [videoId,pageNum * pageSize, pageSize])
                }
                var comments = [[String:Any?]]()
                for comment in rows {
                    comments.append(comment.toDictionary())
                }
                try response.setBody(json: RequestHandleUtil.responseJson(data: ["comments":comments]))
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
    }


}
