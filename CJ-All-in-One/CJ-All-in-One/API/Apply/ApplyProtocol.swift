//
//  ApplyProtocol.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import Foundation
import UIKit

protocol ApplyDataManagerDelegate {
    func getAssignedItems(date: String, locations: [Location], _ viewController: AssignViewController)
    func applyTask(applyForm: ApplyDataModel)
}
