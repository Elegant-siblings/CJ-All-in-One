//
//  SignUpViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/31.
//

import UIKit

class SignUpTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.returnKeyType = .next
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.layer.cornerRadius = 8
        self.backgroundColor = .secondarySystemBackground
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

class SignUpViewController: UIViewController {
    
    let cornerRadius: CGFloat = 8.0
    let uiOffset = CGFloat(12)
    let sectionOffset = CGFloat(45)
    var isValids: [Bool] = [false,false,false,false,false,false]
    var isAgree: Int = 0
    var isPhone = false
    var isPhoneCer = false
    var isIdCheck = false
    
    // -MARK: UILabel
    lazy var labelID = UILabel().then {
        $0.text = "아이디"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelPW = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelPhone = UILabel().then {
        $0.text = "전화번호"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelIdenNum = UILabel().then {
        $0.text = "주민등록번호"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelAccount = UILabel().then {
        $0.text = "계좌번호"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelHypon = UILabel().then {
        $0.text = "-"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .primaryFontColor
        $0.textAlignment = .center
    }
<<<<<<< HEAD
    lazy var labelAgreement = UILabel().then {
        $0.text = "개인정보 제공 및 활용 동의"
        $0.textColor = UIColor(hex: 0x888585)
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
=======
>>>>>>> 7e7a295 (sign up view)
    
    // -MARK: TextField
    lazy var idField = SignUpTextField().then {
        $0.placeholder = "ID"
        $0.delegate = self
    }
    
    lazy var passwordField = SignUpTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호"
        $0.delegate = self
    }
    
    lazy var passwordCheckField = SignUpTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호 확인"
        $0.delegate = self
    }
    
    lazy var phoneField = SignUpTextField().then {
        $0.placeholder = "전화번호"
        $0.keyboardType = .phonePad
        $0.delegate = self
    }
    
    lazy var phoneCertifyField = SignUpTextField().then {
        $0.placeholder = "인증번호"
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    lazy var firstIdentityNumField = SignUpTextField().then {
        $0.placeholder = "앞자리"
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    lazy var secondIdentityNumField = SignUpTextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "뒷자리"
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    lazy var accountField = SignUpTextField().then {
        $0.placeholder = "계좌번호"
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    // -MARK: UIButton
    lazy var buttonIdDuplicateCheck = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(.CjWhite, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(touchUpIdCheck), for: .touchUpInside)
    }
    lazy var buttonGetPhoneCertifyNum = UIButton().then {
        $0.setTitle("인증번호 받기", for: .normal)
        $0.setTitleColor(.CjWhite, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(touchUpGetCertify), for: .touchUpInside)
    }
    lazy var buttonAgree = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = .CjRed
        $0.addTarget(self, action: #selector(touchUpAgreeButton), for: .touchUpInside)
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.layer.cornerRadius = 3
        $0.setTitle(" 동의 ", for: .normal)
        $0.setTitleColor(.CjRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }
    lazy var buttonPhoneCertify = UIButton().then {
        $0.setTitle("인증하기", for: .normal)
        $0.isEnabled = false
        $0.setTitleColor(.CjWhite, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .disableButtonColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(touchUpPhoneCertify), for: .touchUpInside)
    }
    
    lazy var buttonSignUp = MainButton(type:.main).then {
        $0.setTitle("회원가입하기", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = .CjBlue
        $0.addTarget(self, action: #selector(touchUpSignUp), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        
        view.addSubviews([
            labelID,idField,buttonIdDuplicateCheck,
            labelPW,passwordField,passwordCheckField,
            labelPhone,phoneField,phoneCertifyField,
            buttonGetPhoneCertifyNum,buttonPhoneCertify,
            labelIdenNum,firstIdentityNumField,labelHypon,secondIdentityNumField,
            labelAccount,accountField,
            labelAgreement, buttonAgree,
            buttonSignUp
        ])
        let widthOffset = CGFloat(30)
        idField.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(widthOffset)
            make.width.equalToSuperview().offset(-140)
        }
        labelID.snp.makeConstraints { make in
            make.bottom.equalTo(idField.snp.top).offset(-8)
            make.leading.equalTo(idField).offset(3)
        }
        buttonIdDuplicateCheck.snp.makeConstraints { make in
            make.centerY.equalTo(idField)
            make.leading.equalTo(idField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-widthOffset)
            make.height.equalTo(idField).offset(-5)
        }
        
        labelPW.snp.makeConstraints { make in
            make.bottom.equalTo(passwordField.snp.top).offset(-8)
            make.leading.equalTo(passwordField).offset(3)
        }
        passwordField.snp.makeConstraints { make in
            make.height.leading.equalTo(idField)
            make.trailing.equalToSuperview().offset(-widthOffset)
            make.top.equalTo(idField.snp.bottom).offset(sectionOffset)
        }
        passwordCheckField.snp.makeConstraints { make in
            make.height.equalTo(idField)
            make.leading.trailing.equalTo(passwordField)
            make.top.equalTo(passwordField.snp.bottom).offset(uiOffset)
        }
        
        labelPhone.snp.makeConstraints { make in
            make.bottom.equalTo(phoneField.snp.top).offset(-8)
            make.leading.equalTo(phoneField).offset(3)
        }
        phoneField.snp.makeConstraints { make in
            make.height.equalTo(idField)
            make.leading.equalToSuperview().offset(widthOffset)
            make.trailing.equalToSuperview().offset(-150)
            make.top.equalTo(passwordCheckField.snp.bottom).offset(sectionOffset)
        }
        buttonGetPhoneCertifyNum.snp.makeConstraints { make in
            make.centerY.equalTo(phoneField)
            make.leading.equalTo(phoneField.snp.trailing).offset(10)
            make.height.equalTo(idField).offset(-5)
            make.trailing.equalToSuperview().offset(-widthOffset)
        }
        phoneCertifyField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(idField)
            make.top.equalTo(phoneField.snp.bottom).offset(uiOffset)
        }
        buttonPhoneCertify.snp.makeConstraints { make in
            make.centerY.equalTo(phoneCertifyField)
            make.leading.equalTo(phoneCertifyField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-widthOffset)
            make.height.equalTo(idField).offset(-5)
        }
        
        labelIdenNum.snp.makeConstraints { make in
            make.bottom.equalTo(firstIdentityNumField.snp.top).offset(-8)
            make.leading.equalTo(firstIdentityNumField).offset(3)
        }
        firstIdentityNumField.snp.makeConstraints { make in
            make.height.leading.equalTo(idField)
            make.width.equalTo(150)
            make.top.equalTo(phoneCertifyField.snp.bottom).offset(sectionOffset)
        }
        labelHypon.snp.makeConstraints { make in
            make.centerY.equalTo(firstIdentityNumField)
            make.leading.equalTo(firstIdentityNumField.snp.trailing)
            make.trailing.equalTo(secondIdentityNumField.snp.leading)
        }
        secondIdentityNumField.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(firstIdentityNumField)
            make.leading.equalTo(firstIdentityNumField.snp.trailing).offset(20)
        }
        
        labelAccount.snp.makeConstraints { make in
            make.bottom.equalTo(accountField.snp.top).offset(-8)
            make.leading.equalTo(accountField).offset(3)
        }
        accountField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(passwordField)
            make.top.equalTo(firstIdentityNumField.snp.bottom).offset(sectionOffset)
        }
        labelAgreement.snp.makeConstraints { make in
            make.centerY.equalTo(buttonAgree)
            make.trailing.equalTo(buttonAgree.snp.leading).offset(-10)
        }
        buttonAgree.snp.makeConstraints { make in
            make.trailing.equalTo(buttonSignUp).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalTo(buttonSignUp.snp.top).offset(-10)
        }
        buttonSignUp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
            make.top.equalTo(mainButtonTopOffset)
        }
    }
    
    // -MARK: Selectors
    @objc func touchUpSignUp() {
        print("회원가입하기")
        guard let password = passwordField.text else { return }
        let passwordCheck = passwordCheckField.text
        guard let firstIDNum = firstIdentityNumField.text else { return }
        guard let secondIDNum = secondIdentityNumField.text else { return }
        
        if isIdCheck == false {
            shakeTextField(textField: idField)
            return
        }
        if isValidPassword(pwd: password) {
            if password != passwordCheck {
                shakeTextField(textField: passwordCheckField)
                return
            }
        }
        else {
            shakeTextField(textField: passwordCheckField)
            return
        }
        if isPhone == false {
            shakeTextField(textField: phoneField)
            return
        }
        else if isPhoneCer == false {
            shakeTextField(textField: phoneCertifyField)
            return
        }
        if isValidSixDigit(num: firstIDNum) && isValidSixDigit(num: secondIDNum) {
            // -MARK: 주민등록번호
        }
        else {
            shakeTextField(textField: firstIdentityNumField)
            shakeTextField(textField: secondIdentityNumField)
            return
        }
        
        if accountField.text?.isEmpty == true {
            shakeTextField(textField: accountField)
            return
        }
        
    }
    
    @objc func touchUpIdCheck() {
        if idField.text?.isEmpty == true {
            shakeTextField(textField: idField)
            return
        }
        // 중복확인 ok 되면 아이디 확정
        isIdCheck = true
        
    }
    
    @objc func touchUpGetCertify() {
        guard let phoneNum = phoneField.text else { return }
        
        if isValidPhone(phone: phoneNum) {
            isPhone = true
            buttonPhoneCertify.isEnabled = true
            buttonPhoneCertify.backgroundColor = .CjBlue
            let alert = UIAlertController(title: "인증가 전송되었습니다.", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            shakeTextField(textField: phoneField)
        }
    }
    
    @objc func touchUpPhoneCertify(_ button: UIButton) {
        guard let num = phoneCertifyField.text else { return }
        if isValidSixDigit(num: num) {
            let alert = UIAlertController(title: "인증 완료", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            // -MARK: 전화번호 확정
            isPhoneCer = true
            button.isEnabled = false
            buttonGetPhoneCertifyNum.isEnabled = false
            button.backgroundColor = .disableButtonColor
            buttonGetPhoneCertifyNum.backgroundColor = .disableButtonColor
        }
        else {
            shakeTextField(textField: phoneCertifyField)
        }
    }
    
    @objc func touchUpAgreeButton() {
        let vc = AgreementViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .automatic
        vc.didAgree = isAgree
        vc.modalDelegate = self
        vc.agreeTitle = "개인정보 동의서"
        self.present(vc, animated: true)
    }
    
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegEx = "^[0-9]{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phone)
    }
    
    func isValidSixDigit(num: String) -> Bool {
        let numRegEx = "^[0-9]{6}$"
        let numTest = NSPredicate(format: "SELF MATCHES %@", numRegEx)
        return numTest.evaluate(with: num)
    }
    
//    private func isEnableButton() {
//        if isValids.allSatisfy({$0}) == true && isAgree == 1 {
//            buttonSignUp.isEnabled = true
//        }
//        else {
//            buttonSignUp.isEnabled = false
//
//    }
    
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        var maxLength: Int = 50
        switch textField {
        case idField,passwordField,passwordCheckField:
            maxLength = 20
        case phoneField:
            maxLength = 11
        case firstIdentityNumField,secondIdentityNumField,phoneCertifyField:
            maxLength = 6
        default:
            maxLength = 50
        }
        
        guard let text = textField.text else { return false }
        if text.count >= maxLength {
            return false
        }
        
        return true
    }
}

extension SignUpViewController: AgreementDelegate {
    func doAgree(isAgree: Int) {
        switch isAgree {
        case 1:
            self.isAgree = isAgree
            buttonAgree.tintColor = .darkGray
            buttonAgree.layer.borderColor = UIColor.darkGray.cgColor
            buttonAgree.setTitleColor(.darkGray, for: .normal)
            buttonSignUp.isEnabled = true
        case 0:
            self.isAgree = isAgree
            buttonAgree.tintColor = .CjRed
            buttonAgree.layer.borderColor = UIColor.CjRed.cgColor
            buttonAgree.setTitleColor(.CjRed, for: .normal)
            buttonSignUp.isEnabled = false
        default: break
        }
//        isEnableButton()
    }
}
