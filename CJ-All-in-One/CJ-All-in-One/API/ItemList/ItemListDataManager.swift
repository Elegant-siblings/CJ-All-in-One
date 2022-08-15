//
//  ResultDataManager.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation
import Alamofire

class ItemListDataManager: ItemListDataManagerDelegate {
    func getItemList(_ vc: WorkViewController, pk: Int) {
        
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
    
    func getTermAddress(terminalAddr: String, vc: WorkViewController) {
        
        let urlString = "\(base_url)/map/terminal?terminalAddr=\(terminalAddr)"

        print(urlString)
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            _ = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: TerminalAddressResponse.self) {
                    response in
                    switch response.result {
                    case .success(let response):
                        if response.success{
                            vc.successGetTerminalAddress(result: response)
                            print("DEBUG: ",response)
                        } else {
                            print("배송지 에러")
                        }
                    case .failure(let error):
                        print("DEBUG: ",error)
                    }
                }
        }
    }
}
