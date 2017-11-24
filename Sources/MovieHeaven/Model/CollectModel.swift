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
    
    
    let cid: Int //收藏id
    let videoId: Int //视频id
    let videoName: String? //视频名称
    let videoStatus: String? //视频状态
    let score: String? //视频评分
    let videoType: String? //视频类型
    let actors: String? //演员
    let uid: Int //用户id
    let img: String? //视频图片
    let create_time: Date //创建时间
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
        format.timeZone = TimeZone(abbreviation: "UTC") //实际时间应该CCT 这里是转换导致的 设置UTC是为了矫正
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
