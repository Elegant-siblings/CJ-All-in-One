//
//  ApplyViewController.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import SnapKit
import Then

struct CitiesManager {
    let cities = [
        City(name: "서울시", goos: ["종로구", "중구", "용산구", "성동구", "광진구", "동대문구", "중랑구", "성북구", "강북구", "도봉구", "노원구", "은평구", "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구","강동구"]),
        City(name: "부산시", goos: ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"]),
        City(name: "대구시", goos: ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"]),
        City(name: "인천시", goos: ["중구", "동구", "남구", "미추홀구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"]),
        City(name: "광주시", goos: ["동구", "서구", "남구", "북구", "광산구"]),
        City(name: "대전시", goos: ["동구", "중구", "서구", "유성구", "대덕구"]),
        City(name: "울산시", goos: ["중구", "남구", "동구", "북구", "울주군"])
    ]
}

struct City {
    let name: String
    let goos: [String]
}

struct Location {
    let city: String
    let goo: String
}

struct ApplyManager {
    let type: String
    let date: Date
    let time: String
    let count: String
    let city: String
    let goo: String
}

class ApplyViewController: UIViewController {
    
    // -MARK: Constants
    let shippingTypes: [String] = ["일반배송", "집화/반품"]
    let shippingTimes: [String] = ["주간", "새벽"]
    let avaiables: [String] = ["세단", "쿠페", "왜건", "SUV", "컨버터블", "해치백", "밴", "픽업트럭","기타"]
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
    var toLists: [Location] = [
//        Location.init(city: "부산시", goo: "금정구"),
//        Location(city: "부산시", goo: "북구")
    ]
    
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
        $0.minimumDate = Date()
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
    
    lazy var tableTo = ListTableView(rowHeight: 35, isScrollEnabled: false)
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
        self.textFieldVehicleType.text = self.avaiables[row]
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
        if textFieldVehicleType.text == "" {
            return
        }
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

// -MARK: extensions

extension ApplyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toLists.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToListTableViewCell.identifier, for: indexPath) as! ToListTableViewCell
        print("cellForRowAt \(indexPath.row)")
        cell.rowIndex = indexPath.row
        if indexPath.row == 0 {
            print("indexPa 0")
            cell.backgroundColor = .firstRowBackgroundColor
            cell.labelNum.text = "#"
            cell.labelTo.text = "배송지역"
            cell.fontSize = CGFloat(15)
            cell.fontColor = UIColor.tableTitleTextColor
//            cell.removeButton.isHidden = true
        }
        else {
            cell.backgroundColor = .CjWhite
            cell.labelNum.text = "\(indexPath.row)"
            cell.labelTo.text = toLists[indexPath.row-1].city + " " + toLists[indexPath.row-1].goo
            cell.fontSize = CGFloat(13)
            cell.fontColor = UIColor.tableContentTextColor
//            cell.cellDelegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//           let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
//               self.toLists.remove(at: indexPath.row-1)
//                   tableView.deleteRows(at: [indexPath], with: .automatic)
//                completion(true)
//            }
//
////            action.backgroundColor = .white
////            action.image = #imageLiteral(resourceName: "Delete
//
//            let configuration = UISwipeActionsConfiguration(actions: [action])
//            configuration.performsFirstActionWithFullSwipe = false
//            return configuration
//       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 && toLists.isEmpty != true {
            toLists.remove(at: indexPath.row-1)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.reloadData()
            tableView.endUpdates()
            
            tableView.snp.updateConstraints { make in
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
}


extension ApplyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerTo {
            return 2
        }
        else {
            return 1
        }
    }
    // pickerview의 선택지는 데이터의 개수만큼
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerAvailCount {
            return avaiables.count
        }
        else if pickerView == pickerTo {
            if component==0 {
                return citiesManager.cities.count
            }
            else {
                let selectedCity = pickerTo.selectedRow(inComponent: 0)
                return citiesManager.cities[selectedCity].goos.count
            }
        }
        else {
            return citiesManager.cities.count
        }
    }
    // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == pickerAvailCount {
//            return avaiables[row]
//        }
//        else if pickerView == pickerTo{
//            if component == 0 {
//                return citiesManager.cities[row].name
//            }
//            else {
//                let selectedCity = pickerTo.selectedRow(inComponent: 0)
//                return citiesManager.cities[selectedCity].goos[row]
//            }
//        }
//        else {
//            return citiesManager.cities[row].name
//        }
//    }
    // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerAvailCount {
            self.textFieldVehicleType.text = self.avaiables[row]
            warningLabel.textColor = .white
        }
        else if pickerView == pickerTo{
            if component == 0 {
                pickerTo.selectRow(0, inComponent: 1, animated: false)
            }

            let cityIdx = pickerTo.selectedRow(inComponent: 0)
            let selectedCity = citiesManager.cities[cityIdx].name
            let gooIdx = pickerTo.selectedRow(inComponent: 1)
            let selectedGoo = citiesManager.cities[cityIdx].goos[gooIdx]
            self.city = selectedCity
            self.goo = selectedGoo
            
            pickerTo.reloadComponent(1)
        }
        else {
            print(citiesManager.cities[row].name)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight
    }
   
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//        var title: String = ""
//        if pickerView == pickerAvailCount {
//            title = avaiables[row]
//        }
//        else if pickerView == pickerFrom {
//            title = citiesManager.cities[row].name
//        }
//        if pickerView == pickerTo{
//            if component == 0 {
//                title = citiesManager.cities[row].name
//                pickerTo.reloadComponent(1)
//            }
//            else {
//                let selectedCity = pickerTo.selectedRow(inComponent: 0)
//                title = citiesManager.cities[selectedCity].goos[row]
//            }
//        }
//        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 5, weight: .medium)])
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: pickerRowHeight))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: pickerRowHeight))
        if pickerView == pickerAvailCount {
            label.text = avaiables[row]
        }
        else if pickerView == pickerFrom {
            label.text = citiesManager.cities[row].name
        }
        if pickerView == pickerTo{
            if component == 0 {
                label.text = citiesManager.cities[row].name
                pickerTo.reloadComponent(1)
            }
            else {
                let selectedCity = pickerTo.selectedRow(inComponent: 0)
                label.text = citiesManager.cities[selectedCity].goos[row]
            }
        }
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80
    }
}
