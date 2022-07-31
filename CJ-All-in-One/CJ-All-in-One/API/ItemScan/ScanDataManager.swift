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
        let urlString = base_url+path+""
        
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
