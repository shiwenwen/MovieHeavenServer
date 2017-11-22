//
//  AppUpdate.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/20.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct AppUpdate {
    
    /// 检查更新
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func checkUpdate(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }

            
            do {
                guard let bundleId = request.param(name: "bundleId", defaultValue: ""), let build = Int(request.param(name: "build", defaultValue: "")!) else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                
                let rows: [AppUpdateModel] = try MySQLConnectionPool.execute{ connection in
                    
                    return try connection.query("select * from app_update_tbl where build = (select max(build) from app_update_tbl where bundle_id = ?)", [bundleId])
                }
                
                if rows.count > 0 {

                    let update = rows.first!
                    let needUpdate = update.build > build ? 1 : 0
                    try response.setBody(json: RequestHandleUtil.responseJson(data: ["need_update":needUpdate,"url":APP_UPDATE_RUL,"forceUpdate":update.forceUpdate,"description":update.description]))
                } else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:]))
                }
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
    
    /// 版本更新历史
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func updateHistory(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }
            
            
            do {
                guard let bundleId = request.param(name: "bundleId", defaultValue: ""), let pageNum = Int(request.param(name: "pageNum", defaultValue: "0")!), let pageSize = Int(request.param(name: "pageSize", defaultValue: "10")!) else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: HandleFailedTxt, status: .defaulErrortStatus))
                    return
                }
                
                let rows: [AppUpdateModel] = try MySQLConnectionPool.execute{ connection in
                    
                    return try connection.query("select * from app_update_tbl where bundle_id = ? order by build desc limit ?,?", [bundleId,pageNum * pageSize,pageSize])
                }
                var history = [[String:Any?]]()
                for update in rows {
                    history.append(update.toDictionary())
                }
                try response.setBody(json: RequestHandleUtil.responseJson(data: ["update_history":history]))
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
        }
        
    }
}

