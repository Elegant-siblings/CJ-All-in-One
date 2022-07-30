//
//  UpdateDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/30.
//

import Foundation
import Alamofire

class UpdateDataManager: UpdateDelegate {
    func updateWorkState(workPK: Int, workState: Int) {
        
        let path = "/works/update?"
        let urlString = base_url+path+"workPK=\(workPK)&workState=\(workState)"
        
        print("URL: ", urlString)
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: UpdateModel.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print("DEBUG: 취소",response)
                    case .failure(let error):
                        print("DEBUG: error", error)
                    }
                }
        }
    }
}
