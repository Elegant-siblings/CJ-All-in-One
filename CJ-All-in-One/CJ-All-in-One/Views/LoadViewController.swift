//
//  LoadViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    let lists = [
        Item(id: 1, category: "식품", From: "부산시 금정구", To: "부산시 북구 화명신도시로"),
//        Item(id: 2, category: "식품", From: "부산시 금정구", To: "부산시 금정구 장전대로"),
//        Item(id: 3, category: "식품", From: "부산시 금정구", To: "부산시 사상구 낙동대로"),
//        Item(id: 4, category: "식품", From: "부산시 금정구", To: "부산시 부산진구 금융사거리로"),
//        Item(id: 5, category: "식품", From: "부산시 금정구", To: "부산시 해운대구 신세계백화점로"),
//        Item(id: 6, category: "식품", From: "부산시 금정구", To: "부산시 동래구 자고싶다로"),
//        Item(id: 7, category: "식품", From: "부산시 금정구", To: "부산시 북구 강강술래"),
//        Item(id: 8, category: "잡화", From: "부산시 금정구", To: "부산시 기장군 소고기사묵겠지로")
    ]
    
    let nums = [1,1,2,2,3,3,1,2]
    
    lazy var viewVehicleImageContainer = UIImageView(image: UIImage(named: "imageVehicle.png")).then {
//        $0.backgroundColor = .CjBlue
        $0.layer.borderColor = UIColor.CjBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 30
    }
    
    lazy var buttonComplete = MainButton(type: .main).then {
        $0.isEnabled = true
        $0.setTitle("물품 적재 완료", for: .normal)
        $0.addTarget(self, action: #selector(touchUpCompleteButton), for: .touchUpInside)
    }
    
    lazy var tableItem = ListTableView(rowHeight: 35, scrollType: .none).then {
        $0.dataSource = self
        $0.register(LoadItemTableViewCell.self, forCellReuseIdentifier: LoadItemTableViewCell.identifier)
        $0.alwaysBounceVertical = false
        $0.bounces = $0.contentOffset.y > 0
    }
    
    lazy var labelItemLoadTitle = UILabel().then {
        $0.text = "터미널 정보"
        $0.font = .systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    
    lazy var imageVehicle = UIImage(named: "imageVehicle")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        view.addSubviews([
            labelItemLoadTitle,
            viewVehicleImageContainer,
            tableItem,
            buttonComplete
        ])
        
        labelItemLoadTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        viewVehicleImageContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelItemLoadTitle.snp.bottom).offset(15)
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        
        tableItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(200)
            make.top.equalTo(viewVehicleImageContainer.snp.bottom).offset(15)
        }

        buttonComplete.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(755)
            make.width.equalTo(primaryButtonWidth)
            make.height.equalTo(primaryButtonHeight)
        }
    }
    
    @objc func touchUpCompleteButton() {
        print("적재 완료")
    }
}

extension LoadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoadItemTableViewCell.identifier, for: indexPath)
        if indexPath.row == 0 {
            cell.backgroundColor = .firstRowBackgroundColor
        }
        else {
            cell.backgroundColor = .CjWhite
        }
        
        return cell
    }
    
    
}
