//
//  TaskResponse.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/29.
//

import Foundation

struct Tasks: Codable{
    let rows: [Task]
}

struct Task: Codable {
    let workPK: Int
    let deliveryDate: String
    let deliveryType: String
    let deliveryTime: String
    let deliveryCar: String
    let terminalAddr: String
    let workState: Int
    let comment: String?
}
