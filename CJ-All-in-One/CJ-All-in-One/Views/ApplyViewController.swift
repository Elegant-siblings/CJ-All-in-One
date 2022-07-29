//
//  ApplyViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import SnapKit
import Then

struct Location {
    let city: String
    let goo: String
}

struct ApplyDataModel {
    let deliveryPK: [Int]
    let deliveryManID: String
    let deliveryDate: String
    let deliveryType: Bool
    let deliveryTime: Bool
    let deliveryCar: String
    let terminalAddr: String
}

class ApplyViewController: UIViewController {
    
    // -MARK: Constants
    let shippingTypes: [String] = ["일반배송", "집화/반품"]
    let shippingTimes: [String] = ["주간", "새벽"]
    let vehicles: [String] = ["세단", "쿠페", "왜건", "SUV", "컨버터블", "해치백", "밴", "픽업트럭","기타"]
    let sectionInset = CGFloat(30)
    let citiesManager = CitiesManager()
    let pickerRowHeight = CGFloat(35)
    let addButtonRadius = CGFloat(17)

    
    var type: String = "일반"
    var date: Date = Date()
    var time: String = "주간"
    var count: String = "세단"
    var city: String = "서울시"
    var goo: String = "종로구"
    var toLists: [Location] = []
    
    //-MARK: UIView
    lazy var navBar = UIView().then{
        $0.backgroundColor = .deppBlue
    }
    
    lazy var labelShippingType = ApplySectionTitleLabel(title: "배송타입")
    lazy var labelDate = ApplySectionTitleLabel(title: "날짜")
    lazy var labelTime = ApplySectionTitleLabel(title: "배송시간")
    lazy var labelVehicle = ApplySectionTitleLabel(title: "배송차량")
    lazy var labelTo = ApplySectionTitleLabel(title: "배송지역")
    lazy var labelFrom = ApplySectionTitleLabel(title: "출발지역")
    
    lazy var warningLabel = UILabel().then{
        $0.text = "배송차량을 선택해주세요."
        $0.font = .systemFont(ofSize: 15, weight: .light)
        $0.textColor = .red
    }
    
    lazy var SCShippingType: UISegmentedControl = {
        let sc: UISegmentedControl = UISegmentedControl(items: shippingTypes)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(shippingTypeChanged(type:)), for: .valueChanged)
        return sc
    }()
    
    lazy var SCShippingTime: UISegmentedControl = {
        let sc: UISegmentedControl = UISegmentedControl(items: shippingTimes)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(shippingTimeChanged(time:)), for: .valueChanged)
        return sc
    }()
    
    lazy var datePicker = UIDatePicker().then{
        $0.preferredDatePickerStyle = .automatic
        $0.datePickerMode = .date
//        $0.minimumDate = Date()
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = .autoupdatingCurrent
        $0.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    lazy var textFieldVehicleType: UITextField = {
        let tf: UITextField = UITextField()
        tf.placeholder = "차량 종류를 입력하세요."
        tf.inputView = pickerAvailCount
        tf.inputAccessoryView = toolbar
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var toolbar: UIToolbar = {
        let tb: UIToolbar = UIToolbar()
        tb.barStyle = UIBarStyle.default
        tb.isTranslucent = true
        tb.sizeToFit()
        
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        tb.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        tb.isUserInteractionEnabled = true
    
        return tb
    }()
    
    lazy var applyButton = PrimaryButton(title: "업무조회").then {
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(touchUpApplyButton), for: .touchUpInside)
    }
    
    lazy var addButton = UIButton().then{
        $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        $0.layer.cornerRadius = addButtonRadius
        $0.tintColor = .CjBlue
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        $0.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        $0.addTarget(self, action: #selector(self.touchUpAddButton), for: .touchUpInside)
    }
    
    lazy var tableTo = ListTableView(rowHeight: 35, scrollType: .none)
    let pickerAvailCount = UIPickerView()
    let pickerTo = UIPickerView()
    let pickerFrom = UIPickerView()
    

    // -MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .CjWhite
        
        pickerAvailCount.delegate = self
        pickerAvailCount.dataSource = self
        pickerTo.delegate = self
        pickerTo.dataSource = self
        pickerFrom.delegate = self
        pickerFrom.dataSource = self
        tableTo.dataSource = self
        tableTo.delegate = self
        
        tableTo.register(ToListTableViewCell.self, forCellReuseIdentifier: ToListTableViewCell.identifier)
        
        // -MARK: addSubviews
        self.view.addSubviews([
            navBar,
            labelShippingType, labelDate,
            SCShippingType, datePicker,
            labelTime, SCShippingTime,
            labelVehicle, textFieldVehicleType, warningLabel,
            labelFrom, pickerFrom,
            labelTo, pickerTo, addButton, tableTo,
            applyButton
        ])
        
        setConstraints()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pickerFrom.subviews[1].backgroundColor = .clear
        
        let upLine = UIView(frame: CGRect(x: 15, y: 0, width: 150, height: 1))
        let underLine = UIView(frame: CGRect(x: 15, y: pickerRowHeight, width: 150, height: 1))
        
        upLine.backgroundColor = .CjBlue
        underLine.backgroundColor = .CjBlue
        
        pickerFrom.subviews[1].addSubview(upLine)
        pickerFrom.subviews[1].addSubview(underLine)
    }
    
    // -MARK: makeConstraints
    private func setConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
        labelShippingType.snp.makeConstraints{ make in
            make.top.equalTo(navBar.snp.bottom).offset(40)
            make.leading.equalTo(self.view).offset(20)
        }
        SCShippingType.snp.makeConstraints{ make in
            make.leading.equalTo(self.view.frame.width/2)
            make.centerY.equalTo(labelShippingType)
        }
        
        labelDate.snp.makeConstraints{ make in
            make.top.equalTo(labelShippingType.snp.bottom).offset(sectionInset)
            make.leading.equalTo(self.view).offset(20)
        }
        datePicker.snp.makeConstraints{ (make) in
            make.centerY.equalTo(labelDate)
            make.leading.equalTo(self.view.frame.width/2)
        }
        
        labelTime.snp.makeConstraints{ make in
            make.top.equalTo(datePicker.snp.bottom).offset(sectionInset)
            make.leading.equalTo(self.view).offset(20)
        }
        SCShippingTime.snp.makeConstraints{ (make) in
            make.leading.equalTo(self.view.frame.width/2)
            make.centerY.equalTo(labelTime)
        }
        
        labelVehicle.snp.makeConstraints{ make in
            make.top.equalTo(labelTime.snp.bottom).offset(38)
            make.leading.equalTo(self.view).offset(20)
        }
        textFieldVehicleType.snp.makeConstraints{ make in
            make.centerY.equalTo(labelVehicle)
            make.leading.equalTo(self.view.frame.width/2)
            make.width.equalTo(self.view.frame.width/2-8)
            make.height.equalTo(40)
        }
        warningLabel.snp.makeConstraints{ make in
            make.leading.equalTo(textFieldVehicleType).offset(1)
            make.top.equalTo(textFieldVehicleType.snp.bottom).offset(2)
        }
        
        labelFrom.snp.makeConstraints { make in
            make.top.equalTo(labelVehicle.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        pickerFrom.snp.makeConstraints { make in
            make.centerY.equalTo(labelFrom)
            make.leading.equalTo(self.view.frame.width/2)
            make.width.equalTo(self.view.frame.width/2-8)
            make.height.equalTo(pickerRowHeight+20)
        }

        labelTo.snp.makeConstraints{ make in
            make.top.equalTo(labelFrom.snp.bottom).offset(35)
            make.leading.equalTo(self.view).offset(20)
        }
        pickerTo.snp.makeConstraints{ make in
            make.centerY.equalTo(labelTo)
            make.leading.equalTo(labelTo.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(100)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(labelTo)
            make.leading.equalTo(pickerTo.snp.trailing).offset(3)
            make.width.equalTo(addButtonRadius*2)
            make.height.equalTo(addButtonRadius*2)
        }
        tableTo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-36*2)
            make.height.equalTo(tableTo.rowHeight*CGFloat(toLists.count+1))
//            make.height.equalTo(180)
            make.top.equalTo(pickerTo.snp.bottom).offset(20)
        }
        
        applyButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(755)
            make.width.equalTo(primaryButtonWidth)
            make.height.equalTo(primaryButtonHeight)
        }
    }
    
    //-MARK: #Selector
    @objc
    func shippingTypeChanged(type: UISegmentedControl) {
        var text: String = "일반"
        switch type.selectedSegmentIndex {
            case 0:
              text = "일반"
            case 1:
              text = "반품"
            default: return
        }
        self.type = text
    }
    
    @objc
    func shippingTimeChanged(time: UISegmentedControl) {
        var text: String = "주간"
        switch time.selectedSegmentIndex {
            case 0:
              text = "주간"
            case 1:
              text = "새벽"
            default: return
        }
        self.time = text
    }
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        self.date = sender.date
    }
    
    @objc func donePicker() {
        let row = self.pickerAvailCount.selectedRow(inComponent: 0)
        self.pickerAvailCount.selectRow(row, inComponent: 0, animated: false)
        self.textFieldVehicleType.text = self.vehicles[row]
        self.textFieldVehicleType.resignFirstResponder()
        self.count = textFieldVehicleType.text!
        warningLabel.textColor = .white
    }
    
    @objc func cancelPicker() {
        self.textFieldVehicleType.text = nil
        self.textFieldVehicleType.resignFirstResponder()
        warningLabel.textColor = .red
    }
    
    @objc func touchUpApplyButton() {
        print("업무조회")
        let vc = AssignViewController()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        vc.date = dateFormatter.string(from: self.date)
        vc.toLists = self.toLists

        navigationController?.pushViewController(vc, animated: true)
        
//        if textFieldVehicleType.text == "" {
//            return
//        }
//        let applyInfo = ApplyManager(type: self.type, date: self.date, time: self.time, count: self.count, city: self.city, goo: self.goo)
//        print(applyInfo)
    }
    
    @objc func touchUpAddButton() {
        print("click add button")
        toLists.append(Location(city: city, goo: goo))
        //        tableTo.reloadData()
        tableTo.beginUpdates()
        tableTo.insertRows(at: [IndexPath(row: toLists.count, section: 0)], with: .right)
        tableTo.endUpdates()
        
        tableTo.snp.updateConstraints { make in
            if tableTo.rowHeight*CGFloat(toLists.count+1) < 180 {
                make.height.equalTo(tableTo.rowHeight*CGFloat(toLists.count+1))
            }
            else {
                make.height.equalTo(180)
                tableTo.isScrollEnabled = true
            }
        }
    }
}
