//
//  LoginResponse.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation

struct LoginResponse: Decodable {
    let success: Bool
    let userInfo: UserInfo?
    let msg: String
}
