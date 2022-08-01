//
//  LoadViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/27.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    let seatRadius = CGFloat(10)
    let seatButtonOffset = CGFloat(3)
    let fontSizeAgree = CGFloat(14)
    let startDataManager = StartDataManager()
    let updateDataManager = UpdateDataManager()
    
    var terminalAddr = ""
    var workPK: Int?
    var isAgree = 0
    var isSeat: [Bool] = []
    var lists:[Item] = []
    let colors:[UIColor] = [.CjRed,.CjYellow,.CjBlue,.CjGreen]
    var seatNums: [Int] = []
    
    // -MARK: UIView
    lazy var navBar = CustomNavigationBar(title: "물품 차량 적재")
    
    lazy var viewImageContainer = UIView()
    lazy var viewSeatsContainer = UIView()
    lazy var imageVehicle = UIImageView(image: UIImage(named: "imageVehicle.png")).then {
        $0.layer.cornerRadius = 30
    }
    
    lazy var tableItem = ListTableView(rowHeight: 35, scrollType: .vertical).then {
        $0.dataSource = self
        $0.register(LoadItemTableViewCell.self, forCellReuseIdentifier: LoadItemTableViewCell.identifier)
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
        let labelSeat = MainLabel(type: .table).then {
            $0.text = "좌석"
        }
        $0.tableHeaderView?.addSubviews([labelNum,labelCategory,labelReceivAddr,labelSeat])
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
        labelSeat.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    // -MARK: UIButton
    lazy var buttonComplete = MainButton(type: .main).then {
        $0.setTitle("물품 적재 완료", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(touchUpCompleteButton), for: .touchUpInside)
    }
    lazy var buttonAgree = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.tintColor = UIColor(hex: 0xCCCCCC)
        $0.setTitle(" 물품 분실 및 파손에 대한 책임은 본인에 있음을 동의함", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: fontSizeAgree, weight: .bold)
        $0.setTitleColor(UIColor(hex: 0xCCCCCC), for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.addTarget(self, action: #selector(touchUpAgreeButton(_:)), for: .touchUpInside)
    }
    lazy var buttonDriver = UIButton().then {
        $0.backgroundColor = UIColor(hex: 0x888585)
        $0.layer.cornerRadius = seatRadius
        $0.addTarget(self, action: #selector(touchUpSeatButton(_:)), for: .touchUpInside)
    }
    
    lazy var buttonSeat1 = UIButton()
    lazy var buttonSeat2 = UIButton()
    lazy var buttonSeat3 = UIButton()
    lazy var buttonSeat4 = UIButton()
    
    var buttonSeats: [UIButton] {
        [buttonSeat1,buttonSeat2,buttonSeat3,buttonSeat4]
    }

    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .CjWhite
        navigationController?.navigationBar.isHidden = true
        
        view.addSubviews([
            navBar,
            viewImageContainer,
            tableItem,
            buttonAgree,
            buttonComplete
        ])
        
        viewImageContainer.addSubviews([imageVehicle,viewSeatsContainer])
        viewSeatsContainer.addSubview(buttonDriver)
        viewSeatsContainer.addSubviews(buttonSeats)
        
        isSeat = Array(repeatElement(false, count: lists.count))
        lists.forEach {
            seatNums.append(getSeatNum(pk: $0.deliveryPK)+1)
        }
        print(seatNums)
        buttonSeats.enumerated().forEach {
            $1.backgroundColor = .white
            $1.setTitle("\($0+1)", for: .normal)
            $1.layer.borderColor = colors[$0].cgColor
            $1.layer.borderWidth = 1
            $1.layer.cornerRadius = seatRadius
            $1.setAttributedTitle(
                NSMutableAttributedString(
                    string: "\($0+1)",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: colors[$0],
                        NSAttributedString.Key.font: UIFont.AppleSDGothicNeo(.bold, size: 25)
                    ]),
                for: .normal
            )
            $1.addTarget(self, action: #selector(touchUpSeatButton(_:)), for: .touchUpInside)
        }
        
        self.makeConfiguration()
    }
    // -MARK: Selectors
    @objc func touchUpCompleteButton() {
        let alert = UIAlertController(title: "배송을 시작하시겠습니까?", message: "", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default) {(_) in
            // 배송 시작 && 상태 업데이트 쿼리 보내기
            self.startDataManager.sendWorkStart(workPk: self.workPK!, manID: ManId, deliveryPKs: self.lists, seatNum: self.seatNums)
            self.updateDataManager.updateWorkState(workPK: self.workPK!, workState: 3)
            // 뷰 넘기기
            let vc = FindPathViewController()
            vc.terminalAddr = self.terminalAddr
            vc.workPK = self.workPK

            
            var deliveryPKList : [Int] = []
            for i in self.lists {
                deliveryPKList.append(i.deliveryPK)
            }
            vc.deliveryPK = deliveryPKList
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func touchUpSeatButton(_ button: UIButton) {
        buttonSeats.enumerated().forEach {
            switch $1 {
            case button:
                $1.layer.borderWidth = 3
            default:
                $1.layer.borderWidth = 1
            }
        }
        if button.currentTitle != nil {
            lists.enumerated().forEach {
                let num = getSeatNum(pk: $1.deliveryPK)
                if num+1 == Int(button.currentTitle!) {
                    isSeat[$0] = true
                }
                else {
                    isSeat[$0] = false
                }
            }
        }
        else {
            isSeat = Array(repeating: false, count: lists.count)
        }
        tableItem.reloadData()
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
    
    // -MARK: Make Constraints
    private func makeConfiguration() {
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        viewImageContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(15)
            make.width.equalTo(250)
            make.height.equalTo(350)
        }
        imageVehicle.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        viewSeatsContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(105)
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalToSuperview().offset(-80)
        }
        buttonDriver.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(viewSeatsContainer.snp.width).multipliedBy(0.5).offset(-seatButtonOffset)
        }
        buttonSeat1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.width.equalTo(viewSeatsContainer.snp.width).multipliedBy(0.5).offset(-seatButtonOffset)
        }
        buttonSeat2.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(buttonSeat1.snp.bottom).offset(seatButtonOffset*2)
            make.height.width.equalTo(viewSeatsContainer.snp.width).multipliedBy(0.5).offset(-seatButtonOffset)
        }
        buttonSeat3.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(buttonSeat1.snp.bottom).offset(seatButtonOffset*2)
            make.height.width.equalTo(viewSeatsContainer.snp.width).multipliedBy(0.5).offset(-seatButtonOffset)
        }
        buttonSeat4.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonSeat2.snp.bottom).offset(seatButtonOffset*2)
        }
        
        tableItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(205)
            make.top.equalTo(imageVehicle.snp.bottom).offset(25)
        }
        buttonAgree.snp.makeConstraints { make in
            make.bottom.equalTo(buttonComplete.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(buttonComplete)
            make.height.equalTo(20)
        }
        buttonComplete.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainButtonTopOffset)
            make.width.equalTo(mainButtonWidth)
            make.height.equalTo(mainButtonHeight)
        }
    }
    
    private func getSeatNum(pk: Int) -> Int{
        return pk%4
    }
}

extension LoadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoadItemTableViewCell.identifier, for: indexPath) as! LoadItemTableViewCell
        cell.backgroundColor = .CjWhite
        cell.labelNum.text = "\(indexPath.row+1)"
        cell.labelCategory.text = lists[indexPath.row].itemCategory
        cell.labelReceivAddr.text = lists[indexPath.row].receiverAddr
        let seat = seatNums[indexPath.row]
        cell.labelSeat.text = "\(seat)"
        cell.labelSeat.textColor = colors[seat-1]
        switch isSeat[indexPath.row] {
        case true:
            cell.layer.borderWidth = 3
            cell.layer.borderColor = colors[seat-1].cgColor
        default:
            cell.layer.borderWidth = 0
        }
        cell.selectionStyle = .none
        return cell
    }
}
