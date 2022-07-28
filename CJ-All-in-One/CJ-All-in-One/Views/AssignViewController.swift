//
//  AssignViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit

class AssignViewController: UIViewController {
    
    // -MARK: Constants
    var viewedItems:[Row] = []
    var selectedItems:[Row] = []
    var date = ""
    var toLists: [Location] = []
    var applyForm: ApplyDataModel?
    
    // -MARK: UILabels
    lazy var labelTitle = UILabel().then {
        $0.text = "조회된 업무"
        $0.font = .systemFont(ofSize: 23, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    
    // -MARK:
    lazy var tableViewedItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(AssignedTableViewCell.self, forCellReuseIdentifier: AssignedTableViewCell.identifier)
        
        let labelNum = UILabel().then {
            $0.text = "#"
        }
        let labelCategory = UILabel().then {
            $0.text = "상품종류"
        }
        let labelReceivAddr = UILabel().then {
            $0.text = "배송지"
        }
        $0.tableHeaderView?.addSubviews([
            labelNum,labelCategory,labelReceivAddr
        ])
        _ = [labelNum, labelCategory, labelReceivAddr].map {
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.width.equalTo(35)
        }
        labelCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelNum.snp.trailing).offset(3)
            make.width.equalTo(60)
        }
        labelReceivAddr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelCategory.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    lazy var tableSelectedItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(AssignedTableViewCell.self, forCellReuseIdentifier: AssignedTableViewCell.identifier)
        
        let labelNum = UILabel().then {
            $0.text = "#"
        }
        let labelCategory = UILabel().then {
            $0.text = "상품종류"
        }
        let labelReceivAddr = UILabel().then {
            $0.text = "배송지"
        }
        $0.tableHeaderView?.addSubviews([
            labelNum,labelCategory,labelReceivAddr
        ])
        _ = [labelNum, labelCategory, labelReceivAddr].map {
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        labelNum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.width.equalTo(35)
        }
        labelCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelNum.snp.trailing).offset(3)
            make.width.equalTo(60)
        }
        labelReceivAddr.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelCategory.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in viewDidLoad")
        print(applyForm!)
        print(date, toLists)
        view.backgroundColor = .CjWhite
        
        let dataManager = ApplyDataManager()
        dataManager.getAssignedItems(date: date, locations: toLists, self)
        
        view.addSubviews([
            labelTitle
        ])
        view.addSubviews([
            tableViewedItem,
            tableSelectedItem
        ])
        labelTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        tableViewedItem.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelTitle.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(150)
        }
        tableSelectedItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableViewedItem.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(tableSelectedItem.rowHeight)
        }
    }
}
// -MARK: extensions
extension AssignViewController {
    func successAssignItems(_ result: [Row]) {
        viewedItems = result
        tableViewedItem.reloadData()
    }
}

// -MARK: extension tableViewDataSource
extension AssignViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableViewedItem:
            return viewedItems.count
        case tableSelectedItem:
            return selectedItems.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssignedTableViewCell.identifier, for: indexPath) as! AssignedTableViewCell

        if tableView == tableViewedItem {
            cell.buttonType = .add
            cell.pk = viewedItems[indexPath.row].deliveryPK
            cell.labelCategory.text = viewedItems[indexPath.row].itemCategory
            cell.labelReceivAddr.text = viewedItems[indexPath.row].receiverAddr
        }
        else {
            cell.buttonType = .remove
            cell.pk = selectedItems[indexPath.row].deliveryPK
            cell.labelCategory.text = selectedItems[indexPath.row].itemCategory
            cell.labelReceivAddr.text = selectedItems[indexPath.row].receiverAddr
        }
        cell.cellDelegate = self
        cell.rowIndex = indexPath.row
        cell.backgroundColor = .CjWhite
        cell.labelNum.text = "\(indexPath.row+1)"

        cell.selectionStyle = .none
        return cell
    }
}

extension AssignViewController: AssignCellDelegate {
    func addItems(sender: UIButton, index: Int) {
        sender.isEnabled = false
        selectedItems.append(viewedItems[index])
        tableSelectedItem.snp.updateConstraints { make in
            make.height.equalTo(tableSelectedItem.contentSize.height+tableSelectedItem.rowHeight)
        }
        tableSelectedItem.beginUpdates()
        tableSelectedItem.insertRows(at: [IndexPath(row: selectedItems.count-1, section: 0)], with: .top)
        tableSelectedItem.endUpdates()

    }
    
    func removeItems(sender: UIButton, index: Int) {
        let viewedIndex = viewedItems.firstIndex { Row in
            Row == selectedItems[index]
        }
        selectedItems.remove(at: index)
        tableSelectedItem.beginUpdates()
        tableSelectedItem.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
        tableSelectedItem.reloadData()
        tableSelectedItem.endUpdates()
    
        if let cell = tableViewedItem.cellForRow(at: IndexPath(row: viewedIndex ?? 0, section: 0)) as? AssignedTableViewCell {
            cell.button.isEnabled = true
        }
    }
}
