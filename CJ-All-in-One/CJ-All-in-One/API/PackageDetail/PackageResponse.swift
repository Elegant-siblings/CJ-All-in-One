//
//  CellItemListResponse.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/30.
//

import Foundation

struct PackageResponse: Decodable {
    let rows: [PackageRow]
}

// MARK: - Row
struct PackageRow: Decodable {
    let deliveryPK: Int
    let sender, receiver, itemCategory, senderAddr: String
    let receiverAddr: String
}
