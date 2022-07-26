//
//  DeliveryCompletedResponse.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation


struct DeliveryCompletedResponse: Decodable {
    let workInfo: WorkInfo?
    let itemList: [ItemList]
}

// MARK: - WorkInfo
struct WorkInfo: Decodable {
    let workPK: Int
    let deliveryManID, deliveryDate: String
    let deliveryType, deliveryTime: Int
    let deliveryCar, terminalAddr: String
    let workState: Int
    let comment: String
    let completeNum : Int?
    let itemNum, income: Int
    let startTime, endTime: String?
}


// MARK: - ItemList
struct ItemList: Decodable {
    let deliveryPK: Int
    let itemCategory, senderAddr, receiverAddr: String
    let complete: Int
    let seatNum: Int
}



//MARK: - work completed

struct WorkCompleted: Decodable {
    let success: Bool
    let err: String?
}
