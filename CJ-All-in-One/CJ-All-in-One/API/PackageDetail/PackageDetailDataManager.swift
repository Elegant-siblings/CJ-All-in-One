//
//  CellItemListDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/30.
//

import Foundation
import Alamofire

class PackageDetailDataManager: PackageDetailDataManagerDelegate {
    
    weak var delegate: PackageDetailViewControllerDelegate?
    
    init(delegate: PackageDetailViewControllerDelegate) {
        self.delegate = delegate
    }
        
    func getPackageDetail(deliveryPK: Int) {
        let urlString = "\(base_url)/item/detail?deliveryPK=\(deliveryPK)"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: PackageResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        self.delegate?.didSuccessGetPackageDetail(response)
                    case .failure(let error):
                        print(error)
                        self.delegate?.failedToRequest("서버와의 연동이 불안정합니다.")
                    }
                }
        }
    }
    
    func updateDeliveryInfo(data: PackageDetailUpdateInput) {
        let urlString = "\(base_url)/item/update"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: encoded) {
            print(url)
        
            AF.request(url, method: .post, parameters: data.body.getBody, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: PackageResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        self.delegate?.didSuccessUpdatePackageDetail(response)
                    case .failure(let error):
                        print(error)
                        self.delegate?.failedToUpadte("서버와의 연동이 불안정합니다.")
                    }
                }
        }
    }
}

