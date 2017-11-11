//
//  User.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/10.
//
import MySQLStORM
import StORM
import Foundation

/// 用户表 ORM
class UserORM: MySQLStORM {
    var uid: Int = 100
    var qq_unionid: String = ""
    var qq_openid: String = ""
    var nickName: String?
    var avatar: String?
    var create_date: Date = Date()
    
    override open func table() -> String {
        return "user_table"
    }
    
    override func to(_ this: StORMRow) {
        uid = this.data["uid"] as! Int
        qq_unionid = this.data["qq_unionid"] as! String
        qq_openid = this.data["qq_openid"] as! String
        nickName = this.data["email"] as? String
        avatar = this.data["avatar"] as? String
        create_date = this.data["create_date"] as! Data
    }
    
    func rows() -> [UserORM] {
        var rows = [UserORM]()
        for i in 0..<self.results.rows.count {
            let row = UserORM()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
