//
//  VideoDetail.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/17.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct VideoDetail {
    /// 获取视频历史状态和收藏状态
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func getState(data: [String:Any]) -> RequestHandler {
        
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
                
                let rows: [VideoStateModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("SELECT history_tbl.*,collect_tbl.cid FROM history_tbl LEFT JOIN collect_tbl on history_tbl.videoId = collect_tbl.videoId AND history_tbl.uid = collect_tbl.uid WHERE history_tbl.uid = ? AND history_tbl.videoId = ?;", [uid,videoId])
                }
                if rows.count > 0 {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["state":rows.first!.toDictionary()]))
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:]))
                }
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
}
