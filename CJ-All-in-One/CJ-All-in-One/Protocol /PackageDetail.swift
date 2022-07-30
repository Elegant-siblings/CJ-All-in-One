//
//  PackageDetail.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/30.
//

import Foundation

protocol PackageDetailDataManagerDelegate: AnyObject {
    func getPackageList(workPK: Int)
}

protocol PackageDetailViewControllerDelegate: AnyObject {
    func didSuccessGetPackageDetail(_ result: PackageResponse)
    func failedToRequest(_ message: String)
}
