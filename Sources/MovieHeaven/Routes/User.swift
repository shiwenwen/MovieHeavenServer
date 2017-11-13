//
//  User.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/13.
//

import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
struct User {
    
    /// 获取用户信息
    ///
    /// - Parameter data: data
    /// - Returns: RequestHandler
    static func getUserInfo(data: [String:Any]) -> RequestHandler {
        
        return { request, response in
            defer {
                response.completed()
            }
            guard let uid = RequestHandleUtil.sessionAuth(request: request, response: response) else {
                return
            }
            do {
                let rows: [UserModel] = try MySQLConnectionPool.execute{ connection in
                    return try connection.query("select * from user_tbl where id=?;", [uid])
                }
                guard !rows.isEmpty else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:], txt: "该用户不存在", status: ResponseStatus.defaulErrortStatus))
                    return
                }
                let user = rows.first!
                let info: [String: Any?] = ["nickName":user.nickName,"avatar":user.avatar,"gender":user.gender]
                try response.setBody(json:RequestHandleUtil.responseJson(data: ["userInfo":info]))
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
            
        }
        
    }
    
}
