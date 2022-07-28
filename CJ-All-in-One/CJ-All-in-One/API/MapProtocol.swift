//
//  MapProtocol.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/26.
//

import Foundation

protocol MapDataManagerDelegate{
    func shortestPath(depLng: Double, depLat: Double, destLng: Double, destLat: Double, wayPoints: String?, option: String)
    func dockerExample()
}

protocol ViewControllerDelegate: AnyObject{
    func didSuccessReturnPath(result: Trafast)
    func failedToRequest(message: String)
    
    func didSuccessReceivedLngLat(result: Welcome)
}
