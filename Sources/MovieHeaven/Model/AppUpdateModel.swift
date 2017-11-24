//
//  AppUpdateModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/20.
//

import Foundation

import MySQL
import CMySQL
struct AppUpdateModel: QueryRowResultType, QueryParameterDictionaryType, ModelJson {
    let bundleId: String //包名
    let build: Int //构建版本
    let version: String //版本号
    let appName: String? //APP名称
    let update_time: Date //更新时间
    let forceUpdate: Int //是否强制更新
    let description: String? //更新描述
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> AppUpdateModel {
        return try AppUpdateModel(bundleId: r <| "bundle_id",
                                  build: r <| "build",
                                  version: r <| "version",
                                  appName: r <|? "app_name",
                                  update_time: r <| "update_time",
                                  forceUpdate: r <| "force_update",
                                  description: r <|? "description"
        )
        
    }
    
    // Use this model as a query paramter
    // See inserting example
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([:])
    }
    func toDictionary() -> [String : Any?] {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm";
        format.timeZone = TimeZone(abbreviation: "UTC") //实际时间应该CCT 这里是转换导致的 设置UTC是为了矫正
        return [
            "bundleId": bundleId,
            "build": build,
            "version": version,
            "appName": appName,
            "update_time": format.string(from: update_time),
            "forceUpdate": forceUpdate,
            "updateContent":description
            

        ]
        
    }
}
