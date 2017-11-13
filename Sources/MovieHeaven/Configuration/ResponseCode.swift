//
//  ResponseCode.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//

enum ResponseCode : String{
    case requestParamsError = "4000" //请求参数错误
    case signError = "4001" //签名错误
    case success = "0000" //成功
    case defaultError = "9999" //默认错误
    case logonFailure = "9995" //登录失效
}
