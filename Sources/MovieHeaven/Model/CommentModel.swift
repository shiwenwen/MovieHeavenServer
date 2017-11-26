//
//  CommentModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/23.
//

import Foundation
import MySQL
import CMySQL
struct CommentModel: QueryRowResultType, QueryParameterDictionaryType, ModelJson {
    
    let cmid: Int //评论id
    let videoId: Int //视频id
    let source_type: String? //源类型
    let source_name: String? //源名称
    let part_name: String? //分集名称
    let vid: Int? //分集视频id
    let create_time: Date //评论时间
    let content: String? //评论内容
    let uid: Int //用户id
    let video_name: String? //视频名称
    let score: Int? //评分
    let img: String? //视频图片
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> CommentModel {
        return try CommentModel(cmid: r <| 0, videoId: r <| 1, source_type: r <|? 2, source_name: r <|? 3, part_name: r <|? 4, vid: r <|? 5, create_time: r <| 6, content: r <|? 7, uid: r <| 8, video_name: r <|? 9, score: r <|? 10, img: r <|? 11)
        
    }
    
    // Use this model as a query paramter
    // See inserting example
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
//            "cmid": cmid,
            "videoId": videoId,
            "source_type": source_type,
            "source_name": source_name,
            "part_name": part_name,
            "vid": vid,
//            "create_time":create_time,
            "content": content,
            "uid": uid,
            "video_name":video_name,
            "score":score,
            "img":img
            ])
    }
    func toDictionary() -> [String : Any?] {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm";
        format.timeZone = TimeZone(abbreviation: "UTC") //实际时间应该CCT 这里是转换导致的 设置UTC是为了矫正
        return [
            "cmid": cmid,
            "videoId": videoId,
            "sourceType": source_type,
            "sourceName": source_name,
            "partName": part_name,
            "vid": vid,
            "commentTime":format.string(from: create_time),
            "content": content,
            "uid": uid,
            "videoName":video_name,
            "score":score,
            "img": img
        ]
        
    }
}
