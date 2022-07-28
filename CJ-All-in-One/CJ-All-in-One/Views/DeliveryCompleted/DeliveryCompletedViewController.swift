//
//  DeliveryCompletedViewController.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/25.
//

import Foundation
import UIKit
import Then
import SnapKit
import NMapsMap

class DeliveryCompletedViewController: UIViewController {
    
    static let identifier = "DeliveryCompletedViewController"
    
    // Table 정보
    let tableRowHeight = CGFloat(40)
<<<<<<< HEAD
    let titles = ["#", "라이언머그컵", "김치", "된장", "거울", "컴퓨터", "홍삼즙", "받는 주소", "요청사항"]
    let contents = ["배송지", "서울특별시 송파구 압구정로", "서울특별시 서초구 신세계", "서울특별시 관악구 서울대학교", "최** (010-2287-****)", "서울특별시 서초구 양재동 225-5", "서울특별시 서초구 양재동 225-5", "개가 뭅니다", "서울"]
    
    var mapImage = UIImage()
    
    //DeliveryPercent
    var onTime: String!
    var lowTime: String!
    var missTime: String!
=======
    let titles = ["배송기사", "송장번호", "상품정보", "보내는 분", "받는 분", "보내는 주소", "받는 주소", "요청사항"]
    let contents = ["AXSD-SDXD-****-ZS**", "1233567", "홍삼즙", "다** (053-573-****)", "최** (010-2287-****)", "서울특별시 서초구 양재동 225-5", "서울특별시 서초구 양재동 225-5", "개가 뭅니다"]
    var lists = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh"]
>>>>>>> 377993d (test)
    
    
    // UIScrollView 정의
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .deppBlue
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let scrollContentView = UIView().then {
        $0.backgroundColor = .white
    }

    //UpperView 정의
    let upperView = UIView().then {
        $0.backgroundColor = .deppBlue
    }
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    let deliverySummaryLavbel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
        $0.textColor = .white
        $0.text = "배달 요약"
    }
    let dateLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
        $0.textColor = .white
        $0.text = "2022.07.22 / 주간"
    }
    let infoView = UIView().then{
        $0.backgroundColor = .white
        $0.cornerRadius = 8
        $0.layer.addShadow(location: [.bottom, .left, .right])
    }
    let infoLabel = MainLabel(type: .main).then {
        $0.textColor = .lightGray
        $0.text = "총 수입"
    }
    let incomeLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 30)
        $0.text = "35,680원"
    }
    let accountLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 12)
        $0.text = "3333-0604-*****"
    }
    let deliveryLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 10)
        $0.textColor = .lightGray
        $0.text = "AXSD-SDXD-****-ZS**"
    }
    let separateLine1 = UIView().then {
        $0.backgroundColor = .gray
    }
    
    
    //MiddleView
<<<<<<< HEAD
    let deliveryRateLabel = MainLabel(type: .main).then {
        $0.text = "배송률"
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
        $0.textColor = .lightGray
    }
    
    let infoContainerView2 = UIView().then {
        $0.backgroundColor = .clear
    }
    let onTimeLabel = MainLabel(type: .main).then {
        $0.textColor = .black
        $0.text = "정시 배송률"
    }
    let lowTimeLabel = MainLabel(type: .main).then {
        $0.textColor = .black
        $0.text = "오배송률"
    }
    let missTimeLabel = MainLabel(type: .main).then {
        $0.textColor = .black
        $0.text = "분실률"
    }
    let onTimeImage = UIImageView().then {
        $0.image = UIImage(named: "onTimeImage")
    }
    let lowTimeImage = UIImageView().then {
        $0.image = UIImage(named: "lowTimeImage")
    }
    let missTimeImage = UIImageView().then {
        $0.image = UIImage(named: "missTimeImage")
    }
    let onTimePercentLabel = MainLabel(type: .main).then {
        $0.textColor = .CjBlue
    }
    let lowTimePercentLabel = MainLabel(type: .main).then {
        $0.textColor = .CjYellow
    }
    let missTimePercentLabel = MainLabel(type: .main).then {
        $0.textColor = .CjRed
    }
    
    
    
=======
>>>>>>> 377993d (test)
    let distanceInfoLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
        $0.textColor = .lightGray
        $0.text = "이동경로"
    }
<<<<<<< HEAD
    let mapView = UIImageView().then {
        $0.cornerRadius = 10
        $0.clipsToBounds = true
=======
    let mapView = NMFMapView().then {
        $0.cornerRadius = 15
        $0.allowsZooming = true
>>>>>>> 377993d (test)
        $0.layer.addShadow(location: [.bottom])
        $0.layer.borderWidth = 1
    }
    let totalDistanceLabel = MainLabel(type: .main).then {
        $0.text = "총 이동거리: 123km"
    }
    let totalTimeLabel = MainLabel(type: .main).then {
        $0.text = "총 이동시간: 8시간 32분"
    }
    let deliveryTimeLabel = MainLabel(type: .main).then {
        $0.text = "배송시간: 10:30 ~ 20:02"
    }
    let mealTimeLabel = MainLabel(type: .main).then {
        $0.text = "식사 시간: 30분"
    }
    let separateLine2 = UIView().then {
        $0.backgroundColor = .gray
    }
    
    //FooterView
    let verticalLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let infoContainerView1 = UIView().then {
        $0.backgroundColor = .clear
    }
    let itemCountLabel = MainLabel(type: .main).then {
<<<<<<< HEAD
=======
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 10)
>>>>>>> 377993d (test)
        $0.text = "배송 물품: 20개"

    }
    let completedItemCountLabel = MainLabel(type: .main).then {
<<<<<<< HEAD
        $0.text = "배송 완료: 17개"
    }
    let missedItemCountLabel = MainLabel(type: .main).then {
        $0.text = "미배송: 3개"

    }
=======
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 10)
        $0.text = "배송 완료: 17개"
    }
    let missedItemCountLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 10)
        $0.text = "미배송: 3개"

    }
    let infoContainerView2 = UIView().then {
        $0.backgroundColor = .clear
    }
    
>>>>>>> 377993d (test)
    
    let tableView = UITableView().then {
//        let table = ListTableView(
//            rowHeight: tableRowHeight,
//            isScrollEnabled: false)
        $0.layer.borderWidth = 0.2
<<<<<<< HEAD
        $0.layer.cornerRadius = 10
=======
        $0.layer.cornerRadius = 5
>>>>>>> 377993d (test)
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.separatorStyle = .singleLine
        $0.allowsSelection = false
        $0.clipsToBounds = true
<<<<<<< HEAD
//        $0.alwaysBounceVertical = false
//        $0.bounces = $0.contentOffset.y > 0
=======
>>>>>>> 377993d (test)
        $0.separatorColor = UIColor.customLightGray
        $0.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        $0.layer.addShadow(location: [.top, .bottom])
        $0.isScrollEnabled = true
        $0.register(DeliveryCompletedTableViewCell.self, forCellReuseIdentifier: DeliveryCompletedTableViewCell.identifier)
    }
    let separateLine3 = UIView().then {
        $0.backgroundColor = .gray
    }
    let confirmButton = MainButton(type: .main).then {
        $0.setTitle("확인", for: .normal)
        $0.layer.borderColor = UIColor.CjYellow.cgColor
        $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }

<<<<<<< HEAD
=======


>>>>>>> 377993d (test)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.topItem!.title = "배달 요약"
//        navigationItem.backBarButtonItem?.title = ""
//        navigationItem.backBarButtonItem?.tintColor = .white
//
//        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .deppBlue
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubviews([upperView, separateLine1, separateLine2, dateLabel, infoView])
        upperView.addSubviews([deliverySummaryLavbel, backButton])
        infoView.addSubviews([infoLabel, accountLabel, incomeLabel, deliveryLabel])
        
<<<<<<< HEAD
        scrollContentView.addSubviews([distanceInfoLabel, mapView, totalDistanceLabel, totalTimeLabel, deliveryTimeLabel, mealTimeLabel, verticalLine, infoContainerView1, infoContainerView2, tableView, separateLine3, confirmButton, deliveryRateLabel])
        
        infoContainerView1.addSubviews([itemCountLabel, missedItemCountLabel, completedItemCountLabel])
        infoContainerView2.addSubviews([onTimePercentLabel, missTimePercentLabel, lowTimePercentLabel, onTimeLabel, lowTimeLabel, missTimeLabel, onTimeImage, lowTimeImage, missTimeImage])
        
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
=======
        scrollContentView.addSubviews([distanceInfoLabel, mapView, totalDistanceLabel, totalTimeLabel, deliveryTimeLabel, mealTimeLabel, verticalLine, infoContainerView1, infoContainerView2, tableView, separateLine3, confirmButton])
        
        infoContainerView1.addSubviews([itemCountLabel, missedItemCountLabel, completedItemCountLabel])
        
        
        setConstraints()
>>>>>>> 377993d (test)
        presentCircleView()
    }
    
    
    func setConstraints() {
        // ScrollView
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
<<<<<<< HEAD
            make.height.equalTo(1450)
=======
            make.height.equalTo(1150)
>>>>>>> 377993d (test)
        }
        
        
        // UpperView
        upperView.snp.makeConstraints { make in
            make.top.equalTo(scrollContentView.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(218)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(upperView.snp.top).offset(15)
            make.leading.equalToSuperview().offset(24)
        }
        deliverySummaryLavbel.snp.makeConstraints { make in
            make.top.equalTo(upperView.snp.top).offset(15)
            make.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(deliverySummaryLavbel.snp.bottom).offset(10)
            make.bottom.equalTo(infoView.snp.top).offset(-15)
            make.centerX.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
<<<<<<< HEAD
            make.bottom.equalTo(upperView.snp.bottom).offset(25)
=======
            make.bottom.equalTo(upperView.snp.bottom).offset(43)
>>>>>>> 377993d (test)
            make.centerX.equalToSuperview()
            make.leading.equalTo(21)
            make.trailing.equalTo(-21)
        }
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoView.snp.top).offset(14)
        }
        incomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(16)
        }
        accountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeLabel.snp.bottom).offset(16)
        }
        deliveryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(accountLabel.snp.bottom).offset(2)
        }
        separateLine1.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(25)
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
        
        
        //MiddleView
<<<<<<< HEAD
        deliveryRateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separateLine1.snp.bottom).offset(15)
        }
        infoContainerView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(deliveryRateLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        onTimePercentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(20)
        }
        onTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(onTimePercentLabel.snp.leading).offset(-5)
            make.centerY.equalTo(onTimePercentLabel.snp.centerY)
        }
        onTimeImage.snp.makeConstraints { make in
            make.trailing.equalTo(onTimeLabel.snp.leading).offset(-5)
            make.centerY.equalTo(onTimePercentLabel.snp.centerY)
            make.height.equalTo(7)
            make.width.equalTo(7)
        }
        
        lowTimePercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(lowTimeLabel.snp.trailing).offset(5)
            make.top.equalTo(onTimePercentLabel.snp.bottom).offset(10)
        }
        lowTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(lowTimeImage.snp.trailing).offset(5)
            make.centerY.equalTo(lowTimePercentLabel.snp.centerY)
        }
        lowTimeImage.snp.makeConstraints { make in
            make.leading.equalTo(onTimeImage.snp.leading)
            make.centerY.equalTo(lowTimePercentLabel.snp.centerY)
            make.height.equalTo(7)
            make.width.equalTo(7)
        }
        
        missTimePercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(missTimeLabel.snp.trailing).offset(5)
            make.top.equalTo(lowTimePercentLabel.snp.bottom).offset(10)
        }
        missTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(missTimeImage.snp.trailing).offset(5)
            make.centerY.equalTo(missTimePercentLabel.snp.centerY)
        }
        missTimeImage.snp.makeConstraints { make in
            make.leading.equalTo(onTimeImage.snp.leading)
            make.centerY.equalTo(missTimePercentLabel.snp.centerY)
            make.height.equalTo(7)
            make.width.equalTo(7)
        }
        
        infoContainerView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoContainerView2.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(150)
        }
        itemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        completedItemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemCountLabel.snp.bottom).offset(13)
        }
        missedItemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(completedItemCountLabel.snp.bottom).offset(13)
        }
//        infoContainerView2.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(24)
//            make.top.equalTo(separateLine2.snp.bottom)
//            make.leading.equalTo(verticalLine.snp.trailing)
//            make.height.equalTo(102)
//        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(infoContainerView1.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(220)

//            make.height.equalTo(CGFloat(lists.count)*tableRowHeight)
        }
        separateLine3.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(25)
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
        
        
        //FooterView
        distanceInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separateLine3.snp.bottom).offset(15)
=======
        distanceInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separateLine1.snp.bottom).offset(15)
>>>>>>> 377993d (test)
        }
        mapView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(distanceInfoLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(220)
        }
        totalDistanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
<<<<<<< HEAD
            make.top.equalTo(mapView.snp.bottom).offset(15)
=======
            make.top.equalTo(mapView.snp.bottom).offset(8)
>>>>>>> 377993d (test)
        }
        totalTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalDistanceLabel.snp.bottom).offset(5)
        }
        deliveryTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(5)
        }
        mealTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(deliveryTimeLabel.snp.bottom).offset(5)
        }
<<<<<<< HEAD
        
        
       
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(scrollContentView.snp.bottom).offset(-30)
=======
        separateLine2.snp.makeConstraints { make in
            make.top.equalTo(mealTimeLabel.snp.bottom).offset(8)
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
        
        //FooterView
        verticalLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(92)
            make.centerX.equalToSuperview()
            make.top.equalTo(separateLine2.snp.bottom).offset(10)
        }
        infoContainerView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(separateLine2.snp.bottom)
            make.trailing.equalTo(verticalLine.snp.leading)
            make.height.equalTo(102)
        }
        itemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        completedItemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemCountLabel.snp.bottom).offset(13)
        }
        missedItemCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(completedItemCountLabel.snp.bottom).offset(13)
        }
        infoContainerView2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(24)
            make.top.equalTo(separateLine2.snp.bottom)
            make.leading.equalTo(verticalLine.snp.trailing)
            make.height.equalTo(102)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(verticalLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(220)

//            make.height.equalTo(CGFloat(lists.count)*tableRowHeight)
        }
        separateLine3.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(18)
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(scrollContentView.snp.bottom).offset(-10)
>>>>>>> 377993d (test)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func presentCircleView() {
        
<<<<<<< HEAD
        print("dsdfdsfds", infoContainerView2.frame.width, infoContainerView2.frame.height)
        
        let width = CGFloat(172)
        let height = CGFloat(102)
        
        let pieChartView = PieChartView(frame: CGRect(x: 5, y: 10, width: width, height: height))
=======
//        let width = self.infoContainerView2.frame.width
        let width = CGFloat(172)
        
//        let height = self.infoContainerView2.frame.height
        let height = CGFloat(102)
        
        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pieChartView.center = self.infoContainerView2.center
>>>>>>> 377993d (test)
        
        pieChartView.slices = [Slice(percent: 0.1, color: UIColor.CjRed),
                                Slice(percent: 0.15, color: UIColor.CjYellow),
                                Slice(percent: 0.75, color: UIColor.CjBlue)]
        
<<<<<<< HEAD
        onTimePercentLabel.text = "75%"
        lowTimePercentLabel.text = "15%"
        missTimePercentLabel.text = "10%"
        
        self.infoContainerView2.addSubview(pieChartView)
        
//        pieChartView.snp.makeConstraints { make in
//            make.top.equalTo(infoContainerView2.snp.top)
//            make.centerX.equalTo(infoContainerView2.snp.centerX)
//        }
        
=======
        self.infoContainerView2.addSubview(pieChartView)
>>>>>>> 377993d (test)
        pieChartView.animateChart()
    }
    
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirm() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension DeliveryCompletedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
<<<<<<< HEAD
        return titles.count
=======
        return lists.count
>>>>>>> 377993d (test)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCompletedTableViewCell.identifier, for: indexPath) as! DeliveryCompletedTableViewCell
//        switch indexPath.row {
//        case 0:
//            cell.backgroundColor = UIColor(rgb: 0xD9D9D9)
//            break
//        default:
//            cell.backgroundColor = .white
//        }
<<<<<<< HEAD
        
        cell.numLabel.text = "\(indexPath.row + 1)"
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentLabel.text = contents[indexPath.row]
        
        // 셀 정보 업데이트
        if indexPath.row == 0{
            cell.contentView.backgroundColor = .darkGray
            cell.checkImage.isHidden = true
            cell.confirmLabel.isHidden = false
        
            
            
            
            
            cell.numLabel.textColor = .lightGray
            cell.titleLabel.textColor = .lightGray
            cell.contentLabel.textColor = .lightGray
            
        } else {
            cell.contentView.backgroundColor = .white
            cell.checkImage.isHidden = false
            cell.confirmLabel.isHidden = true

            
            cell.numLabel.textColor = .gray
            cell.titleLabel.textColor = .gray
            cell.contentLabel.textColor = .gray
        
        }
        
=======
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentLabel.text = contents[indexPath.row]
>>>>>>> 377993d (test)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


//import SwiftUI
//
//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//    typealias UIViewControllerType = DeliveryCompletedViewController
//
//    func makeUIViewController(context: Context) -> DeliveryCompletedViewController {
//        return DeliveryCompletedViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: DeliveryCompletedViewController, context: Context) {}
//}
//
//struct ViewPreview: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ViewControllerRepresentable()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
//                .previewDisplayName("iPhone 13 Pro")
//
//            ViewControllerRepresentable()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//                .previewDisplayName("iPhone 8")
//        }
//    }
//}
//
//
//
