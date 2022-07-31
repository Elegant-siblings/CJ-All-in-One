//
//  MapItemListProtocol.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation

protocol MapItemListDataManagerDelegate: AnyObject {
    func getItemList(_ vc: FindPathBottomViewController, pk: Int)
}
