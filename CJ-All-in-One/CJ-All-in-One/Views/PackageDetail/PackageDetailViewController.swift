//
//  PackageDetailViewController.swift
//  CJ-All-in-One
//
//  Created by 정지윤 on 2022/07/27.
//

import Foundation
import UIKit
import SnapKit
import Then

class PackageDetailViewController: UIViewController {
    
//    let containerView = UIView().then {
//        $0.backgroundColor = .clear
//    }
//
    // Table 정보
    let tableRowHeight = CGFloat(40)
    let titles = ["배송기사", "송장번호", "상품정보", "보내는 분", "받는 분", "사진"]
    let contents = ["AXSD-SDXD-****-ZS**", "1233567", "홍삼즙", "다** (053-573-****)", "최** (010-2287-****)", "아아아아아"]
    
    
    let navigationView = UIView().then {
        $0.backgroundColor = .deppBlue
    }
    let completedLabel = MainLabel(type: .main).then {
        $0.text = "물품 상세 내역"
        $0.textColor = .white
        $0.font = UIFont.AppleSDGothicNeo(.bold, size: 20)
    }
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    //Basic Info View
    let basicInfoLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 15)
        $0.text = "기본 정보"
        $0.textColor = .lightGray
    }
    let basicTableView = UITableView().then {
//        let table = ListTableView(
//            rowHeight: tableRowHeight,
//            isScrollEnabled: false)
        $0.layer.borderWidth = 0.2
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.separatorStyle = .singleLine
        $0.allowsSelection = false
        $0.separatorColor = UIColor.customLightGray
        $0.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        $0.layer.addShadow(location: [.top, .bottom])
        $0.isScrollEnabled = true
        $0.register(PackageBasicTableViewCell.self, forCellReuseIdentifier: PackageBasicTableViewCell.identifier)
    }
    
    
    //Delivery Info View
    let deliveryInfoLabel = MainLabel(type: .main).then {
        $0.font = UIFont.AppleSDGothicNeo(.regular, size: 15)
        $0.text = "배송 정보"
        $0.textColor = .lightGray
    }
    let deliveryTableView = UITableView().then {
//        let table = ListTableView(
//            rowHeight: tableRowHeight,
//            isScrollEnabled: false)
        $0.layer.borderWidth = 0.2
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.separatorStyle = .singleLine
        $0.allowsSelection = false
        $0.separatorColor = UIColor.customLightGray
        $0.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        $0.layer.addShadow(location: [.top, .bottom])
        $0.isScrollEnabled = true
        $0.register(PackageDeliveryTableViewCell.self, forCellReuseIdentifier: PackageDeliveryTableViewCell.identifier)
    }
    
    
    //Button
    let completedButton = MainButton(type: .main).then {
        $0.backgroundColor = .CjBlue
        $0.layer.borderColor = UIColor.CjBlue.cgColor
        $0.setTitle("배송완료", for: .normal)
    }
    let declinedButton = MainButton(type: .sub).then {
        $0.backgroundColor = .CjYellow
        $0.layer.borderColor = UIColor.CjYellow.cgColor
        $0.setTitle("수취거부", for: .normal)
    }
    let missedButton = MainButton(type: .sub).then {
        $0.backgroundColor = .CjRed
        $0.layer.borderColor = UIColor.CjRed.cgColor
        $0.setTitle("미배송", for: .normal)
    }
    
    //셀 내 이미지
    let packageImage = UIImageView().then {
        $0.image = UIImage(named: "selectPhoto")
        $0.cornerRadius = 10
        $0.clipsToBounds = true
    }
    let packageImageTouch = UIButton().then {
        $0.backgroundColor = .clear
        $0.cornerRadius = 10
        $0.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
    }
    let cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "defaultPhoto"), for: .normal)
        $0.cornerRadius = 10
        $0.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        
        basicTableView.dataSource = self
        basicTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.delegate = self

        
//        view.addSubviews([containerView])
        
        self.view.addSubviews([navigationView, basicInfoLabel, basicTableView, deliveryInfoLabel, deliveryTableView, missedButton, declinedButton, completedButton])
        navigationView.addSubviews([backButton, completedLabel])
        
        
        setConstraints()
//        containerView.snp.makeConstraints { make in
//            make.leading.equalTo(self.view)
//            make.trailing.equalTo(self.view)
//            make.top.equalTo(self.view)
//            make.height.equalTo(200)
//        }
    
//        presentCircleView()
        
    }
    
    
//    private func presentCircleView() {
//        let width = self.containerView.frame.width / 2
//        let height = self.containerView.frame.height / 2
//
//        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
////        pieChartView.center = self.view.center
//
//        pieChartView.slices = [Slice(percent: 0.75, color: UIColor.systemOrange),
//                                Slice(percent: 0.1, color: UIColor.systemTeal),
//                                Slice(percent: 0.15, color: UIColor.systemRed)]
//
//        containerView.addSubview(pieChartView)
//        pieChartView.animateChart()
//    }
    
    func setConstraints( ){
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(90)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.bottom.equalTo(navigationView.snp.bottom).offset(-15)
            make.leading.equalToSuperview().offset(24)
        }
        completedLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navigationView.snp.centerX)
            make.bottom.equalTo(navigationView.snp.bottom).offset(-10)
        }
        missedButton.snp.makeConstraints { make in
            make.centerY.equalTo(declinedButton.snp.centerY)
            make.leading.equalTo(self.view.snp.centerX).offset(5)
//            make.leading.equalTo(self.view).offset(5)
//            make.width.equalTo(100)
            make.trailing.equalTo(self.view).offset(-24)
        }
        declinedButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30)
            make.trailing.equalTo(self.view.snp.centerX).offset(-5)
//            make.width.equalTo(100)
            make.leading.equalTo(self.view).offset(24)
        }
        completedButton.snp.makeConstraints { make in
            make.bottom.equalTo(declinedButton.snp.top).offset(-5)
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
        }
        
        basicInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(20)
            make.leading.equalTo(self.view).offset(24)
        }
        basicTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.top.equalTo(basicInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(249)
        }
        deliveryInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(basicTableView.snp.bottom).offset(30)
            make.leading.equalTo(self.view).offset(24)
        }
        deliveryTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.top.equalTo(deliveryInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(234)
        }
        
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectPhoto() {
        print("photo selected")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self //3
        // imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc func showCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.cameraCaptureMode = .photo
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

extension PackageDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == basicTableView {
            return titles.count
        } else {
            return titles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == basicTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageBasicTableViewCell.identifier, for: indexPath) as! PackageBasicTableViewCell
    
            cell.titleLabel.text = titles[indexPath.row]
            cell.contentLabel.text = contents[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDeliveryTableViewCell.identifier, for: indexPath) as! PackageDeliveryTableViewCell
    
            cell.titleLabel.text = titles[indexPath.row]
            
            // 사진 올리기
            if indexPath.row == 5 {
                
                cell.contentView.addSubviews([packageImage, packageImageTouch, cameraButton])
                
                packageImage.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(75)
                    make.height.equalTo(60)
                    make.width.equalTo(60)
                }
                packageImageTouch.snp.makeConstraints { make in
                    make.edges.equalTo(packageImage)
                }
                cameraButton.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(150)
                    make.height.equalTo(60)
                    make.width.equalTo(60)
                }
                
                
            } else if indexPath.row == 1 {
                cell.contentLabel.text = "배송완료"
                cell.contentLabel.textColor = .CjBlue
            } else {
                cell.contentLabel.text = contents[indexPath.row]
            }
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == deliveryTableView {
            if indexPath.row == 5 {
                return 80
            }
        }
        return 40
    }
}

extension PackageDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            packageImage.contentMode = .scaleToFill
            packageImage.image = pickedImage //4
        }
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
