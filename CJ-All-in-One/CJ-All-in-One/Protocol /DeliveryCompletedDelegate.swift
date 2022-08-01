//
//  DeliveryCompletedDelegate.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/31.
//

import Foundation
protocol DeliveryCompletedDataManagerDelegate: AnyObject {
    func getDeliveryCompletedDetail(_ workPK: Int)
    func getWorkCompletedDetail(_ workPK: Int, _ completeNum: Int)
}
protocol DeliveryCompletedViewDelegate: AnyObject {
    func didSuccessGetCompletedDetail(_ result: DeliveryCompletedResponse)
    func didSuccessGetCompletedWork()
    func failedToRequest(_ message: String)
    func failedToRequestWork(_ message: String) 
}
