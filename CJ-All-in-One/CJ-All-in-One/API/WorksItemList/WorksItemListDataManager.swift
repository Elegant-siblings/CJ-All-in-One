//
//  WorksItemListDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/08/01.
//

import Foundation
import Alamofire

class WorksItemListDataManager {
        
    func getPackageDetail(workPK: Int, vc: FindPathBottomViewController) {
        let urlString = "\(base_url)/works/detail?workPK=\(workPK)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: DeliveryCompletedResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        vc.didSuccessGetItemList(response)
                    case .failure(let error):
                        print(error)
                        vc.failedToRequest(message: "서버와의 연동이 불안정합니다.")
                    }
                }
        }
    }
    
}
