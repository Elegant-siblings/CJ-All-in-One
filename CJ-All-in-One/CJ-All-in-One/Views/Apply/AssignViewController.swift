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
    var text = "OOOO주식회사(이하 “갑”이라 함)와 OOOO주식회사(이하 “을”이라 함)는 컴퓨터시스템의 소프트웨어 개발업무 위탁에 관하여 다음과 같이 계약을 체결한다.\n\n제1조[목적] \n갑은 을에 대해서 별지목록 (1)기재의 컴퓨터시스템(이하 “본 건 시스템”이라 함)의 개발 업무(이하 “본 건 업무”라 함)를 위탁하고 을은 이것을 수탁한다.\n\n제2조[기한 등]\n을은 본 건 업무를 별지목록 (2)기재의 스케줄에 따라 성실하게 실시한다. 단, 사양의 변경 기타사유에 의해 기한까지 본 건 시스템을 갑에게 납품할 수 없는 경우에는 갑,을 협의 후 기한을 변경할 수가 있다.\n\n제3조[위탁료]\n① 갑은 을에 대해 본 건 업무의 위탁료로써 총금액 OOO,OOO,OOO원을 다음과 같이 지불한다.\n    (1) 본 계약 체결과 동시에 금 OOO,OOO,OOO원\n    (2) 20OO 년 OO월 OO일까지 금OOO,OOO,OOO원\n    (3) 본 건 시스템의 검수 후 OO일 이내에 금 OOO,OOO,OOO원\n② 별지목록기재의 본 건 시스템의 사양, 설계 등이 변경되었을 경우는 옳은 재견적을하여 앞 항 기재의 위탁료 및 지불방법의 변경을 청구할 수가 있다.\n③ 앞 항의 경우 갑 및 을은 신속하게 변경계약을 체결하기로 한다.    \n\n제4조[재위탁의 금지]\n을은 사전에 갑으로부터 서면에 의한 승낙을 얻지 않고 본 건업무의 전부 또는 일부를 제3자에게 위탁해서는 안된다.\n\n제5조[자료의 보관, 관리]\n을은 본 건 업무에 관해서 갑으로부터 제공된 서류, 도면, 정보, 데이터 기타 모든 자료를 선량한 관리자의 주의의무로 보관, 관리하고 사전에 갑으로부터 서면에 의한 승낙을 얻지 않고 복제하거나 반출 혹은 본 건 업무 이외에 목적으로 사용해서는 안된다.\n\n제7조[검수]\n ① 갑은 본 건 시스템의 납품 후 OO일 이내에 검사를 하고 하자가 있는 경우에는 지체없이 을에게 통지한다. \n ② 을은 앞 항의 통지가 있을 때에는 곧바로 필요한 수정을 하고 갑,을 별도의 협의를하여 정해진 기한까지 재납품한다. \n ③ 제1항의 검사기간 내에 갑으로부터 을에게 어떤 통지가 이루어지지 않았을 때에는 납품한 본 건 시스템이 검사에 합격한 것으로 간주한다. 이 경우에는 검사기간이 경과한 날의 익일에 검수가 된 것으로 간주한다.\n ④ 제1항의 검사가 완료하였을 때에는 갑은 을에 대해서 검사완료 통지서를 발행하고 그 통지서의 발행일로 검수가 된 것으로 간주한다."
    
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
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
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
        $0.setTitle(" 동의 ", for: .normal)
        $0.setTitleColor(.CjRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }
    lazy var buttonApply = MainButton(type: .main).then {
        $0.setTitle("업무 신청하기", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(touchUpApplyButton), for: .touchUpInside)
    }
    
    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        vc.labelContent.text = text
        vc.agreeTitle = "위탁 계약 동의서"
        self.present(vc, animated: true)
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
            buttonAgree.setTitleColor(.darkGray, for: .normal)
        case 0:
            self.isAgree = isAgree
            buttonAgree.tintColor = .CjRed
            buttonAgree.layer.borderColor = UIColor.CjRed.cgColor
            buttonAgree.setTitleColor(.CjRed, for: .normal)
        default:
            break
        }
        isEnableButton()
    }
}
