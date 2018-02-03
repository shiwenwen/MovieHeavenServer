//
//  Configurations.swift
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//
#if os(Linux)
    //MARK:----------- Local MySql Release -----------------
    let LOCAL_HOST = "http://47.94.175.119"
    let SERVER_PORT = 8081
    let SQL_HOST = "127.0.0.1"
    let SQL_USER = "root"
    let SQL_PASSWORD = "sww"
    let SQL_DB = "MovieHeaven"
#else
    
    //MARK:----------- Local MySql Develop -----------------
    let LOCAL_HOST = "http://192.168.31.208"
    let SERVER_PORT = 8080
    let SQL_HOST = "127.0.0.1"
    let SQL_USER = "root"
    let SQL_PASSWORD = "sww"
    let SQL_DB = "MovieHeaven"
#endif

let SQL_PORT = 3306



let MD5_KEY = "OqoIcIy2edJwjL9Rwcb5dtUH36yWDT99hg2NdbINSP0kmBeoCUtPtJo4YidbISC6"

let EmailServer = "smtp.163.com"
let EmailAddress = "s13731984233@163.com"
let EmailPsd = "s13156537832"


let APP_UPDATE_RUL = "itms-services://?action=download-manifest&url=https://www.gallifrey.cn/movie_heaven/apps/MovieHeaven/MovieHeaven.plist"
