//
//  ResultResponse.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation

struct ItemListModel: Codable {
    let success: Bool
    let rows: [Item]
}

struct Item: Codable {
    let deliveryPK: Int
    let sender: String
    let receiver: String
    let itemCategory: String
    let senderAddr: String
    let receiverAddr: String
}
