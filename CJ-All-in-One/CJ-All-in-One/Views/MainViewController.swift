//
//  ViewController.swift
//  CJ-All-in-One
//
//  Created by 최원준 on 2022/07/24.
//

import UIKit
import SnapKit
import NMapsMap
import Then
import Alamofire
import PanModal

class MainViewController: UIViewController {
    
    // -MARK: variables
    var lists = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh"]
    let detailTypes = ["모집내역", "배송내역"]
    let taskDataManager = TaskDataManager()
    var taskList:[Task] = []
    
    // -MARK: UIViews
    lazy var navBar = CustomNavigationBar().then {
        $0.backgroundColor = .deppBlue
    }
    
    lazy var uiTableContainer = UIView().then{
        $0.backgroundColor = .red
    }
    
    lazy var uiApplyButtonContainer = UIView().then{
        $0.backgroundColor = .CjWhite
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
    }
    
    lazy var distributeBar = UIView().then{
        $0.backgroundColor = UIColor(rgb: 0xB4B4B4)
    }
    
    // -MARK: UIButtons
    lazy var buttonApply = MainButton(type: .main).then{
        $0.setTitle("모집 신청하기", for: .normal)
        $0.addTarget(self, action: #selector(touchUpApplyButton), for: .touchUpInside)
    }
    
    lazy var buttonSort = MainButton(type: .main).then{
        $0.backgroundColor = .CjWhite
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor(rgb: 0x8B8B8B).cgColor
        $0.layer.borderWidth = 0.5
        let customButtonLabel = NSMutableAttributedString(
            string: " 정렬",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x8B8B8B),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10,weight: .bold)
            ])
        $0.setAttributedTitle(customButtonLabel, for: .normal)
        $0.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        $0.tintColor = UIColor(rgb: 0x8B8B8B)
    }
    
    // -MARK: Others
    lazy var tableHistory = UITableView().then{
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.register(DeliveryDetailTableViewCell.self, forCellReuseIdentifier: DeliveryDetailTableViewCell.identifier)
        $0.rowHeight = 100
        $0.backgroundColor = .CjWhite
    }
    
    lazy var SCDetailType = UISegmentedControl(items: detailTypes).then{
        $0.backgroundColor = .CjWhite
        $0.layer.cornerRadius = 3
        $0.selectedSegmentTintColor = .CjRed
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.CjRed, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        let backgroundImage = UIImage()
        let colorView = UIView()
        colorView.backgroundColor = .CjRed
        $0.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)

        $0.selectedSegmentIndex = 0
        $0.apportionsSegmentWidthsByContent = false
        $0.addTarget(self, action: #selector(detailTypeChanged(type:)), for: UIControl.Event.valueChanged)
    }
    
    // -MARK: selectors
    @objc
    func detailTypeChanged(type: UISegmentedControl) {
        print(detailTypes[type.selectedSegmentIndex])
    }
    
    @objc func touchUpApplyButton() {
        print("모집 신청하기")
        navigationController?.pushViewController(ApplyViewController(), animated: true)
    }

    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .CjWhite
        taskDataManager.getTasks(self)
        
        self.view.addSubviews([
            navBar,
            SCDetailType,
            buttonSort,
            distributeBar,
            uiTableContainer,
            uiApplyButtonContainer,
            buttonApply
        ])
        
        self.uiTableContainer.addSubview(tableHistory)
        setConstraints()
    }

    // -MARK: makeConstraints
    private func setConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        SCDetailType.snp.makeConstraints { make in
            make.leading.equalTo(21)
            make.top.equalTo(100)
            make.height.equalTo(23)
            make.width.equalTo(130)
        }
        
        buttonSort.snp.makeConstraints { make in
            make.centerY.equalTo(SCDetailType)
            make.leading.equalTo(314)
            make.height.equalTo(SCDetailType)
            make.width.equalTo(52)
        }
        
        distributeBar.snp.makeConstraints { make in
            make.top.equalTo(132)
            make.leading.equalTo(21)
            make.height.equalTo(1)
            make.width.equalTo(345)
        }
        
        uiTableContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(141)
            make.width.equalToSuperview()
            make.bottom.equalTo(uiApplyButtonContainer.snp.top)
        }
        
        uiApplyButtonContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(116)
            make.bottom.equalToSuperview()
        }
        buttonApply.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(mainButtonTopOffset)
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
        }
        tableHistory.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}



// -MARK: Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailTableViewCell.identifier, for: indexPath) as! DeliveryDetailTableViewCell
        let background = UIView().then{
            $0.backgroundColor = .clear
        }
        cell.detailDelegate = self
        cell.selectedBackgroundView = background
        cell.backgroundColor = .CjWhite
        return cell
    }
}

extension MainViewController: DetailDelegate {
    func getTaskDetail() {
        let vc = ResultViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController {
    func successGetTasks(result: [Task]) {
        taskList = result
        tableHistory.reloadData()
    }
}
