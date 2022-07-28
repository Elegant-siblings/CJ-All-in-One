//
//  ApplyDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation
import Alamofire

let base_url = "http://34.125.0.122:3000"

class ApplyDataManager: ApplyDataManagerDelegate {
    func getAssignedItems(date: String, locations: [Location], _ viewController: AssignViewController) {
        
        let path = "/works?"
        var urlString = base_url + path
        var addr1 = ""
        var addr2 = ""
        _ = locations.map { loca in
            addr1 += loca.city+","
            addr2 += loca.goo+","
        }
        _ = addr1.popLast()
        _ = addr2.popLast()
        urlString += "deliveryDate=\(date)&receiverAdd1="+addr1+"&receiverAdd2="+addr2
        print("URL: ", urlString)
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            print(url)
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: AssignedItem.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print(response)
                        viewController.successAssignItems(response.rows)
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
