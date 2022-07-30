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
        
    func getPackageList(workPK: Int) {
        let urlString = "\(Constant.shared.FIND_PATH_BASE_URL)/works/itemlist?workPK=\(workPK)"
        
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
}

