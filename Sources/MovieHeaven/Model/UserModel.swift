//
//  UserModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/11.
//
import MySQL
import CMySQL
import Foundation

struct UserModel: QueryRowResultType, QueryParameterDictionaryType {
    let uid: Int
    let qq_unionid: String
    let nickName: String?
    let avatar: String?
    let gender: String?
//    let qq_openid: String
    let create_time: Date
    
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> UserModel {
        return try UserModel(
            uid: r <| "id", // as index
            qq_unionid: r <| 1, // nullable field,
            nickName: r <|? "nickName", // as field name
            avatar: r <|? 3,
            gender: r <|? "gender",
            create_time: r <| "create_time" // string enum type
        )
    }
    
    // Use this model as a query paramter
    // See inserting example
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            //"id": // auto increment
            "qq_unionid": qq_unionid,
            "nickName": nickName,
            "avatar": avatar,
//            "create_time": create_time,
            "gender":gender
            ])
    }
    
}
