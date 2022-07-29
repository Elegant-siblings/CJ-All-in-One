//
//  LoadViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    let nums = [1,1,2,2,3,3,1,2]
    let lists:[Item] = []
    
    lazy var viewVehicleImageContainer = UIImageView(image: UIImage(named: "imageVehicle.png")).then {
//        $0.backgroundColor = .CjBlue
        $0.layer.borderColor = UIColor.CjBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 30
    }
    
    lazy var buttonComplete = MainButton(type: .main).then {
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
            make.top.equalTo(mainButtonTopOffset)
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
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
