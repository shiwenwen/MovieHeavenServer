//
//  CountModel.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//

import Foundation
import MySQL
import CMySQL
struct CountModel: QueryRowResultType, QueryParameterDictionaryType {
    
    let num: Int //数量

    // Decode query results (selecting rows) to a model
    static func decodeRow(r: QueryRowResult) throws -> CountModel {
        return try CountModel(num: r <| "num")
        
    }
    
    // Use this model as a query paramter
    // See inserting example
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([:])
    }
   
}
