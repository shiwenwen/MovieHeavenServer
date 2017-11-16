//
//  HistoryModel.swift
//  MovieHeavenPackageDescription
//
//  Created by 石文文 on 2017/11/15.
//

import Foundation
import MySQL
import CMySQL
struct HistoryModel: QueryRowResultType, QueryParameterDictionaryType, ModelJson {
    
    let hid: Int //收藏id
    let videoId: Int //视频id
    let videoName: String? //视频名称
    let videoStatus: String? //视频状态
    let score: String? //评分
    let videoType: String? //视频类型
    let actors: String? //演员
    let uid: Int //用户id
    let img: String? //视频图片
    let sourceType: String //视频源类型
    let sourceName: String //视频源名称
    let partName: String //分集名称
    let vid: Int //分集id
    let playingTime: Double //已播放的时长
    let isFinish: Int //是否看完
    let update_time: Date //更新时间
    
    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> HistoryModel {
        return try HistoryModel(
            hid: r <| "hid",
            videoId: r <| "videoId",
            videoName: r <|? "video_name",
            videoStatus: r <|? "video_status",
            score: r <|? "score",
            videoType: r <|? "video_type",
            actors: r <|? "actors",
            uid: r <| "uid",
            img: r <|? "img",
            sourceType: r <| "source_type",
            sourceName: r <| "source_name",
            partName: r <| "part_name",
            vid: r <| "vid",
            playingTime: r <| "playing_time",
            isFinish: r <| "is_finish",
            update_time: r <| "update_time" // string enum type
        )
        
    }
    
    // Use this model as a query paramter
    // See inserting example
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            //"hid": // auto increment
            "videoId": videoId,
            "video_name": videoName,
            "video_status": videoStatus,
            "score": score,
            "video_type": videoType,
            "actors": actors,
            "uid": uid,
            "img": img,
            "source_type": sourceType,
            "source_name": sourceName,
            "part_name": partName,
            "vid": vid,
            "playing_time": playingTime,
            "is_finish": isFinish,
            "update_time":update_time
            ])
    }
    func toDictionary() -> [String : Any?] {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm";
        
        return [
            "hid":hid,
            "videoId": videoId,
            "videoName": videoName,
            "videoStatus": videoStatus,
            "score": score,
            "videoType": videoType,
            "actors": actors,
            "img": img,
            "sourceType": sourceType,
            "sourceName": sourceName,
            "partName": partName,
            "vid": vid,
            "playingTime": playingTime,
            "isFinish":isFinish,
            //            "uid": uid,
            "update_time":format.string(from: update_time)
        ]
        
    }
}
