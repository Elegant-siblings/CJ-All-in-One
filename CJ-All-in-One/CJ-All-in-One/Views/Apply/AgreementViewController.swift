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
    lazy var scrollView = UIScrollView()
    lazy var labelContent = UILabel().then {
        $0.text = "우아한 남매들에서는 「개인정보보호법」에 의거하여, 아래와 같은 내용으로 개인정보를 수집하고 있습니다. 귀하께서는 아래 내용을 자세히 읽어 보시고, 모든 내용을 이해하신 후에 동의 여부를 결정해 주시기 바랍니다.\n \nⅠ. 개인정보의 수집 및 이용 동의서\n   - 이용자가 제공한 모든 정보는 다음의 목적을 위해 활용하며, 하기 목적 이외의 용도로는 사용되지 않습니다.\n     \n① 개인정보 수집 항목 및 수집·이용 목적\n   가) 수집 항목 (필수항목)\n     - 성명(국문), 주민등록번호, 주소, 전화번호(자택, 휴대전화), 사진, 이메일, 나이, 재학정보, 병역사항, 외국어 점수, 가족관계, 재산정도, 수상내역, 사회활동, 타 장학금 수혜현황, 요식업 종사 현황 등 지원 신청서에 기재된 정보 또는 신청자가 제공한 정보\n   나) 수집 및 이용 목적\n     - 하이트진로 장학생 선발 전형 진행 \n     - 하이트진로 장학생과의 연락 및 자격확인\n   - 하이트진로 장학생 자원관리\n      \n② 개인정보 보유 및 이용기간\n   - 수집·이용 동의일로부터 개인정보의 수집·이용목적을 달성할 때까지\n     \n③ 동의거부관리\n   - 귀하께서는 본 안내에 따른 개인정보 수집, 이용에 대하여 동의를 거부하실 권리가 있습니다. 다만, 귀하가 개인정보의 수집/이용에 동의를 거부하시는 경우에 장학생 선발 과정에 있어 불이익이 발생할 수 있음을 알려드립니다.\n\nⅡ. 고유식별정보 처리 동의서\n  ① 고유식별정보 수집 항목 및 수집·이용 목적\n   가) 수집 항목 (필수항목)\n   - 주민등록번호\n         \n   나) 수집 및 이용 목적\n   - 하이트진로 장학생 선발 전형 진행\n   - 하이트진로 장학생과의 연락 및 자격확인\n   - 하이트진로 장학생 자원관리\n         \n ② 개인정보 보유 및 이용기간\n   - 수집·이용 동의일로부터 개인정보의 수집·이용목적을 달성할 때까지\n         \n ③ 동의거부관리\n   - 귀하께서는 본 안내에 따른 개인정보 수집, 이용에 대하여 동의를 거부하실 권리가 있습니다. 다만, 귀하가 개인정보의 수집/이용에 동의를 거부하시는 경우에 장학생 선발 과정에 있어 불이익이 발생할 수 있음을 알려드립니다."
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    lazy var viewLabelContent = UIView()
    lazy var labelTitle = UILabel().then {
        $0.text = agreeTitle
        $0.textColor = .primaryFontColor
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 30)
    }
    lazy var labelButton = UILabel().then {
        $0.text = "위 약관에 동의합니다."
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 20)
        $0.textColor = .CjWhite
    }
    
    lazy var buttonAgree = UIButton().then {
        $0.addTarget(self, action: #selector(touchUpAgreeButton), for: .touchUpInside)
    }
    
    @objc func touchUpAgreeButton() {
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
//        scrollView.addSubview(viewContent)
        viewContent.addSubviews([scrollView])
        scrollView.addSubviews([labelContent])
//        viewLabelContent.addSubviews([labelContent])
        
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
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        labelContent.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-15)
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
