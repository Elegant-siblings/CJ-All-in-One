//
//  SignUpDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
import Alamofire


class IDCheckDataManager {

    func postIDCheck(userID: String, viewController: SignUpViewController) {
        
        let urlString = "\(base_url)/user/idcheck?userID=\(userID)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
        AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: IDResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if !response.existence {
                        viewController.didSuccessChecked()
                    } else {
                        viewController.failedToCheck(message: "이미 가입된 아이디가 있습니다.")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    viewController.failedToCheck(message: "서버와의 연결이 좋지 않습니다.")
                }
            }
        }
    }
}

