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
    
    let scanDataManager = ScanDataManager()
    let fontSizeAgree = CGFloat(14)
    var isAgree = 0
    var terminalAddr = ""
    var workPK: Int?
    var checklist: [Bool] = []
    var randomIndex = 0
    var lists:[Item] = [
//        Item(deliveryPK: 0, sender: "597e0212ad0264aa8a027767753a11c9", receiver: "cf278a94ab97933c4a75d78b9faea846", itemCategory: "식품", senderAddr: "전남 순천시 조례동", receiverAddr: "서울 서대문구 연희맛로")
    ]

    
    //-MARK: UIViews
    lazy var navBar = CustomNavigationBar(title: "배송 물품 등록")
    lazy var viewBarcodeReader = UIView().then {
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
    lazy var readerView = ReaderView(frame: CGRect(x: view.frame.width/4, y: view.frame.height/4, width: 330, height: 220)).then{
        $0.delegate = self
        $0.layer.cornerRadius = 30
    }
    
    // -MARK: UIButton
    lazy var buttonRead = UIButton().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(touchUpReadButton(sender:)), for: .touchUpInside)
        $0.backgroundColor = .CjBlue
        $0.setTitle("물품 스캔", for: .normal)
    }
    lazy var buttonAgree = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = UIColor(hex: 0xCCCCCC)
        $0.setTitle(" 확인 및 수령을 완료하였고, 이에 대한 책임은 본인에 있음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: fontSizeAgree, weight: .bold)
        $0.setTitleColor(UIColor(hex: 0xCCCCCC), for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
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
        readerView.backgroundColor = .opaqueSeparator
        view.addSubviews([
            navBar,
            labelBarcodeScan,
            viewBarcodeReader,
            viewDivideLine,
            buttonRead,
            tableScanItem,
            buttonAgree,
            buttonComplete
            
        ])
        
        viewBarcodeReader.addSubview(readerView)
        
        checklist = Array(repeating: false, count: lists.count)
        
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
            make.width.equalTo(330)
            make.height.equalTo(220)
        }
        readerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        buttonRead.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(viewBarcodeReader.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        viewDivideLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonRead.snp.bottom).offset(15)
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
            button.setTitleColor(UIColor(hex: 0x888585), for: .normal)
            buttonComplete.isEnabled = true
        default:
            isAgree = 0
            button.tintColor = UIColor(hex: 0xCCCCCC)
            button.setTitleColor(UIColor(hex: 0xCCCCCC), for: .normal)
            buttonComplete.isEnabled = false
        }
    }
    
    @objc func touchUpCompleteButton() {
        let alert = UIAlertController(title: "바코드 스캔을 완료하시겠습니까?", message: "누락된 물품은 다시 등록하지 못 합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) {(_) in
            let vc = LoadViewController()
            
            vc.terminalAddr = self.terminalAddr
            vc.workPK = self.workPK
            var scanned: [Item] = []
            var missing: [Int] = []
            self.lists.enumerated().forEach {
                if self.checklist[$0] == true {
                    scanned.append($1)
                }
                else {
                    missing.append($1.deliveryPK)
                }
            }
            self.scanDataManager.sendMissingItems(deliveryPK: missing)
            vc.lists = scanned
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
            
            if randomIndex < lists.count {
                checklist[randomIndex] = true
                tableScanItem.reloadData()
                randomIndex += 1
            }
            print(checklist)
            
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
        print(message)
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
