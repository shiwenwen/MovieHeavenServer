//
//  ModelProtocol.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/14.
//

import Foundation

/// 数据转换
protocol ModelJson {
    
    /// 转字典
    ///
    /// - Returns: 字典
    func toDictionary() -> [String:Any?]
    
    /// 转json
    func toJsonString() -> String?
}
extension ModelJson {
    
    func toJsonString() -> String? {
        do {
            return try self.toDictionary().jsonEncodedString()
        } catch  {
            return nil
        }
    }
    
}
