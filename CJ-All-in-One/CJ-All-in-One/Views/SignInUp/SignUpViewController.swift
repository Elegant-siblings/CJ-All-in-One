//
//  SignUpViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import UIKit

class SignUpViewController: UIViewController {
    
    lazy var usernameEmailField = UITextField().then {
        $0.placeholder = "Username or Email..."
        $0.returnKeyType = .next
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = cornerRadius
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        
        
        
    }

}
