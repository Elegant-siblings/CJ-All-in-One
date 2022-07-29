//
//  DeliveryDetailTableViewCell.swift
//  CJ-All-in-One
//
//  Created by 안현주 on 2022/07/26.
//

import UIKit
import SnapKit

protocol DetailDelegate {
    func getTaskDetail(whatTask: Task)
}

class DeliveryDetailTableViewCell: UITableViewCell {
    
    static let identifier = "DeliveryDetailTableViewCell"
    
    // -MARK: Constants
    var detailDelegate: DetailDelegate?
    let year = "2022"
    let date = "7.2"
    let day = "목요일"
    let delInfo = "주간 / 스타렉스 (12인승)"
    let address = "부산 금정구 장전동"
    let delType = "일반 배송"
    let state = "모집확정"
    let stateText = ["모집 확정", "모집 취소", "배송 완료"]
    let stateColor = [UIColor.CjBlue,UIColor.CjRed,UIColor.CjGreen]
    var task: Task = Task(workPK: 0, deliveryDate: "", deliveryType: "", deliveryTime: "", deliveryCar: "", terminalAddr: "", workState: 0, comment: "")
    
    // -MARK: UIView
    lazy var colorBar = UIView().then{
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 6
        $0.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    lazy var disLine = UIView().then{
        $0.backgroundColor = UIColor(rgb: 0xDDDDDD)
    }
    lazy var viewheader = UIView()
    lazy var viewState = UIView().then {
        $0.backgroundColor = .CjBlue
        $0.layer.cornerRadius = 21
    }
    
    // -MARK: UILabel
    lazy var  labelDate = UILabel().then{
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    lazy var labelYear = UILabel().then{
        $0.font = .systemFont(ofSize: 9, weight: .bold)
    }
    lazy var labelDay = UILabel().then{
        $0.font = .systemFont(ofSize: 11, weight: .light)
    }
    lazy var labelInfo = UILabel().then{
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    lazy var labelAddress = UILabel().then{
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = UIColor(rgb: 0xB4B4B4)
    }
    lazy var labeldelType = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    lazy var labelState = UILabel().then{
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([colorBar])

        colorBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
        
        contentView.addSubviews([
            viewheader,
            disLine,
            labelInfo,
            labelAddress,
            labeldelType,
            viewState
        ])

        viewheader.addSubviews([labelYear, labelDate, labelDay])
        viewState.addSubview(labelState)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpContentView))
        contentView.addGestureRecognizer(tapGesture)
        
        // -MARK: Make Constraints
        viewheader.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.width.equalTo(73)
            make.top.equalTo(colorBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        labelYear.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.centerX.equalToSuperview()
//            make.leading.equalTo(28)
        }
        labelDate.snp.makeConstraints { make in
            make.centerX.equalTo(labelYear)
            make.top.equalTo(labelYear.snp.bottom).offset(2)
        }
        labelDay.snp.makeConstraints { make in
            make.centerX.equalTo(labelYear)
            make.top.equalTo(labelDate.snp.bottom).offset(2)
        }
        disLine.snp.makeConstraints { make in
            make.leading.equalTo(viewheader.snp.trailing)
            make.width.equalTo(1)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(59)
        }
        labelAddress.snp.makeConstraints { make in
            make.leading.equalTo(viewheader.snp.trailing).offset(10)
            make.centerY.equalTo(viewheader)
        }
        labelInfo.snp.makeConstraints { make in
            make.leading.equalTo(labelAddress)
            make.bottom.equalTo(labelAddress.snp.top).offset(-5)
        }
        labeldelType.snp.makeConstraints { make in
            make.leading.equalTo(labelAddress)
            make.top.equalTo(labelAddress.snp.bottom).offset(5)
        }
        viewState.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.centerY.equalTo(viewheader)
            make.leading.equalTo(293)
        }
        labelState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let convertedDate = dateFormatter.date(from: task.deliveryDate)
        dateFormatter.dateFormat = "yyyy"
        labelYear.text = dateFormatter.string(from: convertedDate!)
        dateFormatter.dateFormat = "M.d"
        labelDate.text = dateFormatter.string(from: convertedDate!)
        dateFormatter.dateFormat = "EEEE"
        labelDay.text = dateFormatter.string(from: convertedDate!)
        labelInfo.text = task.deliveryTime + " / " + task.deliveryCar
        labelAddress.text = task.terminalAddr
        labeldelType.text = task.deliveryType
        labelState.text = state
        
        viewState.backgroundColor = stateColor[task.workState]
        colorBar.backgroundColor = stateColor[task.workState]
        labelState.text = stateText[task.workState]
        
        contentView.backgroundColor = .CjWhite
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.25
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
    }
    
    @objc func touchUpContentView() {
        detailDelegate?.getTaskDetail(whatTask: self.task)
    }
}
