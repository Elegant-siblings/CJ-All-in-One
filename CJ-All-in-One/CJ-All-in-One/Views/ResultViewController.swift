//
//  ResultViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import Then
import NMapsMap

struct Item {
    let id: Int
    let category: String
    let From: String
    let To: String
}



class ResultViewController: UIViewController {
    
    // -MARK: Constants
    let terminalAddress = "서울특별시 서초구 양재동 225-5"
    let time = "오전 7:00"
    let fontsizeTerminalLabel = CGFloat(15)
    let cnt = 20
    let gae = " 개"
    let locations = ["서울", "경기", "인천"]
    let lists = [
        Item(id: 1, category: "식품", From: "부산시 금정구", To: "부산시 북구 화명신도시로"),
        Item(id: 2, category: "식품", From: "부산시 금정구", To: "부산시 금정구 장전대로"),
        Item(id: 3, category: "식품", From: "부산시 금정구", To: "부산시 사상구 낙동대로"),
        Item(id: 4, category: "식품", From: "부산시 금정구", To: "부산시 부산진구 금융사거리로"),
        Item(id: 5, category: "식품", From: "부산시 금정구", To: "부산시 해운대구 신세계백화점로"),
        Item(id: 6, category: "식품", From: "부산시 금정구", To: "부산시 동래구 자고싶다로"),
        Item(id: 7, category: "식품", From: "부산시 금정구", To: "부산시 북구 강강술래"),
        Item(id: 8, category: "잡화", From: "부산시 금정구", To: "부산시 기장군 소고기사묵겠지로")
    ]
    
    // -MARK: UIViews
    lazy var viewTerminalInfo = UIView()
    lazy var viewTermImage = UIView().then {
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 30
    }
    lazy var viewDivideLine = UIView().then {
        $0.backgroundColor = .borderColor
    }
    
    // -MARK: UILabels
    lazy var labelTermInfoTitle = UILabel().then {
        $0.text = "터미널 정보"
        $0.font = .systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelTermAddress = UILabel().then {
        $0.text = terminalAddress
        $0.font = .systemFont(ofSize: fontsizeTerminalLabel, weight: .semibold)
    }
    lazy var labelTime = UILabel().then {
        $0.text = time
        $0.font = .systemFont(ofSize: fontsizeTerminalLabel, weight: .semibold)
    }
    lazy var labelTotal = UILabel().then {
        $0.text = "총 \(cnt)개"
        $0.font = .systemFont(ofSize: fontsizeTerminalLabel, weight: .semibold)
    }
    lazy var labelTos = UILabel().then {
        $0.text = ""
        for lo in locations {
            $0.text! += lo
            if lo != locations.last {
                $0.text! += ", "
            }
        }
        $0.font = .systemFont(ofSize: fontsizeTerminalLabel, weight: .semibold)
    }
    
    // -MARK: Others
    lazy var tableItem = ListTableView(rowHeight: 35, scrollType: .none).then {
        $0.dataSource = self
        $0.register(ResultItemsTableViewCell.self, forCellReuseIdentifier: ResultItemsTableViewCell.identifier)
        $0.alwaysBounceVertical = false
        $0.bounces = $0.contentOffset.y > 0
    }
    lazy var buttonArrived = PrimaryButton(title: "터미널 도착").then {
        $0.addTarget(self, action: #selector(touchUpArrivedButton), for: .touchUpInside)
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
    super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        
        view.addSubviews([
            viewTerminalInfo,
            labelTotal,
            labelTos,
            tableItem,
            buttonArrived
        ])
        
        viewTerminalInfo.addSubviews([
            labelTermInfoTitle,
            viewTermImage,
            labelTermAddress,
            labelTime,
            viewDivideLine
        ])
//        viewTerminalInfo.backgroundColor = .CjRed
        
        // -MARK: Make Constraints
        viewTerminalInfo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(40)
            make.height.equalTo(370)
        }
        labelTermInfoTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        viewTermImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelTermInfoTitle.snp.bottom).offset(15)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(235)
        }
        labelTermAddress.snp.makeConstraints { make in
            make.trailing.equalTo(viewTermImage).offset(-13)
            make.top.equalTo(viewTermImage.snp.bottom).offset(15)
        }
        labelTime.snp.makeConstraints { make in
            make.trailing.equalTo(labelTermAddress)
            make.top.equalTo(labelTermAddress.snp.bottom).offset(8)
        }
        viewDivideLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-60)
        }
        
        labelTotal.snp.makeConstraints { make in
            make.top.equalTo(viewDivideLine).offset(11)
            make.trailing.equalTo(labelTermAddress)
        }
        labelTos.snp.makeConstraints { make in
            make.top.equalTo(labelTotal.snp.bottom).offset(8)
            make.trailing.equalTo(labelTotal)
        }
        tableItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(210)
            make.top.equalTo(labelTos.snp.bottom).offset(15)
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
        let vc = LoadViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultItemsTableViewCell.identifier, for: indexPath) as! ResultItemsTableViewCell
        if indexPath.row == 0 {
            cell.backgroundColor = .firstRowBackgroundColor
            cell.labelNum.text = "#"
            cell.labelCategory.text = "상품종류"
            cell.labelReceivAddr.text = "배송지"
        }
        else {
            cell.backgroundColor = .CjWhite
            cell.labelNum.text = "\(indexPath.row)"
            cell.labelCategory.text = lists[indexPath.row-1].category
            cell.labelReceivAddr.text = lists[indexPath.row-1].To
//            cell.labelTo.textAlignment = .left
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
