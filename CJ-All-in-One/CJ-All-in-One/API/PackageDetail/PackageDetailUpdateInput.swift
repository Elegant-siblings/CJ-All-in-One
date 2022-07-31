//
//  PackageDetailUpdateInput.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
import Alamofire

struct PackageDetailUpdateInput {
    var body: PackageDetailUpdateBody
}

/// 에그 머니 전환 API Input Body
/// - API Index : 22
struct PackageDetailUpdateBody {
    var deliveryPK: Int
    var complete: Int
    var receipt: String
    var recipient: String
    var picture: String

    var getBody: Parameters {
        var body: Parameters = [:]
        body["deliveryPK"] = deliveryPK
        body["complete"] = complete
        body["receipt"] = receipt
        body["recipient"] = recipient
        body["picture"] = picture
        return body
    }
}
