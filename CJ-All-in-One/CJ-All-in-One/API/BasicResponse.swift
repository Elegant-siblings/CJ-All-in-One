//
//  BaseResponse.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import Foundation

struct ResponseModel: Codable {
    let success: Bool
    let err: String?
}
