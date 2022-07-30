//
//  AssignViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit

class AssignViewController: UIViewController {
    
    // -MARK: Constants
    let dataManager = ApplyDataManager()
    
    var viewedItems:[Row] = []
    var selectedItems:[Row] = []
    var date = ""
    var toLists: [Location] = []
    var applyForm: ApplyDataModel?
    var addButtonEnabled: [Int] = []
    var isAgree = 0
    
    lazy var navBar = CustomNavigationBar(title: "업무 조회")
    
    // -MARK: UILabels
    lazy var labelViewedTitle = UILabel().then {
        $0.text = "조회된 업무"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelSelectedTitle = UILabel().then {
        $0.text = "선택된 업무"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .primaryFontColor
    }
    lazy var labelSelectedCount = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .primaryFontColor
    }
    lazy var labelViewedCount = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .primaryFontColor
    }
    lazy var labelAgreement = UILabel().then {
        $0.text = "위탁 계약서"
        $0.textColor = UIColor(hex: 0x888585)
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    // -MARK: UITableViews
    lazy var tableViewedItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(AssignedTableViewCell.self, forCellReuseIdentifier: AssignedTableViewCell.identifier)
    }
    
    lazy var tableSelectedItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(AssignedTableViewCell.self, forCellReuseIdentifier: AssignedTableViewCell.identifier)
    }
    
    // -MARK: UIBUtton
    lazy var buttonAgree = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = .CjRed
        $0.addTarget(self, action: #selector(touchUpAgreeButton), for: .touchUpInside)
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.layer.cornerRadius = 3
        let customButtonLabel = NSMutableAttributedString(string: " 동의 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.CjRed, NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: 15)])
        $0.setAttributedTitle(customButtonLabel, for: .normal)
        
    }
    lazy var buttonApply = MainButton(type: .main).then {
        $0.setTitle("업무 신청하기", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(touchUpApplyButton), for: .touchUpInside)
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("in viewDidLoad")
//        print(applyForm!)
//        print(date, toLists)
        view.backgroundColor = .CjWhite
        

        dataManager.getAssignedItems(date: date, locations: toLists, self)
        
        view.addSubviews([
            navBar,
            labelViewedTitle,
            labelViewedCount,
            labelSelectedTitle,
            labelSelectedCount,
            tableViewedItem,
            tableSelectedItem,
            labelAgreement,
            buttonAgree,
            buttonApply
        ])
        
        _ = [tableViewedItem, tableSelectedItem].map { table in
            let labelNum = MainLabel(type: .table).then {
                $0.text = "#"
                $0.textAlignment = .center
            }
            let labelCategory = MainLabel(type: .table).then {
                $0.text = "상품종류"
                $0.textAlignment = .center
            }
            let labelReceivAddr = MainLabel(type: .table).then {
                $0.text = "배송지"
                $0.textAlignment = .center
            }
            table.tableHeaderView?.addSubviews([
                labelNum,labelCategory,labelReceivAddr
            ])
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
        
        // -MARK: makeConstraints
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        labelViewedTitle.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        labelViewedCount.snp.makeConstraints { make in
            make.bottom.equalTo(labelViewedTitle)
            make.leading.equalTo(labelViewedTitle.snp.trailing).offset(5)
        }
        tableViewedItem.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelViewedTitle.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-40)
//            make.height.equalTo(tableViewedItem.contentSize.height)
            make.height.equalTo(250)
        }
        
        labelSelectedTitle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY)
            make.leading.equalTo(labelViewedTitle)
        }
        labelSelectedCount.snp.makeConstraints { make in
            make.bottom.equalTo(labelSelectedTitle)
            make.leading.equalTo(labelSelectedTitle.snp.trailing).offset(5)
        }
        tableSelectedItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelSelectedTitle.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-40)
//            make.height.equalTo(tableSelectedItem.rowHeight)
            make.height.equalTo(240)
        }
        labelAgreement.snp.makeConstraints { make in
            make.centerY.equalTo(buttonAgree)
            make.trailing.equalTo(buttonAgree.snp.leading).offset(-10)
        }
        buttonAgree.snp.makeConstraints { make in
            make.trailing.equalTo(buttonApply).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalTo(buttonApply.snp.top).offset(-10)
        }
        buttonApply.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
            make.top.equalToSuperview().offset(mainButtonTopOffset)
        }
    }
    
    // -MARK: Selector
    @objc func touchUpApplyButton() {
        _ = selectedItems.map { item in
            applyForm?.deliveryPK.append(item.deliveryPK)
        }
        dataManager.applyTask(applyForm: applyForm!)
        navigationController?.popToRootViewController(animated: true)
        print("업무 신청하기")
    }
    @objc func touchUpAgreeButton() {
        let vc = AgreementViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .automatic
        vc.didAgree = isAgree
        vc.modalDelegate = self
        self.present(vc, animated: true)
        print("agree")
    }
}
// -MARK: extensions
extension AssignViewController {
    func successAssignItems(_ result: [Row]) {
        viewedItems = result
        addButtonEnabled = [Int](repeating: 1, count: result.count)
        labelViewedCount.text = "\(result.count)"
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
            cell.isAddbuttonEnabled = addButtonEnabled[indexPath.row]
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
        addButtonEnabled[index] = 0
        tableViewedItem.reloadData()
        selectedItems.append(viewedItems[index])
        labelSelectedCount.text = "\(selectedItems.count)"
        tableSelectedItem.beginUpdates()
        tableSelectedItem.insertRows(at: [IndexPath(row: selectedItems.count-1, section: 0)], with: .top)
        tableSelectedItem.endUpdates()
        isEnableButton()
    }
    
    func removeItems(sender: UIButton, index: Int) {
        let viewedIndex = viewedItems.firstIndex { Row in
            Row == selectedItems[index]
        }
        addButtonEnabled[viewedIndex ?? 0] = 1
        tableViewedItem.reloadData()
        selectedItems.remove(at: index)
        labelSelectedCount.text = "\(selectedItems.count)"
        tableSelectedItem.beginUpdates()
        tableSelectedItem.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
        tableSelectedItem.reloadData()
        tableSelectedItem.endUpdates()
        isEnableButton()
    }
    
    private func isEnableButton() {
        if self.isAgree == 1 && selectedItems.count != 0 {
            buttonApply.isEnabled = true
        }
        else {
            buttonApply.isEnabled = false
        }
    }
}

extension AssignViewController: AgreementDelegate {
    func doAgree(isAgree: Int) {
        switch isAgree {
        case 1:
            self.isAgree = isAgree
            buttonAgree.tintColor = .darkGray
            buttonAgree.layer.borderColor = UIColor.darkGray.cgColor
            let customButtonLabel = NSMutableAttributedString(string: " 동의 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: 15)])
            buttonAgree.setAttributedTitle(customButtonLabel, for: .normal)
        case 0:
            self.isAgree = isAgree
            buttonAgree.tintColor = .CjRed
            buttonAgree.layer.borderColor = UIColor.CjRed.cgColor
            let customButtonLabel = NSMutableAttributedString(string: " 동의 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.CjRed, NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: 15)])
            buttonAgree.setAttributedTitle(customButtonLabel, for: .normal)
        default:
            break
        }
        isEnableButton()
        print("agree here")
    }
}
