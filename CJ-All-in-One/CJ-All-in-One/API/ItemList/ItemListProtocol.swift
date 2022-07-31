//
//  ResultProtocol.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation

protocol ItemListDataManagerDelegate {
    func getItemList(_ vc: WorkViewController, pk: Int)
    func getTermAddress(terminalAddr: String, vc: WorkViewController)
}
