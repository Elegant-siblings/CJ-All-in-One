//
//  ApplyResponse.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation

// MARK: - Welcome
struct AssignedItem: Codable {
    let success: Bool
    let rows: [Row]
}

// MARK: - Row
struct Row: Codable, Equatable {
    let deliveryPK: Int
    let itemCategory: String
    let receiverAddr: String
}

struct ApplySuccess: Codable {
    let success: Bool
}
