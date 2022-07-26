//
//  UiViews.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import Foundation
import UIKit

class ApplySectionTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.text = title
        self.font = .systemFont(ofSize: 23, weight: .semibold)
    }
}

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: primaryButtonWidth, height: primaryButtonWidth))
        self.setTitle(title, for: .normal)
//        print("in init() before: \(self.layer.cornerRadius)")
//        self.setBackgroundColor(.cjYellow, for: .normal)
//        self.setBackgroundColor(.cjOragne, for: .highlighted)
//        self.setBackgroundColor(.disableButtonColor, for: .disabled)
//        print("in init() after: \(self.layer.cornerRadius)")
    }
    
    func configure() {
        self.layer.cornerRadius = 10
//        print("in configure(): \(self.layer.cornerRadius)")
//        self.backgroundColor = .cjYellow
        self.titleLabel?.font = .boldSystemFont(ofSize: 20)
    }
    
    func setConfiguration() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .CjYellow

        let handler: UIButton.ConfigurationUpdateHandler = { button in // 1
            switch button.state { // 2
            case [.selected, .highlighted]:
                button.configuration?.title = "Highlighted Selected"
            case .selected:
                button.configuration?.title = "Selected"
            case .highlighted:
                button.configuration?.title = "Highlighted"
            case .disabled:
                button.configuration?.title = "Disabled"
                button.configuration?.baseBackgroundColor = .disableButtonColor
            default:
                button.configuration?.title = "Normal"
            }
        }
        self.configuration = configuration
        self.configurationUpdateHandler = handler
    }
}

class ListTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(rowHeight: CGFloat, isScrollEnabled: Bool) {
        self.init(frame: .zero, style: .plain)
        self.rowHeight = rowHeight
        self.isScrollEnabled = isScrollEnabled
    }
    
    private func configure() {
        self.backgroundColor = .CjWhite
        self.layer.borderWidth = 0.2
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(rgb: 0x888585).cgColor
        self.separatorStyle = .singleLine
        self.separatorColor = UIColor(rgb: 0xCCCCCC)
        self.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
