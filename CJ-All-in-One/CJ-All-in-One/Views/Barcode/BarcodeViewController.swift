//
//  BarcodeViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit
import AVFoundation
import SnapKit

class BarcodeViewController: UIViewController {
    
    let fontSizeAgree = CGFloat(14)
    var isAgree = 0
    var terminalAddr = ""
    var workPK: Int?
    var checklist: [Bool] = []
    var lists:[Item] = [
//        Item(deliveryPK: 0, sender: "597e0212ad0264aa8a027767753a11c9", receiver: "cf278a94ab97933c4a75d78b9faea846", itemCategory: "식품", senderAddr: "전남 순천시 조례동", receiverAddr: "서울 서대문구 연희맛로")
    ]

    
    //-MARK: UIViews
    lazy var navBar = CustomNavigationBar(title: "배송 물품 등록")
    lazy var viewBarcodeReader = UIView().then {
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 30
    }
    lazy var viewDivideLine = UIView().then {
        $0.backgroundColor = .borderColor
    }
    
    // -MARK: UILabels
    lazy var labelBarcodeScan = UILabel().then {
        $0.text = "바코드 스캔"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var readerView = ReaderView().then{
        $0.delegate = self
    }
    
    // -MARK: UIButton
    lazy var buttonRead = UIButton().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(touchUpReadButton(sender:)), for: .touchUpInside)
    }
    lazy var buttonAgree = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = UIColor(hex: 0xCCCCCC)
        $0.setAttributedTitle(
            NSMutableAttributedString(
                string: " 물품 다 챙긴거 같으니 책임은 모두 내가 진다 어쩌구 동의",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor(hex: 0xCCCCCC),
                    NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: fontSizeAgree)
                ]),
            for: .normal
        )
        $0.setAttributedTitle(
            NSMutableAttributedString(
                string: " 물품 다 챙긴거 같으니 책임은 모두 내가 진다 어쩌구 동의",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                    NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: fontSizeAgree)
                ]),
            for: .highlighted
        )
        $0.addTarget(self, action: #selector(touchUpAgreeButton(_:)), for: .touchUpInside)
    }
    lazy var buttonComplete = MainButton(type: .main).then {
        $0.isEnabled = false
        $0.setTitle("물품 스캔 완료", for: .normal)
        $0.addTarget(self, action: #selector(touchUpCompleteButton), for: .touchUpInside)
    }
    
    lazy var tableScanItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(ScanItemTableViewCell.self, forCellReuseIdentifier: ScanItemTableViewCell.identifier)
        let labelNum = MainLabel(type: .table).then {
            $0.textAlignment = .center
            $0.text = "#"
        }
        let labelCategory = MainLabel(type: .table).then {
            $0.text = "상품종류"
        }
        let labelReceivAddr = MainLabel(type: .table).then {
            $0.textAlignment = .center
            $0.text = "배송지"
        }
        let labelCheck = MainLabel(type: .table).then {
            $0.text = "확인"
        }
        $0.tableHeaderView?.addSubviews([labelNum,labelCategory,labelReceivAddr,labelCheck])
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(20)
        }
        labelCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(70)
        }
        labelReceivAddr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(130)
            make.width.equalTo(160)
        }
        labelCheck.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        navigationController?.navigationBar.tintColor = .CjWhite
        
        view.addSubviews([
            navBar,
            labelBarcodeScan,
            viewBarcodeReader,
            viewDivideLine,
//            buttonRead,
            tableScanItem,
            buttonAgree,
            buttonComplete
            
        ])
        
        checklist = Array(repeating: false, count: lists.count)
        checklist[1] = true
        
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        labelBarcodeScan.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(20)
        }
        viewBarcodeReader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelBarcodeScan.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(230)
        }
        viewDivideLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(viewBarcodeReader.snp.bottom).offset(30)
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-50)
        }
        tableScanItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(viewDivideLine.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(200)
        }
        buttonAgree.snp.makeConstraints { make in
            make.bottom.equalTo(buttonComplete.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(buttonComplete)
            make.height.equalTo(20)
        }
        buttonComplete.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
            make.top.equalTo(mainButtonTopOffset)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.readerView.isRunning {
            self.readerView.stop(isButtonTap: false)
        }
    }
    
    // -MARK: Selectors
    @objc func touchUpReadButton(sender: UIButton) {
        if self.readerView.isRunning {
            self.readerView.stop(isButtonTap: true)
        } else {
            self.readerView.start()
        }

        sender.isSelected = self.readerView.isRunning
    }
    
    @objc func touchUpAgreeButton(_ button: UIButton) {
        switch isAgree {
        case 0:
            isAgree = 1
            button.tintColor = UIColor(hex: 0x888585)
            button.setAttributedTitle(
                    NSMutableAttributedString(
                        string: " 물품 다 챙긴거 같으니 책임은 모두 내가 진다 어쩌구 동의",
                        attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor(hex: 0x888585),
                            NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: fontSizeAgree)
                        ]),
                    for: .normal
                )
            buttonComplete.isEnabled = true
        default:
            isAgree = 0
            button.tintColor = UIColor(hex: 0xCCCCCC)
            button.setAttributedTitle(
                NSMutableAttributedString(
                    string: " 물품 다 챙긴거 같으니 책임은 모두 내가 진다 어쩌구 동의",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor(hex: 0xCCCCCC),
                        NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: fontSizeAgree)
                    ]),
                for: .normal
            )
            buttonComplete.isEnabled = false
        }
    }
    
    @objc func touchUpCompleteButton() {
        let alert = UIAlertController(title: "바코드 스캔을 완료하시겠습니까?", message: "넘어가면 누락된 물품 다시 등록 못 함 ㅅㄱ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) {(_) in
            let vc = LoadViewController()
            vc.lists = self.lists
            vc.terminalAddr = self.terminalAddr
            vc.workPK = self.workPK
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension BarcodeViewController: ReaderViewDelegate {
    func readerComplete(status: ReaderStatus) {

        var title = ""
        var message = ""
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
                self.buttonRead.isSelected = readerView.isRunning
            } else {
                self.buttonRead.isSelected = readerView.isRunning
                return
            }
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension BarcodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScanItemTableViewCell.identifier, for: indexPath) as! ScanItemTableViewCell
        cell.backgroundColor = .CjWhite
        cell.labelNum.text = "\(indexPath.row+1)"
        cell.labelCategory.text = lists[indexPath.row].itemCategory
        cell.labelReceivAddr.text = lists[indexPath.row].receiverAddr
        
        switch checklist[indexPath.row] {
        case true:
            cell.imageState.image = UIImage(systemName: "checkmark.circle.fill")
            cell.imageState.tintColor = .CjGreen
        default:
            cell.imageState.image = UIImage(systemName: "minus.circle.fill")
            cell.imageState.tintColor = .CjRed
        }
        cell.selectionStyle = .none
        return cell
    }
}
