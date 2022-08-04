//
//  PackageDetail.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/30.
//

import Foundation

protocol PackageDetailDataManagerDelegate: AnyObject {
    func getPackageDetail(deliveryPK: Int)
}

protocol PackageDetailViewControllerDelegate: AnyObject {
    func didSuccessGetPackageDetail(_ result: PackageResponse)
    func didSuccessUpdatePackageDetail(_ result :PackageResponse)
    func failedToRequest(_ message: String)
    func failedToUpadte(_ messgae: String)
}

