//
//  ResultViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import Then
import NMapsMap

class ResultViewController: UIViewController {
    
    // -MARK: Constants
    let itemListDataManager = ItemListDataManager()
    var task: Task = Task(workPK: 0, deliveryDate: "", deliveryType: "", deliveryTime: "", deliveryCar: "", terminalAddr: "", workState: 0, comment: "")
    var itemList: [Item] = []
    let terminalAddress = "서울특별시 서초구 양재동 225-5"
    let time = "오전 7:00"
    let fontsizeTerminalLabel = CGFloat(15)
    let cnt = 0
    let gae = " 개"
    let locations = ["서울", "경기", "인천"]
    
    // -MARK: UIViews
    lazy var navBar = CustomNavigationBar()
    lazy var viewTerminalInfo = UIView()
    lazy var viewTermImage = UIView().then {
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 30
    }
    lazy var viewDivideLine = UIView().then {
        $0.backgroundColor = .borderColor
    }
    lazy var viewButtonsContainer = UIView()
    
    // -MARK: UILabels
    lazy var labelTermInfoTitle = UILabel().then {
        $0.text = "터미널 정보"
        $0.font = .systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .CjWhite
    }
    lazy var labelTermAddress = UILabel().then {
        $0.text = task.terminalAddr
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
    lazy var labelCommentTitle = UILabel().then {
        $0.text = "취소 사유"
        $0.textColor = .CjRed
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textAlignment = .center
    }
    lazy var labelComment = UILabel().then {
        $0.text = task.comment
//        $0.text = "2022.07.29. 오후 4:06:32에 모집 취소하였음."
        $0.textColor = .primaryFontColor
        $0.font = .systemFont(ofSize: 20, weight: .bold)
//        $0.backgroundColor = .red
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.lineBreakMode = .byCharWrapping
    }
    
    // -MARK: Others
    lazy var tableItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(ResultItemsTableViewCell.self, forCellReuseIdentifier: ResultItemsTableViewCell.identifier)
    }
    lazy var buttonArrived = MainButton(type: .main).then {
        $0.setTitle("터미널 도착", for: .normal)
        $0.addTarget(self, action: #selector(touchUpArrivedButton), for: .touchUpInside)
    }
    lazy var buttonCancel = MainButton(type: .main).then {
        $0.setTitle("취소", for: .normal)
        $0.setBackgroundColor(.CjRed, for: .normal)
        $0.addTarget(self, action: #selector(touchUpCancelButton), for: .touchUpInside)
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
    super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        self.navigationController?.navigationBar.tintColor = .CjWhite
        
        view.addSubviews([
            navBar,
            labelTermInfoTitle,
            viewTerminalInfo,
            viewButtonsContainer
        ])
        
        viewTerminalInfo.addSubviews([
            viewTermImage,
            labelTermAddress,
            labelTime,
            viewDivideLine
        ])
        viewButtonsContainer.addSubviews([
            buttonArrived,
            buttonCancel
        ])
        
        
        
        switch task.deliveryTime {
        case "주간":
            labelTime.text = "오전 9:00"
        case "새벽":
            labelTime.text = "오전 1:00"
        default:
            labelTime.text = ""
        }
        
        // -MARK: Make Constraints
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        viewTerminalInfo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.height.equalTo(308)
        }
        labelTermInfoTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(navBar).offset(-10)
        }
        viewTermImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
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
        
        viewButtonsContainer.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
            make.top.equalTo(self.view.snp.top).offset(mainButtonTopOffset)
        }
        buttonArrived.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(mainButtonWidth-80)
        }
        buttonCancel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(buttonArrived.snp.trailing).offset(5)
        }
        
        if task.workState == 0 {
            itemListDataManager.getItemList(self, pk: task.workPK)
            view.addSubviews([
                labelTotal,
                labelTos,
                tableItem,
            ])
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
        }
        else {
            view.addSubviews([labelCommentTitle,labelComment])
            labelCommentTitle.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(viewDivideLine).offset(30)
            }
            labelComment.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(labelCommentTitle.snp.bottom).offset(10)
                make.width.equalTo(viewTermImage).offset(-70)
            }
            buttonArrived.isEnabled = false
            buttonCancel.isEnabled = false
        }
    }
    // -MARK: selectors
    @objc func touchUpArrivedButton() {
        print("터미널 도착")
        let vc = LoadViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func touchUpCancelButton() {
        print("취소")
        let updateDataManager = UpdateDataManager()
        updateDataManager.updateWorkState(workPK: task.workPK, workState: 1)
    }
    
    func successGetItemList(result: [Item]) {
        itemList = result
        labelTotal.text = "총 \(result.count)개"
        var cities: [String] = []
        _ = result.map { item in
            cities.append(item.receiverAddr.components(separatedBy: " ")[0])
        }
        let set = Set(cities)
        let city = Array(set)
        var cityText = ""
        for i in city {
            cityText += i+","
        }
        _ = cityText.popLast()
        labelTos.text = cityText
        tableItem.reloadData()
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultItemsTableViewCell.identifier, for: indexPath) as! ResultItemsTableViewCell
        cell.backgroundColor = .CjWhite
        cell.labelNum.text = "\(indexPath.row+1)"
        cell.labelCategory.text = itemList[indexPath.row].itemCategory
        cell.labelReceivAddr.text = itemList[indexPath.row].receiverAddr
        cell.selectionStyle = .none
        return cell
    }
}
