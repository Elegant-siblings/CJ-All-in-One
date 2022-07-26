//
//  UIColor.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/26.
//


import Foundation
import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    class var pathGray: UIColor { UIColor(hex: 0x767676) }
    class var pathRed: UIColor { UIColor(hex: 0xff4d60) }
    class var pathYellow: UIColor { UIColor(hex: 0xffc801) }
    class var pathBlue: UIColor { UIColor(hex: 0x4db1ff) }
    class var pathPink: UIColor { UIColor(hex: 0xe355a9) }
    class var pathGreen: UIColor { UIColor(hex: 0x08da75) }
    class var pathBlack: UIColor { UIColor(hex: 0x000000) }
    
    
    class var CjRed : UIColor { UIColor(hex: 0xFF6F6F) }
    class var CjBlue : UIColor { UIColor(hex: 0x6FBAFF) }
    class var CjOrange : UIColor { UIColor(hex: 0xFF9A6F) }
    class var CjYellow : UIColor { UIColor(hex: 0xFFCE6E) }
    class var CjWhite : UIColor { UIColor(hex: 0xF9F9F9) }
    
    class var deppBlue : UIColor { UIColor(hex: 0x193640) }
    
    
    class var borderColor : UIColor { UIColor(hex: 0x888585)}
    class var customLightGray : UIColor { UIColor(hex: 0xCCCCCC) }

}
