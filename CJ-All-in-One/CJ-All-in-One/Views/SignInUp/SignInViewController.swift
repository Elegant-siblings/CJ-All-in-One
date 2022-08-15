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
    
    lazy var imageLogo = UIImageView(image: UIImage(named: "CJ_logo_SignIn")).then {
        $0.contentMode = .scaleAspectFit
    }
    lazy var usernameEmailField = SignUpTextField().then {
        $0.placeholder = "아이디"
        $0.addTarget(self, action: #selector(didEndOnExit(_:)), for: .editingDidEndOnExit)
    }
    
    lazy var passwordField = SignUpTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호"
        $0.addTarget(self, action: #selector(didEndOnExit(_:)), for: .editingDidEndOnExit)
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
        $0.setTitleColor(.CjRed, for: .normal)
        $0.setTitle("계정이 없으신가요? 계정 만들러 가기", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSignUp), for: .touchUpInside)
    }
    
    lazy var headerView = UIView().then {
//        $0.clipsToBounds = true
        $0.backgroundColor = .CjWhite
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.25
//        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
//        $0.addSubview(backgroundImageView)
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
        
        headerView.addSubviews([imageLogo])
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        
        headerView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-80)
        }
        usernameEmailField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(30)
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
//        UserDefaults.standard.set(
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    @objc func touchUpSignUp() {
        let vc = SignUpViewController()
//        navigationController?.pushViewController(vc, animated: true)
//        let nc = UINavigationController(rootViewController: self)
//        nc.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
        
    }
    
    @objc func didEndOnExit(_ sender: UITextField) {
        if usernameEmailField.isFirstResponder {
            passwordField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func didSuccessLogIn(result: UserInfo){
        print("LogIn 성공")
        Constant.shared.account = result.userAccount
        Constant.shared.ManId = result.deliveryManID
        UserDefaults.standard.set(result.userID, forKey: "id")
        UserDefaults.standard.set(result.userPassword, forKey: "pwd")
        UserDefaults.standard.set(result.deliveryManID, forKey: "ManID")
        UserDefaults.standard.set(result.userAccount, forKey: "account")
        
        self.dismiss(animated: true, completion: nil)
    }
    func failedToLogIn(message: String) {
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        print(message)
    }
}
