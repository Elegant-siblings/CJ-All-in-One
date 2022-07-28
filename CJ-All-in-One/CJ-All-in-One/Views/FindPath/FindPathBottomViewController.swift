//
//  BottomSheetViewController.swift
//  CJ-NaverAPI-Example
//
//  Created by 정지윤 on 2022/07/23.
//

import Foundation
import PanModal
import Then
import SnapKit

class FindPathBottomViewController: UIViewController {
    
    weak var delegate : ViewDelegate!
    weak var tableDelegate: TableViewDelegate!
    
    // Table 정보
    let tableRowHeight = CGFloat(40)
    let titles = ["라이언머그컵", "김치", "된장", "거울", "컴퓨터", "홍삼즙", "받는 주소", "요청사항"]
    let contents = ["서울특별시 송파구 압구정로", "서울특별시 서초구 신세계", "서울특별시 관악구 서울대학교", "최** (010-2287-****)", "서울특별시 서초구 양재동 225-5", "서울특별시 서초구 양재동 225-5", "개가 뭅니다", "서울"]
    var ways = [1, 1, 2, 2, 3, 3, 4, 4]
    var colors : [UIColor] = [UIColor.pathRed, UIColor.pathYellow, UIColor.pathPink, UIColor.pathGreen, UIColor.pathBlue, UIColor.pathBlack]
    
    // Bool Variable
    var onDelivery : Bool = true
    
    // Other Variable
    var distance: String!
    var time: String!
<<<<<<< HEAD
=======
    
>>>>>>> 36da96d (test)
    //MARK: - 컴포넌트 정의
    
    let tableView = UITableView().then {
//        let table = ListTableView(
//            rowHeight: tableRowHeight,
//            isScrollEnabled: false)
        $0.layer.borderWidth = 0.2
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.separatorStyle = .singleLine
        $0.allowsSelection = true
        $0.separatorColor = UIColor.customLightGray
        $0.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        $0.layer.addShadow(location: [.top, .bottom])
        $0.isScrollEnabled = true
        $0.register(FindPathBottomTableViewCell.self, forCellReuseIdentifier: FindPathBottomTableViewCell.identifier)
    }
    
    let leftDeliveryItemsLabel = MainLabel(type: .main).then {
        $0.text = "남은 배송 물품 10개"
        $0.textColor = .black
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 16)
    }
    
    let leftDistanceLabel = MainLabel(type: .main).then {
        $0.text = "남은 이동 거리: 127km"
        $0.textColor = .black
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 16)
    }
    
    let deliveryEndTimeLabel = MainLabel(type: .main).then {
        $0.text = "예상 소요 시간: 12:30"
        $0.textColor = .black
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 16)
    }
    
    let deliveryIngButton = MainButton(type: .sub).then {
        $0.backgroundColor = .CjRed
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.setTitle("배송중", for: .normal)
        $0.addTarget(self, action: #selector(toggleDeliveryStatus), for: .touchUpInside)
    }
    let eatingMealButton = MainButton(type: .sub).then {
        $0.backgroundColor = .white
        $0.setTitleColor(.CjRed, for: .normal)
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.setTitle("식사중", for: .normal)
        $0.addTarget(self, action: #selector(toggleDeliveryStatus), for: .touchUpInside)
    }
    let deliveryCompletedButton = MainButton(type: .main).then {
        $0.backgroundColor = .customLightGray
        $0.layer.borderColor = UIColor.customLightGray.cgColor
        $0.setTitle("배달 완료", for: .normal)
        $0.addTarget(self, action: #selector(deliveryCompleted), for: .touchUpInside)
    }
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([tableView, leftDistanceLabel, leftDeliveryItemsLabel, deliveryEndTimeLabel, deliveryIngButton, eatingMealButton, deliveryCompletedButton])
        
        
        setConstraints()
        
        leftDistanceLabel.text = "남은 이동거리: \(distance!)"
        deliveryEndTimeLabel.text = "예상 소요시간: \(time!)"
        
    }
    
    func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(280)

//            make.height.equalTo(CGFloat(lists.count)*tableRowHeight)
        }
        
        //UIButton
        deliveryCompletedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.trailing.equalTo(self.view).offset(-24)
            make.leading.equalTo(self.view).offset(24)
        }
        deliveryIngButton.snp.makeConstraints { make in
            make.leading.equalTo(deliveryCompletedButton.snp.leading)
            make.bottom.equalTo(deliveryCompletedButton.snp.top).offset(-8)
            make.trailing.equalTo(self.view.snp.centerX).offset(-5)
        }
        eatingMealButton.snp.makeConstraints { make in
            make.trailing.equalTo(deliveryCompletedButton.snp.trailing)
            make.centerY.equalTo(deliveryIngButton.snp.centerY)
            make.leading.equalTo(self.view.snp.centerX).offset(5)
        }
        
        //UILabel
        leftDeliveryItemsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(leftDistanceLabel.snp.top).offset(-12)
        }
        leftDistanceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(deliveryEndTimeLabel.snp.top).offset(-12)
        }
        deliveryEndTimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(deliveryIngButton.snp.top).offset(-12)
        }
    }
    
    
    @objc func toggleDeliveryStatus() {
        if !onDelivery {
            deliveryIngButton.backgroundColor = .white
            deliveryIngButton.setTitleColor(.CjRed, for: .normal)

            eatingMealButton.backgroundColor = .CjRed
            eatingMealButton.setTitleColor(.white, for: .normal)

        } else {
            deliveryIngButton.backgroundColor = .CjRed
            deliveryIngButton.setTitleColor(.white, for: .normal)

            eatingMealButton.backgroundColor = .white
            eatingMealButton.setTitleColor(.CjRed, for: .normal)

        }
        onDelivery = !onDelivery
    }
    
    @objc func deliveryCompleted() {
        print("pushed")
        self.dismiss(animated: true)
        delegate.pushed()
    }
}


extension FindPathBottomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindPathBottomTableViewCell.identifier, for: indexPath) as! FindPathBottomTableViewCell
//        switch indexPath.row {
//        case 0:
//            cell.backgroundColor = UIColor(rgb: 0xD9D9D9)
//            break
//        default:
//            cell.backgroundColor = .white
//        }
        cell.selectionStyle = .none
        
        // 셀 정보 업데이트
        cell.numLabel.text = "\(indexPath.row + 1)"
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentLabel.text = contents[indexPath.row]
        cell.wayLabel.text = "\(ways[indexPath.row])"
        cell.wayLabel.textColor = colors[ways[indexPath.row]-1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.dismiss(animated: true)
        tableDelegate.cellTouched()
    }
}



// MARK: - PanModalPresentable
extension FindPathBottomViewController: PanModalPresentable {
    
    
    // 스크롤되는 tableview 나 collectionview 가 있다면 여기에 넣어주면 PanModal 이 모달과 스크롤 뷰 사이에서 팬 제스처를 원활하게 전환합니다.
    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(220)
    }
    
    var allowsTapToDismiss: Bool {
        return true
    }
//
    var longFormHeight : PanModalHeight {
        return .contentHeight(500)
    }

//    var longFormHeight: PanModalHeight {
//        return .maxHeightWithTopInset(40)
//    }
    
    
    var shouldRoundTopCorners: Bool {
        return true
    }
    
        
    // BottomSheet 호출 시 백그라운드 색상 지정
    var panModalBackgroundColor: UIColor {
        return UIColor.clear
    }
    
    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }


}
