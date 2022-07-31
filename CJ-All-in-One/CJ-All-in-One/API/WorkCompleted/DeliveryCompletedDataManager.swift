//
//  DeliveryCompletedDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
import Alamofire

class DeliveryCompletedDataManager: DeliveryCompletedDataManagerDelegate {
    
    weak var delegate: DeliveryCompletedViewDelegate?
    
    init(delegate: DeliveryCompletedViewDelegate) {
        self.delegate = delegate
    }
        
    func getDeliveryCompletedDetail(_ workPK: Int) {
        let urlString = "\(base_url)/works/detail?workPK=\(workPK)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: DeliveryCompletedResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        self.delegate?.didSuccessGetCompletedDetail(response)
                    case .failure(let error):
                        print(error)
                        self.delegate?.failedToRequest("서버와의 연동이 불안정합니다.")
                    }
                }
        }
    }
}

