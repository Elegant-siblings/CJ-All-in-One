//
//  ResultViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import Then

class ResultViewController: UIViewController {
    
    // -MARK: Constants
    var string: String = "aa"
    
    lazy var label = UILabel().then {
        $0.text = string
    }
    // -MARK: UIViews
    
    
    lazy var buttonArrived = PrimaryButton(title: "터미널 도착").then {
        $0.addTarget(self, action: #selector(touchUpArrivedButton), for: .touchUpInside)
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        
        view.addSubviews([label, buttonArrived])
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        buttonArrived.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(primaryButtonWidth)
            make.height.equalTo(primaryButtonHeight)
            make.top.equalTo(self.view.snp.top).offset(754)
        }

    }
    // -MARK: selectors
    @objc func touchUpArrivedButton() {
        print("터미널 도착")
    }
    

}
