//
//  CellItemListResponse.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/30.
//

import Foundation

struct PackageResponse: Decodable {
    let deliveryPK, workPK: Int?
    let sender, receiver, itemCategory, senderAddr: String?
    let receiverAddr: String?
    let complete: Int?
    let comment: String?
    let completeTime: String?
    let receipt, recipient, picture: String?
}


