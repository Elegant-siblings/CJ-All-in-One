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
        return ["X-NCP-APIGW-API-KEY-ID" : "ydvsw8uw7f",
                "X-NCP-APIGW-API-KEY" : "Isa53LLQOqdW4ZspSCnROmLwWOTrxCMFm6ojETGB"
        ]
    }
    var account: String = ""
    var ManId: String = ""
}

let mainButtonHeight = 48
let mainButtonWidth = 343
let base_url = "http://34.125.0.122:3000"
let mainButtonTopOffset = UIScreen.main.bounds.size.height*(754/850)

