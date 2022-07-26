//
//  ButtonClass.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/26.
//

import Foundation
import UIKit

public enum CustomButtonType {
    case main
}

class MainButton: UIButton {
    required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
        
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame:CGRect.zero)
    }
    
    // 보조 이니셜라이저
    convenience init(type: CustomButtonType) {
        self.init()
        
        switch type {
        case .main:
            self.setTitleColor(.white, for: .normal)
            self.titleLabel?.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
            self.backgroundColor = .CjYellow
            self.borderWidth = 1
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner)
        }
    }
    
    var style: CustomButtonType = .main {
       didSet {
           switch style {
           case .main:
               self.setTitleColor(.white, for: .normal)
               self.backgroundColor = .CjYellow
               self.borderWidth = 1
               self.layer.cornerRadius = 10
               self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner)
           }
       }
   }
}

