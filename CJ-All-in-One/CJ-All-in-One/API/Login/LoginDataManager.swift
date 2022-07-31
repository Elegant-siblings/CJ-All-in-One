//
//  LogInDataManager.swift
//
//
//  Created by Jiyun
//

import Foundation
import Alamofire

//class LogInDataManager {
//
//    func postLogIn(snsRoute: String, accessToken: String, viewController: LogInViewController) {
//        let header: HTTPHeaders = [
//            "sns-token": accessToken
//        ]
//
//        var body: LogInBody?
//
//        if let fcmToken = Constant.shared.FCM_TOKEN {
//            body = LogInBody(fcmKey: fcmToken)
//        }
//
////        print("postLogIn Called")
//        AF.request("\(Constant.shared.BASE_URL)/user/login?snsRoute=\(snsRoute)", method: .post, parameters: body, encoder: JSONParameterEncoder(), headers: header).validate().responseDecodable(of: LogInResponse.self) { (response) in
//            switch response.result {
//            case .success(let response):
//                if response.isSuccess, let result = response.result {
//                    viewController.didSuccessLogIn(result, type: snsRoute)
//                } else {
//                    viewController.failedToLogIn(message: LogInCode(code: response.code).message)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                viewController.failedToLogIn(message: LogInCode().message)
//        }
//        }
//    }
//}
