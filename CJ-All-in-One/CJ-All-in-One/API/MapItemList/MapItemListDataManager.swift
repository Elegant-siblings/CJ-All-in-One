//
//  MapItemListDataManager.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
import Alamofire

class MapItemListDataManager: MapItemListDataManagerDelegate {
    func getItemList(_ vc: FindPathBottomViewController, pk: Int) {
        
        let path = "/works/itemlist?"
        let urlString = base_url+path+"workPK=\(pk)"
        
        print("PK: \(pk)")
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: ItemListModel.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        vc.successGetItemList(result: response.rows)
                        print("DEBUG: ",response)
                    case .failure(let error):
                        print("DEBUG: ",error)
                    }
                }
        }
    }
}
