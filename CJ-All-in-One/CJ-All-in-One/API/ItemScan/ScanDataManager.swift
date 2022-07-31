//
//  ScanDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import Foundation
import Alamofire

class ScanDataManager {
    func sendMissingItems(deliveryPK: [Int]) {
        let path = "/item/scan?"
        
        var pkToString = ""
        deliveryPK.forEach {
            pkToString += "\($0),"
        }
        _ = pkToString.popLast()
        let urlString = base_url+path+"deliveryPK=\(pkToString)"
        
        print("URL: \(urlString)")
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: ResponseModel.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print("DEBUG: ScanDataManager ",response)
                    case .failure(let error):
                        print("DEBUG: ScanDataManager ",error)
                    }
                }
        }
    }
}
