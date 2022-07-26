//
//  ViewDelegate.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/26.
//

import Foundation

protocol ViewDelegate: AnyObject {
    func pushed()
}
protocol TableViewDelegate: AnyObject {
    func cellTouched(info: Int)
}
