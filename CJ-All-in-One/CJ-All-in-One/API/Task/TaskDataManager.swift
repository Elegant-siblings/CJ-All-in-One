//
//  TaskDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/29.
//

import Foundation
import Alamofire

class TaskDataManager: TaskDataManagerDelegate {
    func getTasks(_ vc: MainViewController) {
        let path = "/works/check?"
        
        let urlString = "http://34.125.0.122:3000/works/check?deliveryManID=AABBCCDDEEFFGGHH"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: Tasks.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        vc.successGetTasks(result: response.rows)
                        print("DEBUG: ",response)
                    case .failure(let error):
                        print("DEBUG: ",error)
                    }
                }
        }
    }
}
