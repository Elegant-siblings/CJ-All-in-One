//
//  Constant.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/26.
//

import Foundation

import Foundation
import Alamofire

class Constant {
    static let shared: Constant = Constant()
    
    let FIND_PATH_BASE_URL = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"
    
    var HEADERS: HTTPHeaders {
        return ["X-NCP-APIGW-API-KEY-ID" : "ze98l8nczg",
                "X-NCP-APIGW-API-KEY" : "WZ2rtCWUOKJrKd1BJn0XEvLoqC0DELzG8yQCDnCI"
        ]
    }
}

let primaryButtonHeight = 48
let primaryButtonWidth = 343
let base_url = "http://34.125.0.122:3000"
let ManId = "AABBCCDDEEFFGGHH"
