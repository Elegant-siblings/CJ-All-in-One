//
//  AgreementViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/29.
//

import UIKit

protocol AgreementDelegate: AnyObject {
    func doAgree(isAgree: Int)
}

class AgreementViewController: UIViewController {
    
    var modalDelegate: AgreementDelegate?
    var didAgree = 0
    var agreeTitle = ""

    lazy var viewContent = UIView().then {
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 1
    }
    lazy var viewButton = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 3
    }
    
    lazy var labelTitle = UILabel().then {
        $0.text = agreeTitle
        $0.textColor = .primaryFontColor
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 30)
    }
    lazy var labelButton = UILabel().then {
        $0.text = "위 약관에 동의합니다."
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 20)
//        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .CjWhite
    }
    
    lazy var buttonAgree = UIButton().then {
        $0.addTarget(self, action: #selector(touchUpAgreeButton), for: .touchUpInside)
    }
    
    @objc func touchUpAgreeButton() {
        print("agree")
        didAgree = didAgree == 1 ? 0 : 1
        modalDelegate?.doAgree(isAgree: didAgree)
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        view.addSubviews([
            labelTitle,
            viewContent,
            viewButton
        ])
        viewButton.addSubviews([
            buttonAgree,
            labelButton
        ])
        
        labelTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        viewContent.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
            make.bottom.equalTo(viewButton.snp.top).offset(-30)
        }
        
        viewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(55)
            make.width.equalToSuperview().offset(-30)
        }
        buttonAgree.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        labelButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    


}
