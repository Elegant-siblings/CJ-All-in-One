//
//  ApplyDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation
import Alamofire

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
        //        let urlString = "http://34.125.0.122:3000/works?deliveryDate=20220501&receiverAdd1=서울&receiverAdd2=마포구"
        print("URL: ", urlString)
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: AssignedItem.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print("DEBUG: ",response)
                        viewController.successAssignItems(response.rows)
                    case .failure(let error):
                        print("DEBUG: error", error)
                    }
                }
        }
    }
    
    func applyTask(applyForm: ApplyDataModel) {
        
//        var url = "http://34.125.0.122:3000/works/register?deliveryPK=1,2,3,4&deliveryManID=AABBCCDDEEFFGGHH&deliveryDate=20220515&deliveryType=0&deliveryTime=0&deliveryCar=세단&terminalAddr=서울"
        print(applyForm)
        let path = "/works/register?"
        var deliveryPKs = ""
        _ = applyForm.deliveryPK.map { pk in
            deliveryPKs += "\(pk),"
        }
        _ = deliveryPKs.popLast()
        let urlString = base_url+path+"deliveryPK=\(deliveryPKs)&deliveryManID=\(applyForm.deliveryManID)&deliveryDate=\(applyForm.deliveryDate)&deliveryType=\(applyForm.deliveryType)&deliveryTime=\(applyForm.deliveryTime)&deliveryCar=\(applyForm.deliveryCar)&terminalAddr=\(applyForm.terminalAddr)"
        print("URL: ", urlString)
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: ApplySuccess.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        print("DEBUG: ",response)
                    case .failure(let error):
                        print("DEBUG: ",error)
                    }
                }
        }
    }
}
