//
//  SignInViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import UIKit

class SignInViewController: UIViewController {
    
    let cornerRadius: CGFloat = 8.0
    let uiOffset = CGFloat(10)
    
    var dataManager : LogInDataManager = LogInDataManager()
    
    lazy var usernameEmailField = SignUpTextField().then {
        $0.placeholder = "Username or Email..."
    }
    
    lazy var passwordField = SignUpTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "Password..."
    }
    
    lazy var buttonSignIn = MainButton(type: .main).then {
        $0.setTitle("로그인하기", for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = cornerRadius
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(touchUpSignIn), for: .touchUpInside)
    }
    
    lazy var buttonSignUp = UIButton().then {
        $0.setTitleColor(.label, for: .normal)
        $0.setTitle("계정이 없으신가요? 계정 만들러 가기", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSignUp), for: .touchUpInside)
    }
    
    lazy var headerView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .CjBlue
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        $0.addSubview(backgroundImageView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        
        view.addSubviews([
            headerView,
            usernameEmailField,
            passwordField,
            buttonSignIn,
            buttonSignUp
        ])
        
        
        headerView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        usernameEmailField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(40)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(55)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameEmailField.snp.bottom).offset(uiOffset)
            make.leading.trailing.height.equalTo(usernameEmailField)
        }
        buttonSignIn.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(uiOffset+15)
            make.leading.trailing.height.equalTo(usernameEmailField)
        }
        buttonSignUp.snp.makeConstraints { make in
            make.top.equalTo(buttonSignIn.snp.bottom).offset(8)
            make.leading.trailing.height.equalTo(usernameEmailField)
        }
        
        
    }
    
    // -MARK: Selectors
    @objc func touchUpSignIn() {
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  return
              }
        
        print("sign in")
        
        print(usernameEmail)
        print(password)
        
        dataManager.postLogIn(userID: usernameEmail, userPassword: password, viewController: self)

        
    }
    
    @objc func touchUpSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func didSuccessLogIn(result: UserInfo){
        print("LogIn 성공")
        Constant.shared.account = result.userAccount
        let vc = MainViewController()
        ManId = result.deliveryManID
        self.navigationController?.changeRootViewController(vc)
    }
    func failedToLogIn(message: String) {
        print(message)
    }
}
