//
//  SignUpDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
import Alamofire


class SignUpDataManager {

    func postLogIn(userID: String, userPassword: String, userIdentityNum: String, userPhone: String, userAccount: String, viewController: SignUpViewController) {
        
        let urlString = "\(base_url)/user/register?userID=\(userID)&userPassword=\(userPassword)&userIdentityNum=\(userIdentityNum)&userPhone=\(userPhone)&userAccount=\(userAccount)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
            AF.request(url, method: .get)
                    .validate()
                    .responseDecodable(of: SignUpResponse.self) { (response) in
                    switch response.result {
                    case .success(let response):
                        if response.success {
                            viewController.didSuccessSignUp()
                        } else {
                            if let error = response.err {
                                viewController.failedToSignUp(message: error)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        viewController.failedToSignUp(message: "서버와의 연결이 좋지 않습니다.")
                    }
                }
        }
    }
}

