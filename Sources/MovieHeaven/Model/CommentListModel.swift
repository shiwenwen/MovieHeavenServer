//
//  CommentListModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/23.
//

import Foundation
import MySQL
import CMySQL
struct CommentListModel: QueryRowResultType, QueryParameterDictionaryType, ModelJson {
    
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
    let nickName: String? //昵称
    let avatar: String? //头像
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> CommentListModel {
        return try CommentListModel(cmid: r <| "cmid", videoId: r <| "videoId", source_type: r <|? "source_type", source_name: r <|? "source_name", part_name: r <|? "part_name", vid: r <|? "vid", create_time: r <| "create_time", content: r <|? "content", uid: r <| "uid", video_name: r <|? "video_name", score: r <|? "score", nickName: r <|? "nickName", avatar: r <|? "avatar")
        
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
            "nickName":nickName,
            "avatar":avatar
        ]
        
    }
}

