//
//  CollectModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/14.
//

import Foundation
import MySQL
import CMySQL
struct CollectModel: QueryRowResultType, QueryParameterDictionaryType, ModelJson {
    
    let cid: Int
    let videoId: Int
    let videoName: String?
    let videoStatus: String?
    let score: String?
    let videoType: String?
    let actors: String?
    let uid: Int
    let img: String?
    let create_time: Date
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> CollectModel {
        return try CollectModel(
            cid: r <| "cid",
            videoId: r <| "videoId",
            videoName: r <|? "video_name",
            videoStatus: r <|? "video_status",
            score: r <|? "score",
            videoType: r <|? "video_type",
            actors: r <|? "actors",
            uid: r <| "uid",
            img: r <|? "img",
            create_time: r <| "create_time" // string enum type
        )
    }
    
    // Use this model as a query paramter
    // See inserting example
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            //"cid": // auto increment
            "videoId": videoId,
            "video_name": videoName,
            "video_status": videoStatus,
            "score": score,
            "video_type": videoType,
            "actors": actors,
            "uid": uid,
            "img": img
            ])
    }
    func toDictionary() -> [String : Any?] {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm";
        
        return [
            "cid":cid,
            "videoId": videoId,
            "videoName": videoName,
            "videoStatus": videoStatus,
            "score": score,
            "videoType": videoType,
            "actors": actors,
            "img": img,
//            "uid": uid,
            "create_time":format.string(from: create_time)
        ]
        
    }
}
