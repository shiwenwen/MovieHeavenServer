//
//  Auth.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//
import PerfectHTTP
import PerfectLib
import PerfectLogger
import Foundation
import MySQL
import CMySQL
class Auth {
    
    /// 登录
    ///
    /// - Parameter data: data
    /// - Returns: hander
    static func login(data: [String:Any]) -> RequestHandler {
        return { request,response in
            defer {
                response.completed()
            }
//            已经在过滤器校验过，可以强制转换解包
            let json = try! RequestHandleUtil.postParams2JsonDictionary(postParams: request.postParams)
            let data = json["data"] as! [String:Any?]
            let nickName = data["nickName"] as? String
            let avatar = data["avatar"] as? String
            let gender = data["gender"] as? String
            
            do {
                guard let qq_unionid = data["qq_unionid"] as? String/*,let qq_openid = data["qq_openid"]*/ else {
                    try response.setBody(json: RequestHandleUtil.responseJson(data: [:],txt: "qq_unionid qq_openid 不能为空", status:ResponseStatus.defaulErrortStatus))
                    return
                }
                
                let rows: [UserModel] = try MySQLConnectionPool.execute{ connection in
                    let params:(String) = (qq_unionid)
                    return try connection.query("select * from user_tbl where qq_unionid=?;", build(params))
                }
                
                guard rows.count > 0 else {
//                   注册
                    let user = UserModel(uid: 0, qq_unionid: qq_unionid, nickName: nickName, avatar: avatar, gender: gender, create_time: Date())
                    let status = try MySQLConnectionPool.execute{ connection -> QueryStatus in
                        
                        return try connection.query("insert into user_tbl set ?", [user]) as QueryStatus
                    }
                    let userId = status.insertedID
                    let userInfo: [String: Any?] = ["uid":userId,"nickName":user.nickName,"avatar":user.avatar,"gender":user.gender]
                    let body = RequestHandleUtil.responseJson(data: ["userInfo":userInfo], txt: "登录成功")
                    try response.setBody(json: body)
                    return
                }
//                登录 更新信息

                let user = rows.first!
                
                let status = try MySQLConnectionPool.execute{ coonection in
                    try coonection.query("update user_tbl set nickName=?,avatar=?,gender=? where id=?", [nickName,avatar,gender,user.uid])
                }
                
                if  status.affectedRows > 0{
//                    更新成功返回新信息
                    let userInfo: [String: Any?] = ["uid":user.uid,"nickName":nickName,"avatar":avatar,"gender":gender]
                    let body = RequestHandleUtil.responseJson(data: ["userInfo":userInfo])
                    try response.setBody(json: body)
                } else {
//                    更新失败返回旧信息
                    let userInfo: [String: Any?] = ["uid":user.uid,"nickName":user.nickName,"avatar":user.avatar,"gender":user.gender]
                    let body = RequestHandleUtil.responseJson(data: ["userInfo":userInfo])
                    try response.setBody(json: body)
                }
                
                
            } catch  {
                LogFile.error("\(error)")
                let _ = try? response.setBody(json:RequestHandleUtil.responseJson(data: [:], txt: nil, status: nil, code: .defaultError, msg: RequestFailed))
            }
            
        }
        
    }
}
