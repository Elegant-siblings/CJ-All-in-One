//
//  StartDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import Foundation
import Alamofire

class StartDataManager {
    func sendWorkStart(workPk: Int, manID: String) {
        let path = "/works/start?"
        let urlString = base_url+path+"workPK=\(workPk)&deliveryManID=\(manID)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: StartModel.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print("DEBUG: StartDataMananer ",response)
                    case .failure(let error):
                        print("DEBUG: StartDataMananer ",error)
                    }
                }
        }

    }
}
