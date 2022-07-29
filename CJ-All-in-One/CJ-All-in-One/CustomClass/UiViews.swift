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

//class PrimaryButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//        setConfiguration()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    convenience init(title: String) {
//        self.init(frame: CGRect(x: 0, y: 0, width: primaryButtonWidth, height: primaryButtonWidth))
//        self.setTitle(title, for: .normal)
//    }
//
//    func configure() {
//        self.layer.cornerRadius = 10
//        self.titleLabel?.font = .boldSystemFont(ofSize: 20)
//    }
//
//    func setConfiguration() {
//        var configuration = UIButton.Configuration.filled()
//        configuration.baseBackgroundColor = .CjYellow
//
//        let handler: UIButton.ConfigurationUpdateHandler = { button in // 1
//            switch button.state { // 2
//            case [.selected, .highlighted]:
//                button.configuration?.title = "Highlighted Selected"
//            case .selected:
//                button.configuration?.title = "Selected"
//            case .highlighted:
//                button.configuration?.title = "Highlighted"
//            case .disabled:
//                button.configuration?.title = "Disabled"
//                button.configuration?.baseBackgroundColor = .disableButtonColor
//            default:
//                button.configuration?.title = "Normal"
//            }
//        }
//        self.configuration = configuration
//        self.configurationUpdateHandler = handler
//    }
//}

public enum TableScrollEnableType {
    case none
    case vertical
}

class ListTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(rowHeight: CGFloat, scrollType: TableScrollEnableType) {
        self.init(frame: .zero, style: .plain)
        
        lazy var header = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: rowHeight))
        
        header.backgroundColor = .firstRowBackgroundColor
        self.tableHeaderView = header

        
        self.rowHeight = rowHeight
        switch scrollType {
        case .none:
            self.isScrollEnabled = false

        case .vertical:
            self.isScrollEnabled = true
            self.alwaysBounceVertical = false
            self.bounces = self.contentOffset.y > 0
        }
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

class CustomNavigationBar : UIView {
    
    lazy var labelTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String) {
        self.init()
        
        self.addSubviews([labelTitle])
        labelTitle.text = title
        labelTitle.font = .systemFont(ofSize: 23, weight: .bold)
        labelTitle.textColor = .CjWhite
        labelTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func configure() {
        self.backgroundColor = .deppBlue
        self.snp.makeConstraints { make in
            make.height.equalTo(95)
        }
    }
}
